//
//  EVReflectionExtensions.swift
//  EverliveSwift
//
//  Created by Dimitar Dimitrov on 3/2/16.
//  Copyright © 2016 ddimitrov. All rights reserved.
//

import Foundation
import EVReflection

extension EVReflection {
    public class func prepareCreateObjectString(theObject: NSObject, performKeyCleanup:Bool = true) -> String {
        var (dict,_) = EVReflection.toDictionary(theObject)
        dict = fixPropertyNames(dict)
        let skippedProps: Set<String> = ((theObject as? DataItem)?.getSkippedProperties())!
        dict = removeSkippedProperties(dict, skippedProps: skippedProps)
        dict = convertDictionaryForJsonSerialization(dict)
        var result: String = ""
        do {
            let jsonData = try NSJSONSerialization.dataWithJSONObject(dict , options: .PrettyPrinted)
            if let jsonString = NSString(data:jsonData, encoding:NSUTF8StringEncoding) {
                result =  jsonString as String
            }
        } catch { }
        return result
    }
    
    public class func prepareUpdateObjectString(theObject: NSObject, changedProperties: Set<String>, performKeyCleanup:Bool = true) -> NSDictionary {
        var (dict,_) = EVReflection.toDictionary(theObject)
        dict = removeNonModifiedProps(dict, changedProps: changedProperties)
        let skippedProps: Set<String> = ((theObject as? DataItem)?.getSkippedProperties())!
        dict = removeSkippedProperties(dict, skippedProps: skippedProps)
        dict = convertDictionaryForJsonSerialization(dict)
        return dict
    }
    
    private class func removeNonModifiedProps(dict: NSDictionary, changedProps: Set<String>) -> NSDictionary {
        let newProperties = NSMutableDictionary()
        for (key, _) in dict {
            if((changedProps.indexOf(key as! String)) != nil){
                var newKey: String = key as! String;
                newKey.replaceRange(newKey.startIndex...newKey.startIndex, with: String(newKey[newKey.startIndex]).capitalizedString)
                newProperties[newKey] = dict[key as! String]
            }
        }
        return newProperties
    }
    
    private class func removeSkippedProperties(dict: NSDictionary, skippedProps: Set<String>) -> NSDictionary {
        let newProperties = NSMutableDictionary()
        for (key, _) in dict {
            if((skippedProps.indexOf(key as! String)) == nil){
                newProperties[key as! String] = dict[key as! String]
            }
        }
        return newProperties
    }
    
    private class func fixPropertyNames(dict: NSDictionary) -> NSDictionary {
        let newProperties = NSMutableDictionary()
        for (key, _) in dict {
            var newKey: String = key as! String;
            newKey.replaceRange(newKey.startIndex...newKey.startIndex, with: String(newKey[newKey.startIndex]).capitalizedString)
            newProperties[newKey] = dict[key as! String]
        }
        return newProperties
    }
    
    private class func convertDictionaryForJsonSerialization(dict: NSDictionary) -> NSDictionary {
        for (key, value) in dict {
            dict.setValue(convertValueForJsonSerialization(value), forKey: key as! String)
        }
        return dict
    }

    private class func convertValueForJsonSerialization(value : AnyObject) -> AnyObject {
        switch(value) {
        case let stringValue as NSString:
            return stringValue
        case let numberValue as NSNumber:
            return numberValue
        case let nullValue as NSNull:
            return nullValue
        case let arrayValue as NSArray:
            let tempArray: NSMutableArray = NSMutableArray()
            for value in arrayValue {
                tempArray.addObject(convertValueForJsonSerialization(value))
            }
            return tempArray
        case let date as NSDate:
            return (getDateFormatter().stringFromDate(date) ?? "")
        case let ok as NSDictionary:
            return convertDictionaryForJsonSerialization(ok)
        default:
            NSLog("ERROR: Unexpected type while converting value for JsonSerialization")
            return "\(value)"
        }
    }
    
    private static var dateFormatter: NSDateFormatter? = nil
    
    private class func getDateFormatter() -> NSDateFormatter {
        if let formatter = dateFormatter {
            return formatter
        }
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        return formatter
    }
}