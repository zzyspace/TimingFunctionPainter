//
//  ViewController.swift
//  TimingFunctionPainter
//
//  Created by 张志延 on 16/10/13.
//
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var curvePainter: ZYPathPainter!
    @IBOutlet weak var point1xField: UITextField!
    @IBOutlet weak var point1yField: UITextField!
    @IBOutlet weak var point2xField: UITextField!
    @IBOutlet weak var point2yField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        curvePainter.delegate = self
        point1xField.delegate = self
        point1yField.delegate = self
        point2xField.delegate = self
        point2yField.delegate = self
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

extension ViewController: ZYPathPainterProtocal {
    func controlPointUpdated(controlPoint1: CGPoint, controlPoint2: CGPoint) {
        point1xField.text = String(format: "%.2f", controlPoint1.x)
        point1yField.text = String(format: "%.2f", controlPoint1.y)
        point2xField.text = String(format: "%.2f", controlPoint2.x)
        point2yField.text = String(format: "%.2f", controlPoint2.y)
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        finishInput(textField: textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        finishInput(textField: textField)
        return true
    }
    
    func finishInput(textField: UITextField) {
        textField.endEditing(true)
        if let text = textField.text {
            if let value = Double(text) {
                switch textField {
                case point1xField:
                    curvePainter.controlPoint1 = CGPoint(x: CGFloat(value), y: curvePainter.controlPoint1.y)
                case point1yField:
                    curvePainter.controlPoint1 = CGPoint(x: curvePainter.controlPoint1.x, y: CGFloat(value))
                case point2xField:
                    curvePainter.controlPoint2 = CGPoint(x: CGFloat(value), y: curvePainter.controlPoint2.y)
                case point2yField:
                    curvePainter.controlPoint2 = CGPoint(x: curvePainter.controlPoint2.x, y: CGFloat(value))
                default:
                    break
                }
            }
        }
    }
}

