import UIKit

protocol SettingViewControllerDelegate: class {
    func didFinishSelectingValue(valueSelected: Int, withDarkColor: Bool)
}

class SettingViewController: UIViewController {
    
    weak var delegate: SettingViewControllerDelegate?
    var selectedIndexInSegmCtrl = 0
    var isDarkColorSelected = false
    @IBOutlet weak var segmentedCtrl: UISegmentedControl!
    @IBOutlet weak var changeColorSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        segmentedCtrl.selectedSegmentIndex = selectedIndexInSegmCtrl
        changeColorSwitch.on = isDarkColorSelected
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func segmentedCtrlValueChanged(sender: UISegmentedControl) {
        selectedIndexInSegmCtrl = sender.selectedSegmentIndex
    }
    
    @IBAction func cancelBtnTapped(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func doneBtnPressed(sender: UIBarButtonItem) {
        delegate?.didFinishSelectingValue(selectedIndexInSegmCtrl, withDarkColor: isDarkColorSelected)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func switchToDarkColor(sender: UISwitch) {
        isDarkColorSelected = sender.on
    }
}
