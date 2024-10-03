import Foundation
import Capacitor
import PassKit

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(ApplePayPlugin)
public class ApplePayPlugin: CAPPlugin, CAPBridgedPlugin, PKPaymentAuthorizationViewControllerDelegate {
    public let identifier = "ApplePayPlugin"
    public let jsName = "ApplePay"
    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(name: "echo", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "canMakePayments", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "showApplePaySheet", returnType: CAPPluginReturnPromise)
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
          let supportedNetworks = call.getArray("supportedNetworks", String.self),
          let paymentSummaryItems = call.getArray("paymentSummaryItems", [String: Any].self) else {
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
        var recurringPaymentsToAdd: [PKRecurringPaymentSummaryItem] = []
        recurringSummaryItems.forEach{ item in
          guard let label = item["label"] as? String,
                let amountString = item["amount"] as? String,
                let amount = NSDecimalNumber(string: amountString) as? NSDecimalNumber,
                let startDateString = item["startDate"] as? String,
                let startDate = ISO8601DateFormatter().date(from: startDateString),
                let intervalUnit = item["intervalUnit"] as? NSCalendar.Unit,
                let intervalCount = item["intervalCount"] as? Int else {
            call.reject("Invalid recurring payment item")
            return
          }
          
          let recurringItem = PKRecurringPaymentSummaryItem(label: label, amount: amount)
          recurringItem.startDate = startDate
          recurringItem.intervalUnit = intervalUnit
          recurringItem.intervalCount = intervalCount
          guard let url = item["managementURL"] as? URL else {
            call.reject("Invalid recurring payment item")
            return;
          }
          let recurringPaymentRequest = PKRecurringPaymentRequest(paymentDescription:label, regularBilling:recurringItem, managementURL: url)
          paymentRequest.recurringPaymentRequest = recurringPaymentRequest
        }
        
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

  public func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
      // Handle the authorized payment here
      completion(PKPaymentAuthorizationResult(status: .success, errors: nil))

      // Notify the bridge that the payment was successful
      self.notifyListeners("paymentSuccess", data: [
          "status": "success",
          "paymentData": payment.token.paymentData.base64EncodedString()
      ])
  }

  public func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
      controller.dismiss(animated: true, completion: nil)
  }
}
