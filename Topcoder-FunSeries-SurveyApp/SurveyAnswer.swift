//
//  SurveyAnswer.swift
//  Topcoder-FunSeries-SurveyApp
//
//  Created by 侯 翔 on 2016/01/26.
//  Copyright © 2016年 topcoder. All rights reserved.
//

import Foundation
import CoreData

class SurveyAnswer: BaseItem
{
    @NSManaged var id: Int;
    @NSManaged var survey_id: Int;
    @NSManaged var content: String;
    
    static var instance: SurveyAnswer? = nil;
    
    static func Instance() -> SurveyAnswer {
        if (instance == nil) {
            instance = SurveyAnswer();
        }
        return instance!;
    }
    
    func insert(moc: NSManagedObjectContext, info: Dictionary<String, String>) -> SurveyAnswer {
        let newItem: SurveyAnswer = NSEntityDescription.insertNewObjectForEntityForName(self.entityName!, inManagedObjectContext: moc) as! SurveyAnswer;
        newItem.id = Int(info["id"]!)!;
        newItem.survey_id = Int(info["surveyId"]!)!;
        newItem.content = info["content"]!;
        return newItem;
    }
}
