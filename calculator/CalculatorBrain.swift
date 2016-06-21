//
//  CalculatorBrain.swift
//  calculator
//
//  Created by Jerry Sun on 6/19/16.
//  Copyright © 2016 Jerry Sun. All rights reserved.
//

import Foundation

class CalculatorBrain {
    private enum Op : CustomStringConvertible{
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, ((Double,Double) -> Double))
        
        var description : String {
            get {
            switch self {
            case .Operand(let operand):
                return String(operand)
            case .UnaryOperation(let operation, _):
                return operation
            case .BinaryOperation(let operation, _):
                return operation
            }
            }
        }
    }
    
    private var opStack = [Op]()
    
    private var knownOps = Dictionary<String, Op>()
    
    init() {
        func learnOp(op: Op){
            knownOps[op.description] = op
        }
        learnOp(Op.BinaryOperation("+", +))
        learnOp(Op.BinaryOperation("-") { $1 - $0 })
        learnOp(Op.BinaryOperation("×", *))
        learnOp(Op.BinaryOperation("÷") { $1 / $0 })
        learnOp(Op.UnaryOperation("-", -))
        learnOp(Op.UnaryOperation("√", { sqrt($0) }))
        learnOp(Op.UnaryOperation("%", { $0/100 }))
    }
    
    func pushOperand(operand: Double) -> Double?{
        opStack.append(Op.Operand(operand))
        return calculate()
    }
    
    func performOperation(symbol : String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return calculate()
    }
    
    private func calculate(ops :[Op]) -> (result: Double?, remainingOps: [Op]){
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .UnaryOperation(_, let operation):
                if let operand = calculate(remainingOps).result {
                    return (operation(operand),remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Calculation = calculate(remainingOps)
                if let operand1 = op1Calculation.result {
                    let op2Calculation = calculate(op1Calculation.remainingOps)
                    if let operand2  = op2Calculation.result {
                        return (operation(operand1,operand2),op2Calculation.remainingOps)
                    }
                }
            }
        }
        return (nil, ops)
    }
    
    private func formula(ops : [Op]) -> (equation: String?, remainingOps: [Op]) {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand.description, remainingOps)
            case .UnaryOperation(let operation, _) :
                let op1Formula = formula(remainingOps)
                if let operand = op1Formula.equation {
                    print("(\(operation)\(operand))")
                    return ("(\(operation)\(operand))", op1Formula.remainingOps)
                }
            case .BinaryOperation(let operation, _) :
                let op1Formula = formula(remainingOps)
                if let operand1 = op1Formula.equation {
                    let op2Formula = formula(op1Formula.remainingOps)
                    if let operand2 = op2Formula.equation {
                        return ("(\(operand2)\(operation)\(operand1))", op2Formula.remainingOps)
                    }
                }
            }
        }
        return (nil, ops)
    }
    
    func formula() -> String? {
        var (equation, _) = formula(opStack)
        equation = equation! + "=" + String(calculate()!)
        return equation
    }
    
    func calculate() -> Double?{
        let (result, remainder) = calculate(opStack)
        debugPrint(("\(opStack) = \(result) with \(remainder) left over"))
        return result
    }

    
}
