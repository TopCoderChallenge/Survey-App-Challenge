//
//  InternetRequest.swift
//  Topcoder-FunSeries-SurveyApp
//
//  Created by Xiang Hou on 2015/11/13.
//  Copyright © 2015 topcoder. All rights reserved.
//

import Foundation
import SystemConfiguration

class InternetRequest
{
    static var IR: InternetRequest? = nil;
    
    static func instance() -> InternetRequest {
        if (IR == nil) {
            IR = InternetRequest();
        }
        return IR!;
    }
    
    func checkInternetAvailable() -> Bool {
        var isAvailable: Bool = false;
        
        // The process is relate to Reachability plugin
        var reachability: Reachability;
        do {
             reachability = try Reachability.reachabilityForInternetConnection();
            if (reachability.isReachable()) {
                isAvailable = true;
            }
        }
        catch {}
        
        return isAvailable;
        
    }
    
    
}
