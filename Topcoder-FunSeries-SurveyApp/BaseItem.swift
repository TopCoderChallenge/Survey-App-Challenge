//
//  BaseItem.swift
//  Topcoder-FunSeries-SurveyApp
//
//  Created by Xiang Hou on 2015/11/13.
//  Copyright © 2015 topcoder. All rights reserved.
//

import Foundation
import CoreData

class BaseItem : NSManagedObject {
    class func select(moc: NSManagedObjectContext, condition: NSPredicate) -> [SurveyItem] {
        var returnData: [SurveyItem] = [];
        var fetchResults: [SurveyItem] = [];
        
        // Get datas from CoreData which isdeleted field is false
        let fetchRequest: NSFetchRequest = NSFetchRequest(entityName: "SurveyItem");
        let sortDescriptor: NSSortDescriptor = NSSortDescriptor(key: "id", ascending: true);
        fetchRequest.sortDescriptors = [sortDescriptor];
        let queryCondition: NSPredicate = condition;
        fetchRequest.predicate = queryCondition;
        do {
            fetchResults = try moc.executeFetchRequest(fetchRequest) as! [SurveyItem];
        }
        catch {
            let nserror: NSError = error as NSError;
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)");
            abort();
        }
        
        if (fetchResults != []) {
            returnData = fetchResults;
        }
        
        return returnData;
    }
    
    class func delete(moc: NSManagedObjectContext, condition: NSPredicate) {
        let items: [SurveyItem] = select(moc, condition: condition);
        for item: SurveyItem in items {
            moc.deleteObject(item);
        }
        if (moc.hasChanges) {
            do {
                try moc.save();
            }
            catch {}
        }
    }
}