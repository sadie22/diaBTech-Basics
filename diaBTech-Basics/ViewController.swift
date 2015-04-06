//
//  ViewController.swift
//  diaBTech-Basics
//
//  Created by Mercedes Streeter on 1/26/15.
//  Copyright (c) 2015 Mercedes Streeter. All rights reserved.
//

import UIKit
import CoreData


class ViewController: UIViewController, FBLoginViewDelegate, UITableViewDelegate, UITableViewDataSource {

    var userItems = [useridTable]()
    var userData = [Userhealth]()
    var userA1CData = [UserA1C]()
    
    //all outlets for registration 
    @IBOutlet weak var endEmail: UITextField!
    @IBOutlet weak var aptDate: UIDatePicker!
    @IBOutlet weak var minGoal: UITextField!
    @IBOutlet weak var maxGoal: UITextField!
    @IBOutlet weak var breakfMeal: UIDatePicker!
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
    
    
    //outlets for comments
    @IBOutlet weak var comments: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!

    //table for Activity Log
    @IBOutlet weak var logTable: UITableView!
    
    //Facebook & Session outlets
    @IBOutlet weak var fbLogin: FBLoginView!
    var hasSession: Boolean!
    @IBOutlet weak var landPageText: UILabel!
    @IBOutlet weak var widthConst: NSLayoutConstraint!
    
    //Register outlets
    @IBOutlet weak var endoEmail: UITextField!
    @IBOutlet weak var minBG: UITextField!
    @IBOutlet weak var maxBG: UITextField!
    @IBOutlet weak var morningMealT: UIDatePicker!
    @IBOutlet weak var lunchMealT: UIDatePicker!
    @IBOutlet weak var dinnerMealT: UIDatePicker!
    @IBOutlet weak var snackT1: UIDatePicker!
    @IBOutlet weak var snackT2: UIDatePicker!
    

    
    //managedObjectContext var
    /*lazy var managedObjectContext : NSManagedObjectContext? = {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if let managedObjectContext = appDelegate.managedObjectContext {
            return managedObjectContext
        }
        else {
            return nil
        }
    }()*/
    
    @IBOutlet var regView: UIView!
    @IBOutlet weak var regScroll: UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*var viewFrame = self.view.frame
        viewFrame.origin.y += 20
        viewFrame.size.height  -= 20
        logTable.frame = viewFrame
        self.view.addSubview(logTable)
        logTable.registerClass(UITableView.classForCoder(), forCellReuseIdentifier: "UserHealth")*/
    }
    
    override func viewWillAppear(animated: Bool) {
       // updateLabelWidths()
    }

    
    func updateLabelWidths() {
        // force views to layout in viewWillAppear so we can adjust widths of labels before the view is visible
        view.layoutIfNeeded()
        landPageText.resizeHeightToFit(widthConst)
       
    }
    
    
    @IBAction func regMenu(sender: AnyObject) {
        if(FB.hasActiveSession()){
            performSegueWithIdentifier("registrationScene1", sender: nil)
            println("HasSession is true");
        }
        else{
            //show error message
            println("HasSession is false");
        }
        
    }
    
    @IBAction func addLog(sender: AnyObject) {
        /*if let moc = self.managedObjectContext {
            var dateAA: NSDate = dateActivity.date
            var doubleII : Double = NSString(string: insulinActivity.text).doubleValue
            var doubleCC : Double = NSString(string: ccActivity.text).doubleValue
            let readingInt:Int = readingActivity.text.toInt()!
            let noteString:NSString = notesActivity.text!
            userhealth.createInManagedObjectContextHealth(moc, dT: dateAA, BSreading: readingInt, estCC: doubleCC, II: doubleII, note: noteString)
        }*/
        var doubleII : Double = NSString(string: insulinActivity.text).doubleValue
        var doubleCC : Double = NSString(string: ccActivity.text).doubleValue
        
        var appDel:AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate);
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        var newHealth = NSEntityDescription.insertNewObjectForEntityForName("UserHealth", inManagedObjectContext: context) as NSManagedObject
        newHealth.setValue(dateActivity.date, forKey: "dateTime")
        newHealth.setValue(doubleII, forKey: "insulinInTake")
        newHealth.setValue(doubleCC, forKey: "estCarbCount")
        newHealth.setValue(readingActivity.text.toInt(), forKey: "bloodSugarReading")
        newHealth.setValue(notesActivity.text, forKey: "notes")

        
        println("Did newHealth change? ", newHealth.hasChanges);

        println(context.hasChanges)
    }
    
    
    @IBAction func addRegister(sender: AnyObject) {
      //  if let moc = self.managedObjectContext {
        var appDel:AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate);
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        var newUser = NSEntityDescription.insertNewObjectForEntityForName("userid", inManagedObjectContext: context) as NSManagedObject
            var fbFirstName = "First"
            var fbLastName = "Last"
       
        
        println("Did newUser change? ", newUser.hasChanges);
        
        println(context.hasChanges)
       
    }
    
    @IBAction func addA1C(sender: AnyObject) {
        var readingDouble : Double  = NSString(string: readingA1C.text).doubleValue
        var appDel:AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate);
        var context:NSManagedObjectContext = appDel.managedObjectContext!
       var newA1C = NSEntityDescription.insertNewObjectForEntityForName("UserA1C", inManagedObjectContext: context) as NSManagedObject
        newA1C.setValue(dateTimeA1C.date, forKey: "dateTime")
        newA1C.setValue(readingDouble, forKey: "a1c")
        
        println("Did newA1C change? ", newA1C.hasChanges);
        
        println(context.hasChanges)
    }
    
    
    //FB delegate methods
    
    func loginViewShowingLoggedInUser(loginView: FBLoginView!) {
        println("Has session: ", FBSession.activeSession());
        println("User Logged In");
    }

    @IBAction func viewLogs(sender: AnyObject) {
        //tableView = logTable
        var appDel:AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate);
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        let fetchReq = NSFetchRequest(entityName: "UserHealth");
        
        
        let sortDesc = NSSortDescriptor(key: "dateTime", ascending: true)
        fetchReq.sortDescriptors = [sortDesc]
        
        let predicate = NSPredicate(format: "dateTime == %@", "");
        
        fetchReq.predicate = predicate;
        
        if let fetchResults = context.executeFetchRequest(fetchReq, error: nil) as? [Userhealth]{
            userData = fetchResults
        }
        println(userData.count)
    }
    
    
    // MARK: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // How many rows are there in this section?
        // There's only 1 section, and it has a number of rows
        // equal to the number of logItems, so return the count
        return userData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = logTable.dequeueReusableCellWithIdentifier("Userhealth") as UITableViewCell
        
        // Get the LogItem for this index
        let logItem = userData[indexPath.row]
        
        // Set the title of the cell to be the title of the logItem
        //cell.textLabel?.text = logItem.dateTime.
        return cell
    }
    
    // MARK: UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let logItem = userData[indexPath.row]
        println(logItem.bloodSugarReading)
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
   
}

