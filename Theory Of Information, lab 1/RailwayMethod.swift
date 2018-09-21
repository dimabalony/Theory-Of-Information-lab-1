//
//  RailwayMethod.swift
//  Theory Of Information, lab 1
//
//  Created by Дмитрий Болоников on 9/21/18.
//  Copyright © 2018 Дмитрий Болоников. All rights reserved.
//

import Cocoa

class RailwayMethod: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBOutlet weak var fieldOriginal: NSTextField!
    @IBOutlet weak var cipherText: NSTextField!
    @IBOutlet weak var keyField: NSTextField!
    
    
    @IBAction func encodeButton(_ sender: Any) {
        guard let number = Int(keyField.stringValue) else {
            return
        }
        cipherText.stringValue = railwayEncrypt(from: fieldOriginal.stringValue, height: number)
    }
    
    func railwayEncrypt(from source: String, height: Int) -> String {
        let sourceWithoutSpace = source.replacingOccurrences(of: " ", with: "")
        let maxPeriod = (height - 1) * 2
        var result = "", period1 = maxPeriod, period2 = maxPeriod
        for row in 0...height - 1 {
            var toggle = true
            var index = row
            while index <= sourceWithoutSpace.count - 1 {
                result += String(sourceWithoutSpace[sourceWithoutSpace.index(sourceWithoutSpace.startIndex, offsetBy: index)])
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
        return result
    }
    
    func railwayDecrypt(from source: String, height: Int) {
        let maxPeriod = (height - 1) * 2
        var index = 0, encrypted = Array(repeating: "", count: source.count), period1 = maxPeriod, period2 = maxPeriod, indexSource = 0
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
        var result = ""
        for char in encrypted  {
            result += char
        }
    }
    
}
