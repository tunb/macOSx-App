//
//  EurViewController.swift
//  EUR
//
//  Created by Ajai Nair on 7/27/19.
//  Copyright © 2019 mrb. All rights reserved.
//

import Cocoa

class EurViewController: NSViewController, NSTextFieldDelegate {
    
    @IBOutlet var finalLabel: NSTextField!
    @IBOutlet var inputField: NSTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        finalLabel.stringValue = String(SharedVar.sharedInstance.getCurrency() * 0)
        inputField.delegate = self
    }
    
    func controlTextDidChange(_ obj: Notification) {
        // check the identifier to be sure you have the correct textfield if more are used
        if let textField = obj.object as? NSTextField, self.inputField.identifier == textField.identifier {
            let amount = Float(inputField.stringValue)
            if amount != nil {
                var finalValue = SharedVar.sharedInstance.getCurrency() * amount! * 1.24
                if finalValue < 1000 {
                    finalValue = (finalValue * 10).rounded() / 10
                } else {
                    finalValue = Float(Int(finalValue))
                }
                let formatter = NumberFormatter()
                formatter.usesGroupingSeparator = true
                formatter.locale = Locale(identifier: "de_DE")
                formatter.numberStyle = .decimal
                finalLabel.stringValue = formatter.string(from: NSNumber(value: finalValue))!
            } else {
                finalLabel.stringValue = "0"
            }
        }
    }
    
    public func reset() {
        inputField.stringValue = ""
        finalLabel.stringValue = ""
    }
}


extension EurViewController {
    static func freshController() -> EurViewController {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier("EurViewController")
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? EurViewController else {
            fatalError("Why can't I find EurViewController? - Check Main.storyboard")
        }
        return viewcontroller
    }
}

extension EurViewController {
    @IBAction func quit(_sender: NSButton) {
        NSApplication.shared.terminate(_sender)
    }
}
