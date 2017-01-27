//
//  DataClient.swift
//  HotHead
//
//  Created by Anthony Chika on 1/26/17.
//
//

import Foundation
import Alamofire

class DataClient {
    
    var url:String = ""
    var manager: Alamofire.Manager = Alamofire.Manager()
    var serverTrustPolicyManager: ServerTrustPolicyManager?
    
    init(baseUrl:String, allowInvalidCert:Bool) {
        url = baseUrl
        
        if allowInvalidCert {
            let serverTrustPolicies:[String: ServerTrustPolicy] = [baseUrl : .DisableEvaluation]
            serverTrustPolicyManager = ServerTrustPolicyManager(policies: serverTrustPolicies)
        }
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.URLCache = nil //disable caching
        manager = Alamofire.Manager(configuration: configuration, serverTrustPolicyManager: serverTrustPolicyManager)
    }
    
    func requestEngineTemps(callback: ((data:EngineTemps?, error: NSError?) -> Void)) {
        
        manager.request(Method.GET, url, parameters: nil, encoding: ParameterEncoding.URL, headers: nil)
            .validate() //throws error if we receive response codes outside of 200-299
            .responseString { response -> Void in
                
                if response.result.error == nil {
                    
                    if let json = StringHelper.convertJsonDataToDictionary(response.data!) {
                        callback(data: EngineTemps(jsonData: json as? [String : AnyObject]), error: response.result.error)
                    }
                    else {
                        let stringData = NSString(data: response.data!, encoding: NSUTF8StringEncoding)
                        let error = NSError(domain: "HotHead", code: 0, userInfo: [NSLocalizedDescriptionKey : "Error in Parsing Data: Not valid json.\n\n \(stringData!)"])
                        callback(data: nil, error: error)
                    }
                }
                else {
                    callback(data: nil, error: response.result.error)
                }
        }

    }
    
    
}