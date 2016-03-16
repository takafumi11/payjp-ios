//
//  ViewController.swift
//  ApplePaySample
//

import UIKit
import PassKit

import PAYJP


// SET YOUR Apple Merchant ID
let MERCHANT_IDENTIFIER = "YOUR_MERCHANT_IDENTIFIER"


class ViewController: UIViewController, PKPaymentAuthorizationViewControllerDelegate {
    @IBOutlet weak var publicKey: UITextField!
    @IBOutlet weak var endpoint1: UITextField!
    @IBOutlet weak var endpoint2: UITextField!
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var responseText: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let infoDictionary = NSBundle.mainBundle().infoDictionary!
        let version = infoDictionary["CFBundleShortVersionString"]! as! String
        let build:String = infoDictionary["CFBundleVersion"]! as! String;

        let versionLabel = UILabel.init(frame: CGRectMake(90.0, 540.0, 200, 20))
        versionLabel.font = UIFont.systemFontOfSize(12.0)
        versionLabel.text = "\(version).\(build)"

        let buyButton = PKPaymentButton.init(paymentButtonType: PKPaymentButtonType.Buy, paymentButtonStyle: PKPaymentButtonStyle.Black)
        buyButton.frame = CGRectMake(90.0, 560.0, 200.0, 60.0)
        buyButton.addTarget(self, action: "pay", forControlEvents: UIControlEvents.TouchUpInside)

        self.view.addSubview(versionLabel)
        self.view.addSubview(buyButton)
    }

    func setUp() {
        let library = PKPassLibrary.init()
        library.openPaymentSetup()
    }

    func pay() {
        let networks = [PKPaymentNetworkAmex, PKPaymentNetworkMasterCard, PKPaymentNetworkVisa]

        // check if ApplePay is avaialbe
        if !canMakePayments() { return }
        if !canMakePaymentsUsingNetworks(networks){ return }

        // make an ApplePay request
        let request = PKPaymentRequest.init()
        request.currencyCode = "JPY"
        request.countryCode = "JP"
        request.merchantIdentifier = MERCHANT_IDENTIFIER

        let mantissa = UInt64(self.amount.text!)
        let amount = NSDecimalNumber.init(mantissa: mantissa!, exponent: 0, isNegative: false)
        let item = PKPaymentSummaryItem.init(label: "PAY.JP TEST ITEM", amount: amount)

        request.paymentSummaryItems = [item];
        request.supportedNetworks = networks
        request.merchantCapabilities = PKMerchantCapability.Capability3DS
        request.requiredBillingAddressFields = PKAddressField.PostalAddress

        // show ApplePay Modal
        let vc = PKPaymentAuthorizationViewController.init(paymentRequest: request)
        vc.delegate = self
        self.presentViewController(vc, animated: true, completion: nil)
    }

    func canMakePayments() -> Bool {
        if !PKPaymentAuthorizationViewController.canMakePayments() {
            let alertController = UIAlertController.init(
                title: "エラー",
                message: "ApplePayに対応していません",
                preferredStyle: UIAlertControllerStyle.Alert
            )
            alertController.addAction(UIAlertAction.init(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            return false
        }
        return true
    }

    func canMakePaymentsUsingNetworks(networks: Array<String>) -> Bool {
        if !PKPaymentAuthorizationViewController.canMakePaymentsUsingNetworks(networks) {
            let alertController = UIAlertController.init(
                title: "決済方法が登録されていません",
                message: "今すぐ決済方法を登録しますか？",
                preferredStyle: UIAlertControllerStyle.Alert
            )
            alertController.addAction(UIAlertAction.init(title: "YES", style: UIAlertActionStyle.Default, handler: { action in
                self.setUp()
            }))
            alertController.addAction(UIAlertAction.init(title: "NO", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            return false
        }
        return true
    }

    func paymentAuthorizationViewController(controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: (PKPaymentAuthorizationStatus) -> Void) {
        // encode ApplePay Token
        let set = NSCharacterSet.alphanumericCharacterSet()
        let paymentString = NSString.init(data: payment.token.paymentData, encoding: NSUTF8StringEncoding)?.stringByAddingPercentEncodingWithAllowedCharacters(set)

        // create a PAY.JP Token using ApplePay Token
        let apiClient = PAYJP.APIClient(publicKey: self.publicKey.text!)
        apiClient.createPAYJPToken(self.endpoint1.text!, applePayToken: paymentString!, completionHandler: {
            (dict: NSDictionary?, res: NSURLResponse?, err: NSError?) in
            if err == nil {
                let token = dict!["id"] as! String
                let parameters = ["token": token, "amount": self.amount.text!]

                // backend will make a payment using PAY.JP token
                apiClient.makeTestPayment(self.endpoint2.text!, parameters: parameters, completionHandler: { (dict, res, err) in
                    if err == nil {
                        dispatch_async(dispatch_get_main_queue()){
                            self.responseText.text = dict.debugDescription
                        }
                        completion(PKPaymentAuthorizationStatus.Success)
                    } else {
                        self.responseText.text = dict.debugDescription
                        completion(PKPaymentAuthorizationStatus.Failure)
                    }
                })
            } else {
                self.responseText.text = dict.debugDescription
                completion(PKPaymentAuthorizationStatus.Failure)
            }
        })
    }

    func paymentAuthorizationViewControllerDidFinish(controller: PKPaymentAuthorizationViewController) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}

