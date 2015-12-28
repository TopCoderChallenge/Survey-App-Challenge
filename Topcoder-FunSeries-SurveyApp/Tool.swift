//
//  Tool.swift
//  Topcoder-FunSeries-SurveyApp
//
//  Created by 侯 翔 on 2015/12/17.
//  Copyright © 2015年 topcoder. All rights reserved.
//

import Foundation

class Tool {
    static var tool: Tool? = nil;
    
    static func instance() -> Tool {
        if (tool == nil) {
            tool = Tool();
        }
        return tool!;
    }
    
    //MARK: - JSON Parsing and API hit functions
    func getJSONFromRemote(urlToRequest: String) -> NSData {
        return NSData(contentsOfURL: NSURL(string: urlToRequest)!)!;
    }
    
    
    func parseJSON(inputData: NSData) -> NSArray {
        var data: NSArray = [];
        do {
            data = (try NSJSONSerialization.JSONObjectWithData(inputData, options: NSJSONReadingOptions.MutableContainers)) as! NSArray;
        }
        catch {}
        
        return data;
    }
}