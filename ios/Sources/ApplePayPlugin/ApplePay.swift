import Foundation

@objc public class ApplePay: NSObject {
    @objc public func echo(_ value: String) -> String {
        print(value)
        return value
    }
    
    @objc public func canMakePayments(_ value: Bool) -> Bool {
        print(value)
        return value
    }

    @objc public func showApplePaySheet(_ value: Bool) -> Bool {
        print("showApplePaySheet")
        return value
    }

    @objc public func showInAppPurchaseSheet(_ value: Bool) -> Bool {
        print("showInAppPurchaseSheet")
        return value
    }
}
