import Foundation
import Capacitor
import PassKit
import StoreKit

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(ApplePayPlugin)
public class ApplePayPlugin: CAPPlugin, CAPBridgedPlugin, PKPaymentAuthorizationViewControllerDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    public let identifier = "ApplePayPlugin"
    public let jsName = "ApplePay"
    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(name: "echo", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "canMakePayments", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "showApplePaySheet", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "showInAppPurchaseSheet", returnType: CAPPluginReturnPromise)
    ]
    private let implementation = ApplePay()

    @objc func echo(_ call: CAPPluginCall) {
        let value = call.getString("value") ?? ""
        call.resolve([
            "value": implementation.echo(value)
        ])
    }
    
    @objc func canMakePayments(_ call: CAPPluginCall) {
        let canMakePayments = PKPaymentAuthorizationViewController.canMakePayments()
        call.resolve([
            "canMakePayments": implementation.canMakePayments(canMakePayments)
        ])
    }

  @objc func showApplePaySheet(_ call: CAPPluginCall) {
    guard PKPaymentAuthorizationViewController.canMakePayments() else {
      call.reject("Apple Pay is not available on this device")
      return
    }
    
    guard let merchantIdentifier = call.getString("merchantId"),
          let countryCode = call.getString("countryCode"),
          let currencyCode = call.getString("currencyCode"),
          let supportedNetworks = call.getArray("supportedNetworks", String.self) else {
      call.reject("Missing required parameters")
      return
    }
    let paymentRequest = PKPaymentRequest()
    paymentRequest.merchantIdentifier = merchantIdentifier
    paymentRequest.supportedNetworks = supportedNetworks.map { PKPaymentNetwork(rawValue: $0) }
    paymentRequest.merchantCapabilities = .capability3DS
    paymentRequest.countryCode = countryCode
    paymentRequest.currencyCode = currencyCode
    
    // Add payment summary items
    if let singlePayments = call.getArray("paymentSummaryItems", [String: Any].self) {
      paymentRequest.paymentSummaryItems = singlePayments.compactMap{ item in
        guard let label = item["label"] as? String,
              let amountString = item["amount"] as? String,
              let amount = NSDecimalNumber(string: amountString) as? NSDecimalNumber else {
          return nil
        }
        return PKPaymentSummaryItem(label: label, amount: amount)
      }
    }
    // Add recurring summary items if provided
    else if let recurringSummaryItems = call.getArray("recurringSummaryItems", [String: Any].self) {
      if #available(iOS 16.0, *) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        var recurringPaymentsToAdd: [PKRecurringPaymentSummaryItem] = []
        recurringSummaryItems.forEach{ item in
          guard let label = item["label"] as? String,
                let amountString = item["amount"] as? String,
                let amount = NSDecimalNumber(string: amountString) as? NSDecimalNumber,
                let startDateString = item["startDate"] as? String,
                let intervalUnitString = item["intervalUnit"] as? String,                
                let url = URL(string: item["managementURL"] as! String) else {
            call.reject("Invalid recurring payment item")
            return
          }
          var intervalCount = 1
          if (item["intervalCount"] != nil) {
            guard let passedInCount = item["intervalCount"] as? Int else {
              call.reject("Invalid interval count: \(item["intervalCount"]!)")
              return
            }
            intervalCount = passedInCount
          }
          guard let startDate = formatter.date(from: startDateString) else {
              call.reject("Invalid date format for startDate: \(startDateString)")
              return
          }
          // get interval unit
          var intervalUnit: NSCalendar.Unit = .month
          if (intervalUnitString == "day") {
            intervalUnit = .day
          } else if (intervalUnitString == "year") {
            intervalUnit = .year
          } else if (intervalUnitString == "hour") {
            intervalUnit = .hour
          } else if (intervalUnitString == "minute") {
            intervalUnit = .minute
          }
          let recurringItem = PKRecurringPaymentSummaryItem(label: label, amount: amount)
          recurringItem.startDate = startDate
          recurringItem.intervalUnit = intervalUnit
          recurringItem.intervalCount = intervalCount
          if (paymentRequest.recurringPaymentRequest == nil) {
            let recurringPaymentRequest = PKRecurringPaymentRequest(paymentDescription:label, regularBilling:recurringItem, managementURL: url)
            paymentRequest.recurringPaymentRequest = recurringPaymentRequest
          }
          recurringPaymentsToAdd.append(recurringItem)
        }
        paymentRequest.paymentSummaryItems = recurringPaymentsToAdd
        
      } else {
        call.reject("Recurring payments are not supported on version of iOS")
      }
        
    }
      
    guard let paymentVC = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest) else {
      call.reject("Failed to create payment authorization view controller")
      return
    }
    paymentVC.delegate = self
    DispatchQueue.main.async {
      self.bridge?.viewController?.present(paymentVC, animated: true, completion: nil)
    }
      call.resolve([
        "success": true
      ])
    }

  @objc func showInAppPurchaseSheet(_ call: CAPPluginCall) {
    guard let productIdentifiers = call.getArray("productIdentifiers", String.self) else {
      call.reject("Missing required parameters")
      return
    }
    fetchProducts(productIdentifiers: productIdentifiers)
  }

  private func fetchProducts(productIdentifiers: [String]) {
    let productIdentifiersSet = Set(productIdentifiers)
    let productRequest = SKProductsRequest(productIdentifiers: productIdentifiersSet)
    productRequest.delegate = self
    productRequest.start()
  }
  

  public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
    let availableProducts = response.products
    if availableProducts.isEmpty {
        // Handle no products found
        return
    }
    // Display the products to the user and allow them to make a purchase
    // For simplicity, we'll just purchase the first product in the list
    if let firstProduct = availableProducts.first {
        purchase(product: firstProduct)
    }
  }

  private func purchase(product: SKProduct) {
    let payment = SKPayment(product: product)
    SKPaymentQueue.default().add(self)
    SKPaymentQueue.default().add(payment)
  }

  public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
      for transaction in transactions {
          switch transaction.transactionState {
          case .purchased:
              // Handle successful purchase
              if let receiptURL = Bundle.main.appStoreReceiptURL,
                  let receiptData = try? Data(contentsOf: receiptURL) {
                  let receiptString = receiptData.base64EncodedString(options: [])
                  notifyListeners("inAppPurchaseSuccess", data: [
                      "productIdentifier": transaction.payment.productIdentifier,
                      "receipt": receiptString
                  ])
              }
              SKPaymentQueue.default().finishTransaction(transaction)
          case .failed:
              // Handle failed purchase
              if let error = transaction.error as NSError?, error.code != SKError.paymentCancelled.rawValue {
                  notifyListeners("inAppPurchaseFailed", data: [
                      "error": error.localizedDescription
                  ])
              }
              SKPaymentQueue.default().finishTransaction(transaction)
          case .restored:
              // Handle restored purchase
              SKPaymentQueue.default().finishTransaction(transaction)
          case .deferred, .purchasing:
              break
          @unknown default:
              break
          }
      }
  }


  public func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
      // Handle the authorized payment here
      completion(PKPaymentAuthorizationResult(status: .success, errors: nil))

      // Notify the bridge that the payment was successful
      self.notifyListeners("applePayPaymentSuccess", data: [
          "status": "success",
          "paymentData": payment.token.paymentData.base64EncodedString()
      ])
  }

  public func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
      controller.dismiss(animated: true, completion: nil)
  }
}
