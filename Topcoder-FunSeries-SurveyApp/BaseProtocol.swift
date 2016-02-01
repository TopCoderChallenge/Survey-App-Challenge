//
//  BaseProtocol.swift
//  Topcoder-FunSeries-SurveyApp
//
//  Created by 侯 翔 on 2016/01/28.
//  Copyright © 2016年 topcoder. All rights reserved.
//

import Foundation
import CoreData

protocol BaseProtocol
{
    func insert(moc: NSManagedObjectContext, info: NSDictionary) -> BaseItem;
    
    func update(moc: NSManagedObjectContext, condition: NSPredicate, values: NSDictionary);
}
