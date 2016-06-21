//
//  ViewController.swift
//  calculator
//
//  Created by Jerry Sun on 6/16/16.
//  Copyright © 2016 Jerry Sun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var display: UILabel!
    var userTyping : Bool = false
    var calculator = CalculatorBrain()
    @IBOutlet weak var formula: UILabel!
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if ( userTyping == true ){
            display.text  = display.text! + digit
        }
        else {
            display.text = digit
            userTyping = true
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        if userTyping == true {
            enter()
        }
        let op = sender.currentTitle!
        calculator.performOperation(op)
        if let result = calculator.calculate() {
            displayValue = result
            formula.text = calculator.formula()!
        }
        else {
            display.text = "ERROR"
            formula.text = "ERROR"
        }
    }
    
    @IBAction func clean(sender: UIButton) {
        display.text = "0"
        userTyping = false
        enter()
    }
    
    @IBAction func allClean() {
        userTyping = false
        displayValue = 0
        calculator = CalculatorBrain()
        formula.text = "Formula"
    }
    
    @IBAction func enter() {
        userTyping = false
        if let result = calculator.pushOperand(displayValue){
            displayValue = result
        }
        else {
            allClean()
            display.text = "ERROR"
        }
    }
    
    var displayValue : Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
        }
    }
}

