//
//  SurveyQuestionViewController.swift
//  Topcoder-FunSeries-SurveyApp
//
//  Created by 侯 翔 on 2016/01/19.
//  Copyright © 2016年 topcoder. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class SurveyQuestionViewController: UIViewController, UITextViewDelegate
{
    @IBOutlet var questionText: UITextView?;
    @IBOutlet var answerText: UITextView?;
    @IBOutlet var finishedCountLabel: UILabel?;
    @IBOutlet var totalCountLabel: UILabel?;
    @IBOutlet var finishButton: UIButton?;
    @IBOutlet var saveButton: UIButton?;
    @IBOutlet var leftButton: UIButton?;
    @IBOutlet var rightButton: UIButton?;
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext;
    var tool: Tool?;
    var data: NSArray = [];
    var surveyId: Int = 0;
    var questions: NSMutableArray = [];
    var answers: Dictionary<Int, SurveyAnswer> = Dictionary<Int, SurveyAnswer>();
    var surveyAnswerCD: SurveyAnswer = SurveyAnswer.Instance();
    var questionId: Int = 0;
    var questionIndex: Int = 0;
    var answerIndex: Int = 0;
    var myRootRef: Firebase = Firebase(url: "https://fiery-heat-6099.firebaseio.com/Data/Answers");
    var alert: UIAlertController? = nil;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        if (alert != nil) {
            alert = nil;
        }
        surveyAnswerCD.entityName = "SurveyAnswer";
        tool = Tool.instance();
        leftButton?.enabled = false;
        rightButton?.enabled = false;
        finishButton?.hidden = true;
        self.questionText?.layer.borderWidth = 1;
        self.questionText?.layer.cornerRadius = 8;
        self.answerText?.layer.borderWidth = 1;
        self.answerText?.layer.cornerRadius = 8;
        
        // Set delegate for FireBase
        self.myRootRef.observeEventType(.ChildChanged, withBlock: { snapshot in
            print(snapshot.value);
            if (self.alert == nil) {
                self.alert = UIAlertController(title: "Finshed", message: "The data has been stored in FireBase!", preferredStyle: UIAlertControllerStyle.Alert);
                let okAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(action: UIAlertAction!) -> Void in
                    self.performSegueWithIdentifier("questionToList", sender: self);
                });
                self.alert?.addAction(okAction);
                self.presentViewController(self.alert!, animated: true, completion: nil);
            }
        });
        
        if (InternetRequest.instance().checkInternetAvailable()) {
            let jsonData: NSData = tool!.getJSONFromRemote("http://demo2394932.mockable.io/wizard");
            data = tool!.parseJSON(jsonData);
            self.getQuestionsById();
            self.getAnswerBySurveyIdFromStore();
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        finishedCountLabel?.text = String (answers.count);
        totalCountLabel?.text = String (questions.count);
        if (questions.count > 0) {
            self.displayQuestionAndAnswer();
            if (questions.count > 1) {
                rightButton?.enabled = true;
            }
            else {
                finishButton?.hidden = true;
            }
        }
        
    }
    
    /**
     * Get question and answer by current question id and set them to text view
     */
    func displayQuestionAndAnswer() {
        let question: NSDictionary = questions.objectAtIndex(questionIndex) as! NSDictionary;
        questionText?.text = question["question"] as! String;
        self.questionId = question["id"] as! Int;
        if ((self.answers.indexForKey(questionId)) != nil) {
            let answer: SurveyAnswer = self.answers[questionId]!;
            self.answerText?.text = answer.content;
        }
        else {
            self.answerText?.text = "";
        }
    }
    /**
     * Get questions by survey id and set result into question array
     */
    func getQuestionsById() {
        for info: NSDictionary in self.data as! [NSDictionary] {
            if ((info["surveyId"] as! Int) == surveyId) {
                questions.addObject(info);
            }
        }
    }
    /**
     * Get answers by survey id and set them into answers
     */
    func getAnswerBySurveyIdFromStore() {
        // Get datas from CoreData which isdeleted field is false
        let queryCondition: NSPredicate = NSPredicate(format: "survey_id = %i", self.surveyId);
        let returnData: [SurveyAnswer] = surveyAnswerCD.select(managedObjectContext, condition: queryCondition) as! [SurveyAnswer];
        if (returnData.count > 0) {
            for answer: SurveyAnswer in returnData {
                answers[answer.id] = answer;
            }
        }
    }
    
    func saveAnswerToArray() {
        if ((self.answers.indexForKey(questionId)) != nil) {
            let text: String = (self.answers[self.questionId]?.content)!;
            if (answerText?.text != "" && text != answerText?.text) {
                self.answers[self.questionId]?.content = (answerText?.text)!;
            }
        }
        else if (answerText?.text != "" && questionId != 0) {
            var infoAnswer:Dictionary<String, String> = Dictionary<String, String>();
            infoAnswer["id"] = String (questionId);
            infoAnswer["surveyId"] = String (self.surveyId);
            infoAnswer["content"] = self.answerText?.text;
            let answer: SurveyAnswer = surveyAnswerCD.insert(managedObjectContext, info: infoAnswer);
            self.answers[questionId] = answer;
        }
        
    }
    
    func sendAnswersToRemote() {
        var storeData: [NSDictionary] = [];
        for (_, answer) in self.answers {
            let ans: NSDictionary = ["surveyId": answer.survey_id, "questionId": answer.id, "answer": answer.content];
            storeData.append(ans);
        }
        // The parent node name likes surveyId_1
        myRootRef.childByAppendingPath("surveyId_" + String (self.surveyId)).setValue(storeData);
    }
    
    //MARK: - IBAction
    @IBAction func changeQuestion(sender: AnyObject) {
        var isRight: Bool = true;
        let button: UIButton = sender as! UIButton;
        isRight = button.titleLabel?.text == ">" ? true : false;
        questionIndex = isRight == true ? questionIndex + 1 : questionIndex - 1;
        self.saveAnswerToArray();
        displayQuestionAndAnswer();
        
        leftButton?.enabled = questionIndex > 0 ? true : false;
        rightButton?.enabled = questionIndex < questions.count - 1 ? true : false;
        finishButton?.hidden = rightButton?.enabled == true ? true : false;
    }
    
    @IBAction func saveAnswer(sender: AnyObject) {
        self.saveAnswerToArray();
        surveyAnswerCD.update(managedObjectContext);
        finishedCountLabel?.text = String (answers.count);
        self.answerText!.resignFirstResponder();
    }
    
    @IBAction func backToDescription(sender: AnyObject) {
        self.performSegueWithIdentifier("questionToDescription", sender: self);
    }
    
    @IBAction func onFinishClicked(sender: UIButton) {
        self.sendAnswersToRemote();
    }
    
    @IBAction func CloseKeyBoard(sender: AnyObject) {
        self.answerText!.resignFirstResponder();
    }
    
    //MARK: - Send value to destination viewcontroller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "questionToDescription") {
            let destinationController: DescriptionViewController = segue.destinationViewController as! DescriptionViewController;
            destinationController.itemId = (sender as! SurveyQuestionViewController).surveyId;
        }
    }
}
