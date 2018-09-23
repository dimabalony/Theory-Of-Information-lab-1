//
//  ColumsMethod.swift
//  Theory Of Information, lab 1
//
//  Created by Дмитрий Болоников on 9/22/18.
//  Copyright © 2018 Дмитрий Болоников. All rights reserved.
//

import Cocoa

class ColumsMethod: NSViewController {

    @IBOutlet weak var keyField: NSTextField!
    @IBOutlet weak var originalText: NSTextField!
    @IBOutlet weak var cipherText: NSTextField!
    
    @IBAction func encodeButton(_ sender: Any) {
        guard keyField.stringValue != "" || originalText.stringValue != "" else {
            dialogAlert()
            return
        }
        let textKey = keyField.stringValue.lowercased().filter(("a"..."z").contains)
        keyField.stringValue = textKey
        let textOriginal = originalText.stringValue.lowercased().filter(("a"..."z").contains)
        originalText.stringValue = textOriginal
        if textKey == "" || textOriginal == "" {
            dialogAlert()
            return
        }
        cipherText.stringValue = columnEncrypt(of: textOriginal, with: textKey)
    }
    
    @IBAction func decodeButton(_ sender: Any) {
        guard keyField.stringValue != "" || cipherText.stringValue != "" else {
            dialogAlert()
            return
        }
        let textKey = keyField.stringValue.lowercased().filter(("a"..."z").contains)
        keyField.stringValue = textKey
        let textCipher = cipherText.stringValue.lowercased().filter(("a"..."z").contains)
        cipherText.stringValue = textCipher
        if textKey == "" || textCipher == "" {
            dialogAlert()
            return
        }
        originalText.stringValue = columnDecrypt(of: textCipher, with: textKey)
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
    
    func columnEncrypt(of source: String, with key: String) -> String {
        let alphabet: [Character] = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
        var matrix: Array<Array<String>> = [[]]
        matrix.append([])
        for character in key {
            matrix[0].append(String(character))
            matrix[1].append("")
        }
        
        var index = 1
        for characterAlphabet in alphabet {
            for (indexMatrix, characterMatrix) in matrix[0].enumerated() {
                if String(characterAlphabet) == characterMatrix {
                    matrix[1][indexMatrix] = String(index)
                    index += 1
                }
            }
        }
        
        matrix.append([])
        var iIndex = 2, jIndex = 0
        for character in source {
            matrix[iIndex].append(String(character))
            jIndex += 1
            if jIndex >= matrix[0].count {
                iIndex += 1
                jIndex = 0
                matrix.append([])
            }
        }
        
        for _ in jIndex...(matrix[iIndex - 2].count - 1) {
            matrix[iIndex].append("")
        }
        var columnIndex = 0
        var result = ""
        while columnIndex <= matrix[1].count - 1 {
            var minJIndex = 0
            for (index, value) in matrix[1].enumerated() {
                if let a = Int(matrix[1][minJIndex]), let b = Int(value) {
                    if a > b {
                        minJIndex = index
                    }
                }
                
            }
            matrix[1][minJIndex] = "100"
            var i = 2
            while (i <= iIndex) && (matrix[i][minJIndex] != "") {
                result += matrix[i][minJIndex]
                i += 1
            }
            columnIndex += 1
        }
        return result
    }
    
    func columnDecrypt(of source: String, with key: String) -> String {
        let alphabet: [Character] = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
        var matrix: Array<Array<String>> = [[]]
        matrix.append([])
        for character in key {
            matrix[0].append(String(character))
            matrix[1].append("")
        }
        
        var index = 1
        for characterAlphabet in alphabet {
            for (indexMatrix, characterMatrix) in matrix[0].enumerated() {
                if String(characterAlphabet) == characterMatrix {
                    matrix[1][indexMatrix] = String(index)
                    index += 1
                }
            }
        }
        
        matrix.append([])
        var iIndex = 2, jIndex = 0
        for _ in source {
            matrix[iIndex].append("")
            jIndex += 1
            if jIndex >= matrix[0].count {
                iIndex += 1
                jIndex = 0
                matrix.append([])
            }
        }
        
        
        index = 1
        var indexSource = 0
        for _ in matrix[0] {
            for j in matrix[1].indices {
                if index == Int(matrix[1][j]) {
                    jIndex = j
                }
            }
            index += 1
            iIndex = 2
            while iIndex < matrix.count - 1 || iIndex == matrix.count - 1 && jIndex <= matrix[matrix.count - 1].count - 1 && indexSource <= source.count - 1 {
                matrix[iIndex][jIndex] = String(source[source.index(source.startIndex, offsetBy: indexSource)])
                indexSource += 1
                iIndex += 1
            }
        }
        
        
        var result = ""
        iIndex = 2
        jIndex = 0
        for _ in source {
            result += matrix[iIndex][jIndex]
            jIndex += 1
            if jIndex >= matrix[0].count {
                iIndex += 1
                jIndex = 0
            }
            
        }
        return result
    }
}
