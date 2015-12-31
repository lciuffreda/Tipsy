import UIKit

private let lastTextFieldAmt = "last_textfield_amount"
private let lastPercentageSelected = "last_percentage_selected"
private let lastDate = "last_bill_date"
private let darkColorSelected = "darkColorSelected"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var rootViewController: ViewController?
    var maxTimeLimitInSec:Double = 600
    var userDefault: NSUserDefaults?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        rootViewController = window?.rootViewController as? ViewController
        userDefault = NSUserDefaults.standardUserDefaults()
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        applicationWillResignActive()
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        applicationDidBecomeActive()
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //MARK: Resign/Become active notifications
    
    //Load the values if the app becomes active
    func applicationDidBecomeActive() {
        let lastBillDate = userDefault!.valueForKey(lastDate) as? NSDate
        let currentDate = getCurrentDate()
        if let lastBillDate = lastBillDate {
            let timeFrame = currentDate.timeIntervalSinceDate(lastBillDate)
            let isTimeLimitNotElapsed = timeFrame < maxTimeLimitInSec
            setValueInRootViewController(isTimeLimitNotElapsed)
        }
    }
    
    //Save the values if the app enters in the background
    func applicationWillResignActive(){
        userDefault!.setObject(rootViewController!.textField.text, forKey: lastTextFieldAmt)
        userDefault!.setInteger(rootViewController!.segmentedCtrl.selectedSegmentIndex, forKey:lastPercentageSelected)
        userDefault!.setObject(getCurrentDate(), forKey: lastDate)
        userDefault?.setBool(rootViewController!.isDarkBckgSelected, forKey: darkColorSelected)
        userDefault!.synchronize()
    }
    
    func setValueInRootViewController(isTimeLimitNotExpired: Bool) {
        rootViewController?.isDarkBckgSelected = isTimeLimitNotExpired ? (userDefault!.valueForKey(darkColorSelected) as? Bool)! : false
        
        rootViewController!.textField.text =
                                    isTimeLimitNotExpired ? userDefault!.valueForKey(lastTextFieldAmt) as? String : ""
        
        if rootViewController!.textField.text!.characters.count > 0 {
            rootViewController!.changeToDarkBackgroundColor(rootViewController!.isDarkBckgSelected)
        }
        
        rootViewController!.segmentedCtrl.selectedSegmentIndex =
                                    isTimeLimitNotExpired ? (userDefault!.valueForKey(lastPercentageSelected) as? Int)! : 0
        rootViewController?.selectedPercentage = rootViewController!.segmentedCtrl.selectedSegmentIndex
        rootViewController!.textFieldEditingChanged(rootViewController!.textField)
    }
    
    //Get current date
    func getCurrentDate() -> NSDate {
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.timeStyle = NSDateFormatterStyle.ShortStyle
        formatter.dateStyle = NSDateFormatterStyle.ShortStyle
        formatter.stringFromDate(currentDateTime)
        return currentDateTime
    }
}

