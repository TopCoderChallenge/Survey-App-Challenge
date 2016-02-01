//
//  BaseItem.swift
//  Topcoder-FunSeries-SurveyApp
//
//  Created by Xiang Hou on 2015/11/13.
//  Copyright © 2015 topcoder. All rights reserved.
//

import Foundation
import CoreData

class BaseItem : NSManagedObject
{
    var entityName: String?;
    
    func select(moc: NSManagedObjectContext, condition: NSPredicate) -> [BaseItem] {
        var returnData: [BaseItem] = [];
        var fetchResults: [BaseItem] = [];
        
        // Get datas from CoreData which isdeleted field is false
        let fetchRequest: NSFetchRequest = NSFetchRequest(entityName: self.entityName!);
        let sortDescriptor: NSSortDescriptor = NSSortDescriptor(key: "id", ascending: true);
        fetchRequest.sortDescriptors = [sortDescriptor];
        let queryCondition: NSPredicate = condition;
        fetchRequest.predicate = queryCondition;
        do {
            fetchResults = try moc.executeFetchRequest(fetchRequest) as! [BaseItem];
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
    
    func delete(moc: NSManagedObjectContext, condition: NSPredicate) {
        let items: [BaseItem] = select(moc, condition: condition);
        for item: BaseItem in items {
            moc.deleteObject(item);
        }
        if (moc.hasChanges) {
            do {
                try moc.save();
            }
            catch {}
        }
    }
    
    func update(moc: NSManagedObjectContext) {
        if (moc.hasChanges) {
            do {
                try moc.save();
            }
            catch {}
        }
    }
}