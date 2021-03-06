//
//  ViewController.swift
//  diaBTech-Basics
//
//  Created by Mercedes Streeter on 1/26/15.
//  Copyright (c) 2015 Mercedes Streeter. All rights reserved.
//

import UIKit
import CoreData


class ViewController: UIViewController, FBLoginViewDelegate {
    var userItems = [UserID]()
    var userData = [UserHealth]()
    var userA1CData = [UserA1C]()
    
    @IBOutlet weak var nextBTN: UIButton!
    //all outlets for registration 
    @IBOutlet weak var endoEmail: UITextField!
    @IBOutlet weak var aptDate: UIDatePicker!
    @IBOutlet weak var minGoal: UITextField!
    @IBOutlet weak var maxGoal: UITextField!
    @IBOutlet weak var breakMeal: UIDatePicker!
    @IBOutlet weak var lunchMeal: UIDatePicker!
    @IBOutlet weak var dinnerMeal: UIDatePicker!
    @IBOutlet weak var snack1Meal: UIDatePicker!
    @IBOutlet weak var snack2Meal: UIDatePicker!
    
    //all outlets for an Activity (non-a1c)
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateActivity: UIDatePicker!
    @IBOutlet weak var readingActivity: UITextField!
    @IBOutlet weak var ccActivity: UITextField!
    @IBOutlet weak var insulinActivity: UITextField!
    @IBOutlet weak var notesActivity: UITextView!
    
    //all outlets for an A1C 
    @IBOutlet weak var dateTimeA1C: UIDatePicker!
    @IBOutlet weak var readingA1C: UITextField!
    
    //outlets for graphing
    @IBOutlet weak var startDateGraph: UIDatePicker!
    @IBOutlet weak var endDateGraph: UIDatePicker!
    @IBOutlet weak var a1cGraph: UISwitch!
    
    //outlets for exporting
    @IBOutlet weak var startDateExport: UIDatePicker!
    @IBOutlet weak var endDateExport: UIDatePicker!
    @IBOutlet weak var a1cExport: UISwitch!
    
    //outlets for settings
    @IBOutlet weak var setCurEndoEmail: UITextField!
    @IBOutlet weak var setNextEndoApt: UIDatePicker!
    @IBOutlet weak var setMinBG: UITextField!
    @IBOutlet weak var setMaxBG: UITextField!
    @IBOutlet weak var setMorningTime: UIDatePicker!
    @IBOutlet weak var setLunchTime: UIDatePicker!
    @IBOutlet weak var setDinnerTime: UIDatePicker!
    @IBOutlet weak var setSnack1Time: UIDatePicker!
    @IBOutlet weak var setSnack2Time: UIDatePicker!
    
    //Facebook & Session outlets
    @IBOutlet weak var fbLogin: FBLoginView!
    struct fbStuff {
        static var fName = ""
        static var lName = ""
        static var email = ""
    }
    
    let managedObjectContext:NSManagedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func regMenu(sender: AnyObject) {
        var shouldPerformMenu = shouldPerformSegueWithIdentifier("toMenu", sender: nil)
        if(shouldPerformMenu && FB.hasActiveSession()){
            performSegueWithIdentifier("toMenu", sender: nil)
            
        }
        else {
            if(FB.hasActiveSession()){
                println("Should perform with toMenu returned false...")
                performSegueWithIdentifier("toRegistration", sender: nil)
            }
            else{
                println("HasSession is false");
                let alert = UIAlertView()
                alert.title = "Sign In Alert"
                alert.message = "In order to navigate further, you must sign into Facebook."
                alert.addButtonWithTitle("Ok")
                alert.show()
            }
        }
        
    }
    
    @IBAction func goGraph(sender: AnyObject) {
        if(startDateGraph.date.compare(endDateGraph.date) == NSComparisonResult.OrderedDescending){
            println("Error, end date is before start date.")
            let alert = UIAlertView()
            alert.title = "Alert"
            alert.message = "End date is before start date. Try again."
            alert.addButtonWithTitle("Ok")
            alert.show()
        }
        else {
            performSegueWithIdentifier("toGraph", sender: nil)
        }
    }
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        
        var fetReq = NSFetchRequest(entityName: "UserID")
        let predicate = NSPredicate(format: "fbEmail == %@", fbStuff.email);
        
