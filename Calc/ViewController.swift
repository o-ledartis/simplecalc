//
//  ViewController.swift
//  Calc
//
//  Created by Oleh on 10/2/18.
//  Copyright © 2018 Oleh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var displayResult: UILabel!
    var stillTyping = false
    var dotIsPlace = false
    var firstOperand : Double = 0
    var secondOperand : Double = 0
    var operationSign : String = ""
    var prevSign : String = ""
    var operationKey : String = ""
    var equalityKey : String = ""
    var signPress = 0
    
    var CurrentInput : Double {
        get {
            return Double(displayResult.text!)!
        }
        
        set {
            let value = "\(newValue)"
            let valueArray = value.components(separatedBy: ".")
            if valueArray[1] == "0" {
                displayResult.text = valueArray[0]
            } else {
                displayResult.text = "\(newValue)"
            }
            stillTyping = false
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func numberPressed(_ sender: UIButton) {
        let number = sender.currentTitle!
    
        if stillTyping {
            if displayResult.text!.count < 18 {
                displayResult.text = displayResult.text! + number
            }
        } else {
            displayResult.text = number
            stillTyping = true
        }
    }
  
    @IBAction func TwoOperandsPressed(_ sender: UIButton) {
        signPress += 1
        
        if signPress == 1 {
            firstOperand = CurrentInput
        } else if signPress > 1 {
            secondOperand = CurrentInput
            prevSign = operationSign
        }
        
        operationSign = sender.currentTitle!
        stillTyping = false
        dotIsPlace = false
    }
    
    func operateWithTwoOperands(operation: (Double, Double) -> Double) {
        CurrentInput = operation(firstOperand, secondOperand)
        stillTyping = false
    }
    
    @IBAction func equalityPressed(_ sender: UIButton) {
        operationKey = sender.currentTitle!
        equalityKey = sender.currentTitle!
        
        if signPress > 1 || operationKey == "=" {
            
            if stillTyping {
                secondOperand = CurrentInput
            }
        
            dotIsPlace = false

            if operationKey != "=" {
                operationKey = prevSign
            } else {
                operationKey = operationSign
            }
            
            switch operationKey {
                case "+":
                    operateWithTwoOperands{$0 + $1}
                case "-":
                    operateWithTwoOperands{$0 - $1}
                case "×":
                    operateWithTwoOperands{$0 * $1}
                case "÷":
                    if secondOperand == 0 {
                        displayResult.text = "На 0 не делится"
                    } else {
                        operateWithTwoOperands{$0 / $1}
                }
            default: break
            }
 
            if equalityKey == "=" {
                signPress = 0
            } else {
                firstOperand = CurrentInput
            }
        }
    }

    @IBAction func clearPressed(_ sender: UIButton) {
        firstOperand = 0
        secondOperand = 0
        signPress = 0
        CurrentInput = 0
        displayResult.text = "0"
        stillTyping = false
        operationSign = ""
        prevSign = ""
        operationKey = ""
        dotIsPlace = false
    }
    
    @IBAction func plusMinusPressed(_ sender: UIButton) {
       CurrentInput = -CurrentInput
    }
    
    @IBAction func percentPressed(_ sender: UIButton) {
        if firstOperand == 0 {
            CurrentInput = CurrentInput / 100
        } else {
            secondOperand = firstOperand * CurrentInput / 100
        }
        stillTyping = false
    }
    
    @IBAction func sqrtPressed(_ sender: UIButton) {
        if CurrentInput >= 0 {
            CurrentInput = sqrt(CurrentInput)
        } else{
            displayResult.text = "Ошибка"
        }
    }
   
    @IBAction func dotPressed(_ sender: UIButton) {
        if stillTyping && !dotIsPlace {
            displayResult.text = displayResult.text! + "."
            dotIsPlace = true
        } else if !stillTyping && !dotIsPlace {
            displayResult.text = "0."
        }
    }
   
}
