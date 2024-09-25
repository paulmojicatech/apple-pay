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
}
