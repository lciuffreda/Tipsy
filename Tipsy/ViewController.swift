import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var billView: UIView!
    @IBOutlet weak var tipView: UIView!
    @IBOutlet weak var splitView: UIView!
    @IBOutlet weak var segmentedCtrl: UISegmentedControl!
    @IBOutlet weak var settingBtn: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalWithTipLabel: UILabel!
    
    var currencyFormatter: NSNumberFormatter?
    var animationPerformed = false
    var percentageArray = [0.25,0.75,1]
    var selectedPercentage = 0
    var isDarkBckgSelected = false
    let centerOffSet:CGFloat = 30.0
    var initialBillViewCenter: CGFloat?
    var initialTipViewCenter: CGFloat?
    var initialSplitViewCenter: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getInitialCenterPosition()
        animateInitialView()
        initializeCurrencyFormatter()
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
        textField.placeholder = String(NSLocale.currentLocale().objectForKey(NSLocaleCurrencySymbol)!)
        selectedPercentage = segmentedCtrl.selectedSegmentIndex
    }
    
    //Segue to setup the SettingViewController object
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showSettingPage" {
            let navCtrl = segue.destinationViewController as! UINavigationController
            let settingVC = navCtrl.topViewController as! SettingViewController
            settingVC.delegate = self
            settingVC.selectedIndexInSegmCtrl = selectedPercentage
            settingVC.isDarkColorSelected = isDarkBckgSelected
        }
    }
    
    //MARK: IBActions
  
    @IBAction func segmentedCtrlValueChanged(sender: UISegmentedControl) {
        selectedPercentage = segmentedCtrl.selectedSegmentIndex
        updateTotalsBasedOnTipPercentage(percentageArray[selectedPercentage])
    }

    @IBAction func textFieldEditingChanged(sender: UITextField) {
        textField.becomeFirstResponder()
        animationPerformed = sender.text?.characters.count > 0
        animateViewsWhileTyping()
        totalLabel.text = currencyFormatter!.stringFromNumber((sender.text! as NSString).doubleValue)
        updateTotalsBasedOnTipPercentage(percentageArray[selectedPercentage])
    }
    
    //MARK: Additional functions
    
    func initializeCurrencyFormatter() {
        currencyFormatter = NSNumberFormatter()
        currencyFormatter!.numberStyle = .CurrencyStyle
        currencyFormatter!.locale = NSLocale.currentLocale()
        currencyFormatter!.currencyCode = NSLocale.currentLocale().displayNameForKey(NSLocaleCurrencySymbol, value: NSLocaleCurrencyCode)
    }
    
    //Setting initial alpha state for some UI components
    func animateInitialView() {
        segmentedCtrl.alpha = 0.0
        settingBtn.alpha = 0.0
        totalLabel.alpha = 0.0
        tipView.alpha = 0.0
        splitView.alpha = 0.0
        billView.center.y = initialBillViewCenter!+centerOffSet
        tipView.center.y = initialTipViewCenter!+centerOffSet
        splitView.center.y = initialSplitViewCenter!+centerOffSet
    }
    
    //Save initial center positions
    func getInitialCenterPosition() {
        initialBillViewCenter = billView.center.y
        initialTipViewCenter = tipView.center.y
        initialSplitViewCenter = splitView.center.y
    }
    
    //Dismiss keyboard
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //Animation while typing in the textfield
    func animateViewsWhileTyping() {
        UIView.animateWithDuration(0.5, delay: 0.1, options: [], animations: {
            self.segmentedCtrl.alpha = self.animationPerformed ? 1.0 : 0.0
            self.settingBtn.alpha = self.animationPerformed ? 1.0 : 0.0
            }, completion: nil)
        
        UIView.animateWithDuration(0.5, delay: 0.2, options: [], animations: {
            self.totalLabel.alpha = self.animationPerformed ? 1.0 : 0.0
            self.totalWithTipLabel.alpha = self.animationPerformed ? 1.0 : 0.0
            }, completion: nil)
        
        
        UIView.animateWithDuration(0.5, delay: 0.3, options: [], animations: {
            self.billView.center.y = self.animationPerformed ? self.initialBillViewCenter! : (self.initialBillViewCenter!+self.centerOffSet)
            self.tipView.alpha = self.animationPerformed ? 1.0 : 0.0
            self.splitView.alpha = self.animationPerformed ? 1.0 : 0.0
            self.tipView.center.y = self.animationPerformed ? self.initialTipViewCenter! : (self.initialTipViewCenter!+self.centerOffSet)
            self.splitView.center.y = self.animationPerformed ? self.initialSplitViewCenter! : (self.initialSplitViewCenter!+self.centerOffSet)
            
            if !self.isDarkBckgSelected {
                self.billView.backgroundColor = self.animationPerformed ? self.uicolorFromHex(0x63CFFF) : UIColor.clearColor()
            } else {
                self.billView.backgroundColor = self.animationPerformed ? self.uicolorFromHex(0x294739) : UIColor.clearColor()
            }
            }, completion:nil)
    }
    
    //Update the total...
    func updateTotalsBasedOnTipPercentage(percentage: Double) {
        let tipLabelDec = (textField.text! as NSString).doubleValue * percentage
        let grandTotal = (textField.text! as NSString).doubleValue + tipLabelDec
        tipLabel.text = currencyFormatter!.stringFromNumber(tipLabelDec)
        totalWithTipLabel.text = currencyFormatter!.stringFromNumber(grandTotal)
        updateSplitBillBasedOnTotal(grandTotal)
    }
    
    //...and the total for several people
    func updateSplitBillBasedOnTotal(total: Double) {
        for var i=2 ; i<5; i++ {
            let spliLabelWithTag = view.viewWithTag(i) as! UILabel
            let splitTotal = total / Double(i)
            spliLabelWithTag.text = currencyFormatter!.stringFromNumber(splitTotal)
        }
    }
    
    func changeToDarkBackgroundColor(darkBkgSelected: Bool) {
        billView.backgroundColor = darkBkgSelected ? uicolorFromHex(0x294739) : uicolorFromHex(0x63CFFF)
        segmentedCtrl.tintColor = darkBkgSelected ? uicolorFromHex(0x78C091) : uicolorFromHex(0x4692B3)
        tipView.backgroundColor = darkBkgSelected ? uicolorFromHex(0x582707) : uicolorFromHex(0x4692B3)
        splitView.backgroundColor = darkBkgSelected ? uicolorFromHex(0x582707) : uicolorFromHex(0x4692B3)
    }
    
    //Return the color from HEX
    func uicolorFromHex(rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
    
    //Change Status bar color
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        let statusBarStyle:UIStatusBarStyle = isDarkBckgSelected ? .LightContent : .Default
        return statusBarStyle
    }
}

//MARK: SettingViewControllerDelegate
extension ViewController: SettingViewControllerDelegate {
    
    //Delegate method from the SettingViewController object
    func didFinishSelectingValue(valueSelected: Int, withDarkColor: Bool) {
        //Update the percentage based on the value selected
        segmentedCtrl.selectedSegmentIndex = valueSelected
        selectedPercentage = valueSelected
        updateTotalsBasedOnTipPercentage(percentageArray[selectedPercentage])
        //Modify the backgorund color
        isDarkBckgSelected = withDarkColor
        changeToDarkBackgroundColor(isDarkBckgSelected)
    }
}
