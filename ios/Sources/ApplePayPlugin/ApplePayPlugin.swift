import Foundation
import Capacitor
import PassKit

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(ApplePayPlugin)
public class ApplePayPlugin: CAPPlugin, CAPBridgedPlugin {
    public let identifier = "ApplePayPlugin"
    public let jsName = "ApplePay"
    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(name: "echo", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "canMakePayments", returnType: CAPPluginReturnPromise)
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
}
