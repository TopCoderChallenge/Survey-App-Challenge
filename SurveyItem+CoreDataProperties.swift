//
//  SurveyItem+CoreDataProperties.swift
//  Topcoder-FunSeries-SurveyApp
//
//  Created by 侯 翔 on 2015/11/12.
//  Copyright © 2015年 topcoder. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension SurveyItem {

    @NSManaged var id: NSNumber?
    @NSManaged var title: String?
    @NSManaged var desc: String?
    @NSManaged var isdelete: Bool?

}
