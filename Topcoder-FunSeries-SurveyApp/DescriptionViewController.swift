//
//  DescriptionViewController.swift
//  Topcoder-FunSeries-SurveyApp
//
//  Created by 侯 翔 on 2015/12/17.
//  Copyright © 2015年 topcoder. All rights reserved.
//

import Foundation
import UIKit

class DescriptionViewController: UIViewController {
    @IBOutlet var text: UITextView!;
    @IBOutlet var naviBar: UINavigationBar!;
    @IBOutlet var navBarItem: UINavigationItem!;
    
    var itemId: Int = 0;
    var tool: Tool?;
    var data: NSArray = [];
    
    override func viewDidLoad() {
        super.viewDidLoad();
        tool = Tool.instance();
        if (InternetRequest.instance().checkInternetAvailable()) {
            let jsonData: NSData = tool!.getJSONFromRemote("http://www.mocky.io/v2/560920cc9665b96e1e69bb46");
            data = tool!.parseJSON(jsonData);
        }
        self.getDescriptionById();
    }
    
    func getDescriptionById() {
        for info: NSDictionary in self.data as! [NSDictionary] {
            if ((info["id"] as! Int) == itemId) {
                self.text.text = info["description"] as! String;
                self.navBarItem.title = info["title"] as? String;
                break;
            }
        }
    }
    
}