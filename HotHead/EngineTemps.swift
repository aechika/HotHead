//
//  Data.swift
//  HotHead
//
//  Created by Anthony Chika on 1/26/17.
//
//

import Foundation
import ObjectMapper

class EngineTemps: Mappable {
    
    var egt1:Int = 0
    var egt2:Int = 0
    var egt3:Int = 0
    var egt4:Int = 0
    var egt5:Int = 0
    var egt6:Int = 0
    
    var cht1:Int = 0
    var cht2:Int = 0
    var cht3:Int = 0
    var cht4:Int = 0
    var cht5:Int = 0
    var cht6:Int = 0
    
    var timestamp:NSDate?
    
    init (jsonData:[String: AnyObject]?) {
        
        Mapper<EngineTemps>().map(jsonData, toObject: self)
    }
    
    //Required By ObjectMapper
    required init?(_ map: Map) {
    }
    
    //Required By ObjectMapper
    func mapping(map: Map) {
        
        egt1    <-  map["EGT1"]
        egt2    <-  map["EGT2"]
        egt3    <-  map["EGT3"]
        egt4    <-  map["EGT4"]
        egt5    <-  map["EGT5"]
        egt6    <-  map["EGT6"]
        
        cht1    <-  map["CHT1"]
        cht2    <-  map["CHT2"]
        cht3    <-  map["CHT3"]
        cht4    <-  map["CHT4"]
        cht5    <-  map["CHT5"]
        cht6    <-  map["CHT6"]
        
//        let dateFormatter = NSDateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
//        if let dateString = map["TIMESTAMP"].currentValue as? String, let _date = dateFormatter.dateFromString(dateString) {
//            timestamp = _date
//        }
    }
    
    
}