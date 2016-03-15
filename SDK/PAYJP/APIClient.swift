//
//  APIClient.swift
//  PAY.JP
//

import Foundation


public class APIClient {
    // PAY.JP Username
    var username: String
    // PAY.JP Password
    var password: String

    public init(username: String, password: String) {
        self.username = username
        self.password = password
    }

    /// get PAY.JP Token
    /// - parameter url: PAY.JP Endpoint URL
    /// - parameter applePayToken: ApplePay Token
    public func createPAYJPToken(
        url: String,
        applePayToken: String,
        completionHandler: (NSDictionary?, NSURLResponse?, NSError?) -> ())
    {
        let parameters = ["card": applePayToken]
        request(url, auth:true, parameters: parameters, headers: nil, completionHandler: {
            (dict: NSDictionary?, res: NSURLResponse?, err: NSError?) in
            completionHandler(dict, res, err)
        })
    }

    /// make a test payment
    /// - parameter url: Payment Endpoint URL
    /// - parameter parameters: dictionary of PAY.JP Token and amount
    public func makeTestPayment(
        url: String,
        parameters: Dictionary<String,String>?,
        completionHandler: (NSDictionary?, NSURLResponse?, NSError?) -> ())
    {
        request(url, auth:false, parameters: parameters, headers: nil, completionHandler: {
            (dict: NSDictionary?, res: NSURLResponse?, err: NSError?) in
            completionHandler(dict, res, err)
        })
    }

    /// Send HTTP Request And Receive JSON Response
    public func request(
        url: String,
        auth: Bool,
        parameters: Dictionary<String,String>?,
        headers: Dictionary<String,String>?,
        completionHandler: (NSDictionary?, NSURLResponse?, NSError?) -> ())
    {
        let url = NSURL(string: url)
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)

        // Create Request Body
        let components = NSURLComponents.init(URL: url!, resolvingAgainstBaseURL: false)
        components?.queryItems = self.parametersToQueryItems(parameters)

        // Create Request
        let req = NSMutableURLRequest(URL: url!)
        req.HTTPMethod = "POST"
        req.HTTPBody = components!.query!.dataUsingEncoding(NSUTF8StringEncoding)

        // Set Basic Auth Header
        if auth {
            let credential = basicAuthCredentialWithUsername()
            req.setValue(credential, forHTTPHeaderField: "Authorization")
        }

        // Set HTTP Headers
        if headers != nil {
            for (name, value) in headers! {
                req.setValue(value, forHTTPHeaderField: name)
            }
        }

        // Send Request
        let task = session.dataTaskWithRequest(req, completionHandler: {(data, res, err) in
            do {
                let dict = try NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.MutableContainers ) as! NSDictionary
                completionHandler(dict, res, err)
            } catch {
                completionHandler(nil, res, err)
            }
        })
        task.resume()
    }

    /// Convert parameters to Array of NSURLQueryItem
    func parametersToQueryItems(parameters: Dictionary<String,String>?) -> [NSURLQueryItem] {
        var items: [NSURLQueryItem] = []
        for (name, value) in parameters! {
            items.append(NSURLQueryItem.init(name: name, value: value))
        }
        return items
    }

    /// Convert username and password to Base64 Credential
    func basicAuthCredentialWithUsername() -> String {
        let credentialData = "\(self.username):\(self.password)".dataUsingEncoding(NSUTF8StringEncoding)!
        let base64Credential = credentialData.base64EncodedStringWithOptions([])
        return "Basic \(base64Credential)"
    }
}