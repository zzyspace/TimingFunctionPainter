//
//  ZYPathPainter.swift
//  TimingFunctionPainter
//
//  Created by 张志延 on 16/10/13.
//
//

import UIKit

protocol ZYPathPainterProtocal: NSObjectProtocol {
    func controlPointUpdated(controlPoint1: CGPoint, controlPoint2: CGPoint)
}

class  ZYPathPainter: UIView {
    weak var delegate: ZYPathPainterProtocal?
    
    open var controlPoint1 = CGPoint(x: 0, y: 0) {
        didSet {
            ctrlPointView1.center = CGPoint(x: controlPoint1.x * scaleMultiple, y: controlPoint1.y * scaleMultiple)
            update()
        }
    }
    open var controlPoint2 = CGPoint(x: 0, y: 0) {
        didSet {
            ctrlPointView2.center = CGPoint(x: controlPoint2.x * scaleMultiple, y: controlPoint2.y * scaleMultiple)
            update()
        }
    }
    
    fileprivate var scaleMultiple: CGFloat = 300.0
    
    fileprivate let ctrlPointPathLayer1 = CAShapeLayer()
    fileprivate let ctrlPointPathLayer2 = CAShapeLayer()
    fileprivate let ctrlPointView1 = UIView()
    fileprivate let ctrlPointView2 = UIView()
    fileprivate let curveLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        assert(frame.width == frame.height, "This view must be a square")
        
        let defaultControlPoint1 = CGPoint(x: 0.5, y: 0.2)
        let defaultControlPoint2 = CGPoint(x: 0.5, y: 0.8)
        
        scaleMultiple = frame.width
        controlPoint1 = CGPoint(x: defaultControlPoint1.x, y: defaultControlPoint1.y)
        controlPoint2 = CGPoint(x: defaultControlPoint2.x, y: defaultControlPoint2.y)
    }
    
    fileprivate func commonInit() {
        
        backgroundColor = .white
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize.zero;
        layer.shadowRadius = 6;
        layer.shadowOpacity = 0.2;
        layer.isGeometryFlipped = true
        
        // Dash line layer
        ctrlPointPathLayer1.lineWidth = 2
        ctrlPointPathLayer1.lineDashPattern = [4.0, 4.0]
        ctrlPointPathLayer1.strokeColor = UIColor.darkGray.cgColor
        layer.addSublayer(ctrlPointPathLayer1)
        
        ctrlPointPathLayer2.lineWidth = 2
        ctrlPointPathLayer2.lineDashPattern = [4.0, 4.0]
        ctrlPointPathLayer2.strokeColor = UIColor.darkGray.cgColor
        layer.addSublayer(ctrlPointPathLayer2)
        
        // Curve Layer
        curveLayer.strokeColor = UIColor.red.cgColor
        curveLayer.fillColor = nil
        curveLayer.lineWidth = 4.0
        layer.addSublayer(curveLayer);
        
        // Control point
        ctrlPointView1.backgroundColor = .clear
        ctrlPointView1.frame.size = CGSize(width: scaleMultiple / 5, height: scaleMultiple / 5)
        ctrlPointView1.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(controlPointDidMove)))
        addSubview(ctrlPointView1)
        
        ctrlPointView2.backgroundColor = .clear
        ctrlPointView2.frame.size = CGSize(width: scaleMultiple / 5, height: scaleMultiple / 5)
        ctrlPointView2.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(controlPointDidMove)))
        addSubview(ctrlPointView2)
        
        let dot1 = UIView()
        dot1.frame.size = CGSize(width: 8.0, height: 8.0)
        dot1.backgroundColor = .black
        dot1.center = CGPoint(x: ctrlPointView1.frame.width / 2, y: ctrlPointView1.frame.height / 2)
        ctrlPointView1.addSubview(dot1)
        
        let dot2 = UIView()
        dot2.frame.size = CGSize(width: 8.0, height: 8.0)
        dot2.backgroundColor = .black
        dot2.center = CGPoint(x: ctrlPointView2.frame.width / 2, y: ctrlPointView2.frame.height / 2)
        ctrlPointView2.addSubview(dot2)
    }
    
    func controlPointDidMove(pan: UIPanGestureRecognizer) {
        let translation = pan.translation(in: pan.view)
        pan.view?.center.x += translation.x
        pan.view?.center.y += translation.y
        pan.setTranslation(.zero, in: pan.view)
        
        controlPoint1 = ctrlPointView1.center.applying(CGAffineTransform(scaleX: 1 / scaleMultiple, y: 1 / scaleMultiple))
        controlPoint2 = ctrlPointView2.center.applying(CGAffineTransform(scaleX: 1 / scaleMultiple, y: 1 / scaleMultiple))
        
        update()
    }
    
    fileprivate func update() {
        delegate?.controlPointUpdated(controlPoint1: controlPoint1, controlPoint2: controlPoint2)
        
        // Dash line path
        let ctrlPointPath1 = UIBezierPath()
        ctrlPointPath1.move(to: .zero)
        ctrlPointPath1.addLine(to: ctrlPointView1.center)
        ctrlPointPathLayer1.path = ctrlPointPath1.cgPath
        
        let ctrlPointPath2 = UIBezierPath()
        ctrlPointPath2.move(to: CGPoint(x: 1.0 * scaleMultiple, y: 1.0 * scaleMultiple))
        ctrlPointPath2.addLine(to: ctrlPointView2.center)
        ctrlPointPathLayer2.path = ctrlPointPath2.cgPath
        
        // Curve line path
        let path = UIBezierPath()
        path.move(to: .zero)
        path.addCurve(to: CGPoint(x: 1, y:1), controlPoint1: controlPoint1, controlPoint2: controlPoint2)
        path.apply(CGAffineTransform(scaleX: scaleMultiple, y: scaleMultiple))
        curveLayer.path = path.cgPath
    }
}
