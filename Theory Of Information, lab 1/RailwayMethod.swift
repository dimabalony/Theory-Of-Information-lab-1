//
//  RailwayMethod.swift
//  Theory Of Information, lab 1
//
//  Created by Дмитрий Болоников on 9/21/18.
//  Copyright © 2018 Дмитрий Болоников. All rights reserved.
//

import Cocoa

class RailwayMethod: NSViewController {
    
    @IBOutlet weak var fieldOriginal: NSTextField!
    @IBOutlet weak var cipherText: NSTextField!
    @IBOutlet weak var keyField: NSTextField!
    
    
    @IBAction func encodeButton(_ sender: Any) {
        guard keyField.stringValue != "" || fieldOriginal.stringValue != "" else {
            dialogAlert()
            return
        }
        guard let textKey = Int(keyField.stringValue) else {
            dialogAlert()
            return
        }
        keyField.stringValue = String(textKey)
        let textOriginal = fieldOriginal.stringValue.lowercased().filter(("a"..."z").contains)
        fieldOriginal.stringValue = textOriginal
        if textOriginal == "" {
            dialogAlert()
            return
        }
        cipherText.stringValue = railwayEncrypt(from: textOriginal, height: textKey)
    }
    
    @IBAction func decodeButton(_ sender: Any) {
        guard keyField.stringValue != "" || cipherText.stringValue != "" else {
            dialogAlert()
            return
        }
        guard let textKey = Int(keyField.stringValue) else {
            dialogAlert()
            return
        }
        keyField.stringValue = String(textKey)
        let textCipher = cipherText.stringValue.lowercased().filter(("a"..."z").contains)
        cipherText.stringValue = textCipher
        if textCipher == "" {
            dialogAlert()
            return
        }
        fieldOriginal.stringValue = railwayDecrypt(from: textCipher, height: textKey)
    }
    
    func dialogAlert() {
        let alert = NSAlert()
        alert.messageText = "Error"
        alert.informativeText = "Incorrect data"
        alert.alertStyle = .warning
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }
    
    @IBAction func loadFileEncrypted(_ sender: Any) {
        let dialog = NSOpenPanel();
        
        dialog.title                   = "Choose a .txt file"
        dialog.showsResizeIndicator    = true
        dialog.showsHiddenFiles        = false
        dialog.canChooseDirectories    = false
        dialog.canCreateDirectories    = false
        dialog.allowsMultipleSelection = false
        dialog.allowedFileTypes        = ["txt"]
        
        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            let result = dialog.url
            
            if (result != nil) {
                do {
                    fieldOriginal.stringValue = try String(contentsOf: result!, encoding: .utf8)
                }
                catch {
                     print("Error")
                }
            }
        } else {
            return
        }
    }
    
    @IBAction func saveFileEncrypted(_ sender: Any) {
        let dialog = NSOpenPanel();
        
        dialog.title                   = "Choose a .txt file"
        dialog.showsResizeIndicator    = true
        dialog.showsHiddenFiles        = false
        dialog.canChooseDirectories    = false
        dialog.canCreateDirectories    = false
        dialog.allowsMultipleSelection = false
        dialog.allowedFileTypes        = ["txt"]
        
        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            let result = dialog.url
            
            if let myResult = result {
                do {
                    try fieldOriginal.stringValue.write(to: myResult, atomically: true, encoding: .utf8)
                }
                catch {
                    print("Failed writing to URL: \(myResult), Error: " + error.localizedDescription)
                }
            }
        } else {
            return
        }
    }
    
    @IBAction func loadFileCipher(_ sender: Any) {
        let dialog = NSOpenPanel();
        
        dialog.title                   = "Choose a .txt file"
        dialog.showsResizeIndicator    = true
        dialog.showsHiddenFiles        = false
        dialog.canChooseDirectories    = false
        dialog.canCreateDirectories    = false
        dialog.allowsMultipleSelection = false
        dialog.allowedFileTypes        = ["txt"]
        
        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            let result = dialog.url
            
            if (result != nil) {
                do {
                    cipherText.stringValue = try String(contentsOf: result!, encoding: .utf8)
                }
                catch {
                    print("Error")
                }
            }
        } else {
            return
        }
    }
    
    @IBAction func saveFileCipher(_ sender: Any) {
        let dialog = NSOpenPanel();
        
        dialog.title                   = "Choose a .txt file"
        dialog.showsResizeIndicator    = true
        dialog.showsHiddenFiles        = false
        dialog.canChooseDirectories    = false
        dialog.canCreateDirectories    = false
        dialog.allowsMultipleSelection = false
        dialog.allowedFileTypes        = ["txt"]
        
        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            let result = dialog.url
            
            if let myResult = result {
                do {
                    try cipherText.stringValue.write(to: myResult, atomically: true, encoding: .utf8)
                }
                catch {
                    print("Failed writing to URL: \(myResult), Error: " + error.localizedDescription)
                }
            }
        } else {
            return
        }
    }
    
    func railwayEncrypt(from source: String, height: Int) -> String {
        let maxPeriod = (height - 1) * 2
        var result = "", period1 = maxPeriod, period2 = maxPeriod
        if height != 1 {
            for row in 0...height - 1 {
                var toggle = true
                var index = row
                while index <= source.count - 1 {
                    result += String(source[source.index(source.startIndex, offsetBy: index)])
                    if toggle {
                        index += period1
                    } else {
                        index += period2
                    }
                    toggle = !toggle
                }
                period1 -= 2
                period2 = maxPeriod - period1
                if period1 == 0 {
                    period1 = maxPeriod
                }
            }
        } else {
            result = source
        }
        return result
    }

    
    func railwayDecrypt(from source: String, height: Int) -> String {
        let maxPeriod = (height - 1) * 2
        var index = 0, encrypted = Array(repeating: "", count: source.count), period1 = maxPeriod, period2 = maxPeriod, indexSource = 0
        var result = ""
        if height != 1 {
            for _ in 0...height - 1 {
                var toggle = true
                while (index < source.count) && (indexSource < source.count) {
                    encrypted[index] = String(source[source.index(source.startIndex, offsetBy: indexSource)])
                    indexSource += 1
                    if toggle {
                        index += period1
                    } else {
                        index += period2
                    }
                    toggle = !toggle
                }
                period1 -= 2
                if period1 == 0 {
                    period1 = maxPeriod
                    period2 = maxPeriod
                } else {
                    period2 = maxPeriod - period1
                }
                index = period2 / 2
            }
            for char in encrypted  {
                result += char
            }
        } else {
          result = source
        }
        return result
    }
    
}
