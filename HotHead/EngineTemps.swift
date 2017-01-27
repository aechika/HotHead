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
    
    var egt1:Int?
    var egt2:Int?
    var egt3:Int?
    var egt4:Int?
    var egt5:Int?
    var egt6:Int?
    var egt7:Int?
    
    var cht1:Int?
    var cht2:Int?
    var cht3:Int?
    var cht4:Int?
    var cht5:Int?
    var cht6:Int?
    var cht7:Int?
    
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
        egt7    <-  map["EGT7"]
        
        cht1    <-  map["CHT1"]
        cht2    <-  map["CHT2"]
        cht3    <-  map["CHT3"]
        cht4    <-  map["CHT4"]
        cht5    <-  map["CHT5"]
        cht6    <-  map["CHT6"]
        cht7    <-  map["CHT7"]
    }
    
    
}