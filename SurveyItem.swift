//
//  SurveyItem.swift
//  Topcoder-FunSeries-SurveyApp
//
//  Created by Xiang Hou on 2015/11/12.
//  Copyright © 2015 topcoder. All rights reserved.
//

import Foundation
import CoreData


class SurveyItem: BaseItem {
    @NSManaged var id: Int;
    @NSManaged var title: String;
    @NSManaged var desc: String;
    @NSManaged var isdeleted: Bool;
    
    class func insert(moc: NSManagedObjectContext, info: NSDictionary) -> SurveyItem {
        let newItem: SurveyItem = NSEntityDescription.insertNewObjectForEntityForName("SurveyItem", inManagedObjectContext: moc) as! SurveyItem;
        newItem.id = info["id"] as! Int;
        newItem.title = info["title"] as! String;
        newItem.desc = info["description"] as! String;
        newItem.isdeleted = false;
        return newItem;
    }
    
    class func update(moc: NSManagedObjectContext, condition: NSPredicate, values: NSDictionary) {
        let items: [SurveyItem] = select(moc, condition: condition);
        for item: SurveyItem in items {
            item.isdeleted = true;
        }
        if (moc.hasChanges) {
            do {
                try moc.save();
            }
            catch {}
        }
    }
    
    class func logicDelete(moc: NSManagedObjectContext, condition: NSPredicate) {
        let items: [SurveyItem] = select(moc, condition: condition);
        for item: SurveyItem in items {
            item.isdeleted = true;
        }
        if (moc.hasChanges) {
            do {
                try moc.save();
            }
            catch {}
        }
    }
}