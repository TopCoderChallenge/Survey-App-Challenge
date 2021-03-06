//
//  ViewController.swift
//  Topcoder-FunSeries-SurveyApp
//
//  Created by Harshit on 24/09/15.
//  Copyright (c) 2015 topcoder. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate
{
    //The objecy used for accessing CoreData
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext;
    
    var dataArray:NSMutableArray!;
    var plistPath:String!;
    var tableData: [BaseItem]!;
    var filteredData: [String] = [];
    var titleData :[String] = [];
    var i: Int = 0;
    var flag: Bool = false;
    var tool:Tool?;
    var surveyItemCD: SurveyItem = SurveyItem.Instance();

    @IBOutlet var SurveyTableSearchBar: UISearchBar!;
    @IBOutlet var Label: UILabel!;
    @IBOutlet var SurveyTable: UITableView!;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        surveyItemCD.entityName = "SurveyItem";
        SurveyTable.delegate = self;
        SurveyTable.dataSource = self;
        tool = Tool.instance();
        if (InternetRequest.instance().checkInternetAvailable()) {
            let JSONData:NSData = tool!.getJSONFromRemote("http://www.mocky.io/v2/560920cc9665b96e1e69bb46");
            let tmpData: NSArray = tool!.parseJSON(JSONData);
            updateCoreData(tmpData);
        }
        tableData = fetchCoreData();
        SurveyTable.reloadData();
    }
    
    //Search Bar functions
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String){
        print("india");
        flag = true;
        self.filteredData = self.titleData.filter({ (title : String) -> Bool in
            let stringForSearch = title.rangeOfString(searchText)
            return (stringForSearch != nil)
        })
        SurveyTable.reloadData();
    }
    
    
    
    //MARK: - Core Data process part
    func updateCoreData(data: NSArray) {
        var result: [SurveyItem];
        var surveyItems: [SurveyItem];
        var surveyItem: SurveyItem;
        var title: String = "";
        var desc: String = "";
        
        let queryCondition: NSPredicate = NSPredicate(format: "id != %i", 0);
        result = surveyItemCD.select(managedObjectContext, condition: queryCondition) as! [SurveyItem];
        
        for item: NSDictionary in data as! [NSDictionary] {
            surveyItems = searchById(result, id: item["id"] as! Int);
            title = item["title"] as! String;
            desc = item["description"] as! String;
            
            if (surveyItems.count > 0) {
                surveyItem = surveyItems.first!;
                if (surveyItem.title != title || surveyItem.desc != desc) {
                    surveyItem.title = title;
                    surveyItem.desc = desc;
                }
            }
            else {
                _ = surveyItemCD.insert(managedObjectContext, info: item);
            }
        }
        if (managedObjectContext.hasChanges) {
            do {
                try managedObjectContext.save();
            }
            catch {}
        }
    }
    
    /**
     * Search data from CoreData which the id is contained
     *
     * @return SurveyItem list
     * @Author: Xiang Hou
     */
    func searchById(data: [SurveyItem], id: Int) -> [SurveyItem] {
        var returnValue: [SurveyItem] = [];
        for item in data {
            if (item.id == id) {
                returnValue.append(item);
                break;
            }
        }
        return returnValue;
    }
    
    /**
     * Get data from CoreData start
     *
     * @Author: Xiang Hou
     */
    func fetchCoreData() -> [SurveyItem] {
        var returnData: [SurveyItem] = [];

        // Get datas from CoreData which isdeleted field is false
        let queryCondition: NSPredicate = NSPredicate(format: "isdeleted = %i", 0);
        returnData = surveyItemCD.select(managedObjectContext, condition: queryCondition) as! [SurveyItem];
        
        return returnData;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - Table view delegate
    func numberOfSectionsInTableView(SurveyTable: UITableView) -> Int {
        return 1;
    }
    
    
    func tableView(SurveyTable: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count;
    }
    
    func tableView(SurveyTable: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let item: SurveyItem = tableData[indexPath.row] as! SurveyItem;
        let cell: Cell = SurveyTable.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! Cell;
        cell.label?.text = item.title;
        cell.id = item.id;
        cell.title = item.title;
        return cell;
    }
    
    func tableView(SurveyTable: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let cell: Cell = SurveyTable.cellForRowAtIndexPath(indexPath) as! Cell;
        print("Set isdeleted field to true in CoreData which item id :" + String(cell.id));
        
        // Set isdeleted field to 1 of CoreData
        let queryCondition: NSPredicate = NSPredicate(format: "id = %i", cell.id);
        surveyItemCD.logicDelete(managedObjectContext, condition: queryCondition);
        
        // Delete row from table view
        tableData.removeAtIndex(indexPath.row);
        SurveyTable.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left);
    }
    
    func tableView(SurveyTable: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell: Cell = SurveyTable.cellForRowAtIndexPath(indexPath) as! Cell;
        self.performSegueWithIdentifier("desc", sender: cell);
    }
    
    //MARK: - Send value to destination viewcontroller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationController: DescriptionViewController = segue.destinationViewController as! DescriptionViewController;
        destinationController.itemId = (sender as! Cell).id;
    }
    
}


