//
//  VigenereColums.swift
//  Theory Of Information, lab 1
//
//  Created by Дмитрий Болоников on 9/22/18.
//  Copyright © 2018 Дмитрий Болоников. All rights reserved.
//

import Cocoa

class VigenereColums: NSViewController {

    @IBOutlet weak var keyField: NSTextField!
    @IBOutlet weak var originalText: NSTextField!
    @IBOutlet weak var cipherText: NSTextField!
    
    @IBAction func encodeButton(_ sender: Any) {
        guard keyField.stringValue != "" || originalText.stringValue != "" else {
            dialogAlert()
            return
        }
        let textKey = keyField.stringValue.lowercased().filter(("а"..."ё").contains)
        keyField.stringValue = textKey
        let textOriginal = originalText.stringValue.lowercased().filter(("а"..."ё").contains)
        originalText.stringValue = textOriginal
        if textKey == "" || textOriginal == "" {
            dialogAlert()
            return
        }
        cipherText.stringValue = vigenereEncrypt(of: textOriginal, with: textKey)
    }
    
    @IBAction func decodeButton(_ sender: Any) {
        guard keyField.stringValue != "" || cipherText.stringValue != "" else {
            dialogAlert()
            return
        }
        let textKey = keyField.stringValue.lowercased().filter(("а"..."ё").contains)
        keyField.stringValue = textKey
        let textCipher = cipherText.stringValue.lowercased().filter(("а"..."ё").contains)
        cipherText.stringValue = textCipher
        if textKey == "" || textCipher == "" {
            dialogAlert()
            return
        }
        originalText.stringValue = vigenereDecrypt(of: textCipher, with: textKey)
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
                    originalText.stringValue = try String(contentsOf: result!, encoding: .utf8)
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
                    try originalText.stringValue.write(to: myResult, atomically: true, encoding: .utf8)
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
    
    func vigenereEncrypt(of source: String, with key: String) -> String {
        let alphabet = ["а", "б", "в", "г", "д", "е", "ё", "ж", "з", "и", "й", "к", "л", "м", "н", "о", "п", "р", "с", "т", "у", "ф", "х", "ц", "ч", "ш", "щ", "ь", "ы", "ъ", "э", "ю", "я"]
        var result = ""
        var indexKey = 0
        for character in source {
            var indexSourceInAlphabet = 0
            var indexKeyInAlphabet = 0
            for (index, value) in alphabet.enumerated() {
                if value == String(character) {
                    indexSourceInAlphabet = index
                }
                if value == String(key[key.index(key.startIndex, offsetBy: indexKey)]) {
                    indexKeyInAlphabet = index
                }
            }
            indexKey += 1
            if indexKey >= key.count {
                indexKey = 0
            }
            let index = (indexKeyInAlphabet + indexSourceInAlphabet) % 33
            result += String(alphabet[alphabet.index(alphabet.startIndex, offsetBy: index)])
            
        }
        return result
    }
    
    func vigenereDecrypt(of source: String, with key: String) -> String {
        let alphabet = ["а", "б", "в", "г", "д", "е", "ё", "ж", "з", "и", "й", "к", "л", "м", "н", "о", "п", "р", "с", "т", "у", "ф", "х", "ц", "ч", "ш", "щ", "ь", "ы", "ъ", "э", "ю", "я"]
        let sourceWithoutSpaces = source.replacingOccurrences(of: " ", with: "")
        var result = ""
        var indexKey = 0
        for character in sourceWithoutSpaces {
            var indexSourceInAlphabet = 0
            var indexKeyInAlphabet = 0
            for (index, value) in alphabet.enumerated() {
                if value == String(character) {
                    indexSourceInAlphabet = index
                }
                if value == String(key[key.index(key.startIndex, offsetBy: indexKey)]) {
                    indexKeyInAlphabet = index
                }
            }
            indexKey += 1
            if indexKey >= key.count {
                indexKey = 0
            }
            let index = (indexSourceInAlphabet + 33 - indexKeyInAlphabet) % 33
            result += String(alphabet[alphabet.index(alphabet.startIndex, offsetBy: index)])
            
        }
        return result
    }
}