        fetReq.predicate = predicate;
        
        let userItems: [UserID] = managedObjectContext.executeFetchRequest(fetReq, error: nil) as [UserID]!
        
        println("Can find a user in CD: ", userItems.count)
        var segueShouldOccur = (userItems.count > 0)
        println("Should segue occur: ", segueShouldOccur.boolValue)
        
        if (identifier == "toMenu") {
           println("Checking if to Menu should happen...")
            if !segueShouldOccur {
                println("*** NOPE, segue wont occur")
                return false
                
            }
            else{
                println("*** Yes, segue will occur")
            }
        }
        
        return true
    }
    
    
    @IBAction func addLog(sender: AnyObject) {
        var doubleII : Double = NSString(string: insulinActivity.text).doubleValue
        var doubleCC : Double = NSString(string: ccActivity.text).doubleValue
        
        var newHealth = UserHealth.createInManagedObjectContextHealth(managedObjectContext, dT: dateActivity.date, BSreading: readingActivity.text.toInt()!, estCC: doubleCC, II: doubleII, note: notesActivity.text)
        save()
        fetchLogs()
    }
    
   
    @IBAction func addRegister(sender: AnyObject) {
            println("User is not registered, save info")
            println("User First Name: " + fbStuff.fName)
            println("User Last Name: " + fbStuff.lName)
            println("Endo Email: " + endoEmail.text)
            println("Email: " + fbStuff.email)
            //getting times:
            var outF = NSDateFormatter()
            outF.locale = NSLocale(localeIdentifier: "en_US")
            outF.dateFormat = "MM-dd 'at' HH:mm"
        
        
            var outputFormat = NSDateFormatter()
            outputFormat.locale = NSLocale(localeIdentifier:"en_US")
            outputFormat.dateFormat = "HH:mm"
            
            
            var apttD = (outF.stringFromDate(aptDate.date))
            println("Apt Date: " + apttD)
            
            var bM = (outputFormat.stringFromDate(breakMeal.date))
            println("Breakfast Time: " + bM)
            
            var lM = (outputFormat.stringFromDate(lunchMeal.date))
            println("Lunch Time: " + lM)
            
            var dM = (outputFormat.stringFromDate(dinnerMeal.date))
            println("Dinner Time: " + dM)
            
            var sM1 = (outputFormat.stringFromDate(snack1Meal.date))
            println("Snack 1 Time: " + sM1)
            
            var sM2 = (outputFormat.stringFromDate(snack2Meal.date))
            println("Snack 2 Time: " + sM2)
            
            println("Min Goal: " + minGoal.text)
            
            println("Max Goal: " + maxGoal.text)
        
            var newUser = UserID.createInManagedObjectContextID(self.managedObjectContext, fbUserFN: fbStuff.fName, fbUserLN: fbStuff.lName, userEmail: fbStuff.email, endoEmail: endoEmail.text, nextAPPT: apttD, morningMT: bM, lunchMT: lM, dinnerMT: dM, snack1MT: sM1, snack2MT: sM2, minBS: minGoal.text.toInt()!, maxBS: maxGoal.text.toInt()!)
            save()
    }
    
    @IBAction func addA1C(sender: AnyObject) {
        var readingDouble : Double  = NSString(string: readingA1C.text).doubleValue
        
        var newA = UserA1C.createInManagedObjectContextA1C(managedObjectContext, dT: dateTimeA1C.date, reading: readingDouble)
        save()
        fetchLogs()
    }
    
    
    func fetchLogs(){
        let fetchReq = NSFetchRequest(entityName: "UserHealth")
        
        let sortDesc = NSSortDescriptor(key: "dateTime", ascending: true)
        fetchReq.sortDescriptors = [sortDesc]
        
        if let fetchResults = managedObjectContext.executeFetchRequest(fetchReq, error: nil) as? [UserHealth] {
            userData = fetchResults
        }
        
        let aFetReq = NSFetchRequest(entityName: "UserA1C")
        if let fetchARes = managedObjectContext.executeFetchRequest(aFetReq, error: nil) as? [UserA1C]{
            userA1CData = fetchARes
        }
        
        
        println("New number of logs (reg): ", userData.count)
        println("New number of logs (A1C): ", userA1CData.count)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if (segue.identifier == "toGraph") {
            var svc = segue.destinationViewController as GraphVC;
            let fetchReq = NSFetchRequest(entityName: "UserHealth")
            
            let sortDesc = NSSortDescriptor(key: "dateTime", ascending: true)
            fetchReq.sortDescriptors = [sortDesc]
            
            let predicate = NSPredicate(format: "dateTime >= %@ and dateTime <= %@", startDateGraph.date, endDateGraph.date)
                
            fetchReq.predicate = predicate
                
            if let fetchResults = managedObjectContext.executeFetchRequest(fetchReq, error: nil) as? [UserHealth] {
                userData = fetchResults
            }

            svc.Data = userData
                
            var isOn =  a1cGraph.on
            svc.inclA1C = isOn
                
            let aFetReq = NSFetchRequest(entityName: "UserA1C")
            aFetReq.predicate = predicate
            if let fetchARes = managedObjectContext.executeFetchRequest(aFetReq, error: nil) as? [UserA1C]{
                userA1CData = fetchARes
            }
            svc.a1c = userA1CData
        
            
            
        }
        
        else if(segue.identifier == "toTable"){
            var svc = segue.destinationViewController as tableVC;
            let fetchReq = NSFetchRequest(entityName: "UserHealth")
            
            let sortDesc = NSSortDescriptor(key: "dateTime", ascending: true)
            fetchReq.sortDescriptors = [sortDesc]
            if let fetchResults = managedObjectContext.executeFetchRequest(fetchReq, error: nil) as? [UserHealth] {
                userData = fetchResults
            }
            
            svc.Data = userData
            
            let aFetReq = NSFetchRequest(entityName: "UserA1C")
            if let fetchARes = managedObjectContext.executeFetchRequest(aFetReq, error: nil) as? [UserA1C]{
                userA1CData = fetchARes
            }
            svc.a1c = userA1CData
        }
    }
    
    @IBAction func nbccLink(sender: AnyObject) {
        if let url = NSURL(string: "http://www.nbcc.org/CounselorFind") {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    @IBAction func psychTodayLink(sender: AnyObject) {
        if let url = NSURL(string: "https://therapists.psychologytoday.com/rms/prof_search.php") {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    @IBAction func abaLink(sender: AnyObject) {
        if let url = NSURL(string: "http://www.diabetes.org/") {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    @IBAction func diabCareLink(sender: AnyObject) {
        if let url = NSURL(string: "http://care.diabetesjournals.org/") {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    
    @IBAction func fbLink(sender: AnyObject) {
        if let url = NSURL(string: "https://www.facebook.com/search/str/diabetes/keywords_top") {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    @IBAction func sisterLink(sender: AnyObject) {
        if let url = NSURL(string: "https://diabetessisters.org/") {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    @IBAction func diabulemiaLink(sender: AnyObject) {
        if let url = NSURL(string: "http://www.diabulimiahelpline.org/") {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    @IBAction func lilyLink(sender: AnyObject) {
        if let url = NSURL(string: "http://www.lillytruassist.com/_assets/pdf/lillycares_application.pdf") {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    @IBAction func copayLink(sender: AnyObject) {
        if let url = NSURL(string: "http://www.needymeds.org/copay_diseases.taf?_function=summary&disease_eng=Diabetes") {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    @IBAction func lifehackLink(sender: AnyObject) {
        if let url = NSURL(string: "http://www.healthline.com/diabetesmine/d-blog-week-going-all-macgyver-with-diabetes-life-hacks") {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    @IBAction func domesticLink(sender: AnyObject) {
        if let url = NSURL(string: "https://www.joslin.org/info/diabetes_and_travel_10_tips_for_a_safe_trip.html") {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    @IBAction func internationalLink(sender: AnyObject) {
        if let url = NSURL(string: "http://www.diabetesselfmanagement.com/about-diabetes/diabetes-basics/traveling-with-diabetes/planning-for-international-travel/") {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    func loginViewShowingLoggedInUser(loginView: FBLoginView!) {
        println("User Logged In")
    }
   
    func loginViewFetchedUserInfo(loginView: FBLoginView!, user: FBGraphUser!) {
        if(FB.hasActiveSession()){
            fbStuff.fName = user.first_name
            fbStuff.lName = user.last_name
            fbStuff.email = user.objectForKey("email") as String!
        }
    }
    
    @IBAction func disagreeTOS(sender: AnyObject) {
        let alert = UIAlertView()
        alert.title = "Alert"
        alert.message = "In order to use this application, you must agree with the terms of service. Please review the terms above."
        alert.addButtonWithTitle("Ok")
        alert.show()
    }
    
    @IBAction func exportLogs(sender: AnyObject) {
        let alert = UIAlertView()
        alert.title = "Alert"
        alert.message = "This functionality is currently in progress. Exporting will be released in a future update. My apologies."
        alert.addButtonWithTitle("Ok")
        alert.show()
    }
    
    func save() {
        var error : NSError?
        if(managedObjectContext.save(&error) ) {
            println(error?.localizedDescription)
        }
    }

    @IBAction func saveSetting(sender: AnyObject) {
        if(setCurEndoEmail.text.isEmpty || setMinBG.text.isEmpty || setMaxBG.text.isEmpty){
           println("Missing a parameter for setting, do not save")
            let alert = UIAlertView()
            alert.title = "Alert"
            alert.message = "Missing an entry. Please fill in all the settings."
            alert.addButtonWithTitle("Ok")
            alert.show()
        }
        else{
            var outF = NSDateFormatter()
            outF.locale = NSLocale(localeIdentifier: "en_US")
            outF.dateFormat = "MM-dd 'at' HH:mm"
            
            var outputFormat = NSDateFormatter()
            outputFormat.locale = NSLocale(localeIdentifier:"en_US")
            outputFormat.dateFormat = "HH:mm"
            
            var fetReq = NSFetchRequest(entityName: "UserID")
            let predicate = NSPredicate(format: "fbEmail == %@", fbStuff.email);
            fetReq.predicate = predicate;
            
            if let userItems = managedObjectContext.executeFetchRequest(fetReq, error: nil) as? [UserID] {
                if userItems.count != 0{
                    var managedObject = userItems[0]
                    println("Testing getting item: " + managedObject.endoEmail)
                    managedObject.setValue(setCurEndoEmail.text, forKey: "endoEmail")
                    println("New Endo Email: " + setCurEndoEmail.text)
                    managedObject.setValue(outF.stringFromDate(setNextEndoApt.date), forKey: "nextEndoApt")
                    println("Apt Date: " + outF.stringFromDate(setNextEndoApt.date))
                    managedObject.setValue(setMinBG.text.toInt(), forKey: "minGoalBS")
                    println("New minBG: " + setMinBG.text)
                    managedObject.setValue(setMaxBG.text.toInt(), forKey: "maxGoalBS")
                    println("New maxBG: " + setMaxBG.text)
                    managedObject.setValue(outputFormat.stringFromDate(setMorningTime.date), forKey: "morningMealTime")
                    println("New morning: " + outputFormat.stringFromDate(setMorningTime.date))
                    managedObject.setValue(outputFormat.stringFromDate(setLunchTime.date), forKey: "lunchMealTime")
                    println("New lunch: " + outputFormat.stringFromDate(setLunchTime.date))
                    managedObject.setValue(outputFormat.stringFromDate(setDinnerTime.date), forKey: "dinnerMealTime")
                    println("New dinner: " + outputFormat.stringFromDate(setDinnerTime.date))
                    managedObject.setValue(outputFormat.stringFromDate(setSnack1Time.date), forKey: "snack1MealTime")
                    println("New Snack1: " + outputFormat.stringFromDate(setSnack1Time.date))
                    managedObject.setValue(outputFormat.stringFromDate(setSnack2Time.date), forKey: "snack2MealTime")
                    println("New Snack2: " + outputFormat.stringFromDate(setSnack2Time.date))
                    println("Testing getting item: " + managedObject.endoEmail)
                    save()
                    performSegueWithIdentifier("toMenuFromSave", sender: nil)
               }
            }
            
            
        
        }
    }
}