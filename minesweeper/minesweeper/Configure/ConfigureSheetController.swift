import Foundation
import AppKit

class ConfigureSheetController: NSObject {
    
    @IBOutlet var window: NSWindow?
    @IBOutlet var themePopUpButton: NSPopUpButton?
    @IBOutlet var minesSlider: NSSlider?
    
    override init() {
        super.init()
        let myBundle = Bundle(for: ConfigureSheetController.self)
        myBundle.loadNibNamed("ConfigureSheet", owner: self, topLevelObjects: nil)
        themePopUpButton?.selectItem(withTitle: Preferences.theme)
        minesSlider?.doubleValue = Double(Preferences.mines)
    }
    
    @IBAction func close(_ sender: AnyObject) {
        themePopUpButton?.selectItem(withTitle: Preferences.theme)
        minesSlider?.doubleValue = Double(Preferences.mines)
        close()
    }
    
    @IBAction func save(_ sender: AnyObject) {
        Preferences.theme = themePopUpButton?.selectedItem?.title ?? "Classic"
        Preferences.mines = minesSlider?.integerValue ?? 1
        close()
    }
    
    private func close() {
        guard let window = self.window else {
            return
        }
        
        window.sheetParent?.endSheet(window)
    }
    
    
    
}
