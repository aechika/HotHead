//
//  StringHelper.swift
//  HotHead
//
//  Created by Anthony Chika on 1/26/17.
//
//

import Foundation

class StringHelper {
    
    static func convertJsonDataToDictionary(data: NSData) -> AnyObject? {
        
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: [])
            return json
        }
        catch {
            print("Error \(error)")
            return nil
        }
    }
    
    static func convertJsonStringToDictionary(text: String) -> AnyObject? {
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
            
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data, options: [])
                return json
            }
            catch {
                print("Error \(error)")
            }
        }
        return nil
    }
    
    static func convertJsonDictionaryToString(dictionary: NSDictionary) -> String? {
        
        do {
            let jsonData: NSData = try NSJSONSerialization.dataWithJSONObject(dictionary, options: NSJSONWritingOptions.PrettyPrinted)
            return NSString(data: jsonData, encoding: NSUTF8StringEncoding)! as String
        }
        catch {
            print("Error \(error)")
        }
        
        return nil
    }
    
}
