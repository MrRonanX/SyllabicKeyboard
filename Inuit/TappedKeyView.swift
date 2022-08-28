//
//  KeyPopUp.swift
//  Inuit
//
//  Created by Roman Kavinskyi on 8/28/22.
//

import UIKit

final class KeyPopUp: UIView {
    
    var popUpColor: UIColor
    
    let label = UILabel()
    
    private lazy var keyLayer = CALayer()
    
    init(frame: CGRect, color: UIColor) {
        popUpColor = color
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        setLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
//        let context = UIGraphicsGetCurrentContext()
//
//        let shadow = UIColor.black
//        let shadowOffset = CGSize(width: 0, height: 0)
//        let shadowBlurRadius: CGFloat = 2

        let rowSpacer = rect.height / 11
        let sideExpansion = rect.width / 4.6
        let upperRadius = (rect.width / 8) + 4
        let upperWidth = rect.width - 2 * upperRadius
        
        let curveTopPoint = (rect.height / 2) - rowSpacer
        let curveBottomPoint = (rect.height / 2) + rowSpacer
        let controlHeight = rect.midY 
        
        let path = UIBezierPath()
        var point = rect.origin
        var control1 = CGPoint.zero
        var control2 = CGPoint.zero
        
        point.x = upperRadius
        path.move(to: point)
        
        point.x = upperWidth + upperRadius
        path.addLine(to: point)
        
        point.y += upperRadius
        path.addArc(withCenter: point, radius: upperRadius, startAngle: 3.0 * .pi / 2.0, endAngle: 4.0 * .pi / 2.0, clockwise: true)
        
        point.x = rect.maxX
        point.y = curveTopPoint
        path.addLine(to: point)
        
        control1 = CGPoint(x: rect.maxX, y: controlHeight)
        control2 = CGPoint(x: rect.maxX - sideExpansion, y: controlHeight)
        
        point.x = rect.width - sideExpansion
        point.y = curveBottomPoint
        path.addCurve(to: point, controlPoint1: control1, controlPoint2: control2)
        
        point.y = rect.maxY - upperRadius
        path.addLine(to: point)
        
        point.x = rect.maxX - sideExpansion - upperRadius
        path.addArc(withCenter: point, radius: upperRadius, startAngle: 4.0 * .pi / 2.0, endAngle: 1.0 * .pi / 2.0, clockwise: true)
        
        point.x = rect.minX + sideExpansion + upperRadius
        point.y = rect.maxY - upperRadius
        path.addArc(withCenter: point, radius: upperRadius, startAngle: 1.0 * .pi / 2.0, endAngle: 2.0 * .pi / 2.0, clockwise: true)
        
        point.y = curveBottomPoint
        point.x = rect.minX + sideExpansion
        path.addLine(to: point)
        
        control1 = CGPoint(x: sideExpansion, y: controlHeight)
        control2 = CGPoint(x: rect.minX, y: controlHeight)
        
        point.x = rect.minX
        point.y = curveTopPoint
        path.addCurve(to: point, controlPoint1: control1, controlPoint2: control2)
        
        point.y = upperRadius
        path.addLine(to: point)
        
        point.x = upperRadius
        path.addArc(withCenter: point, radius: upperRadius, startAngle: 2.0 * .pi / 2.0, endAngle: 3.0 * .pi / 2.0, clockwise: true)
        
        path.close()
        
        popUpColor.set()
        UIColor.systemWhite.setStroke()
        
//        context?.saveGState()
//
//        context?.setShadow(offset: shadowOffset, blur: shadowBlurRadius,  color: (shadow as UIColor).cgColor)
        
        path.fill()
        path.lineWidth = 1
        path.stroke()
        
        
//        context?.restoreGState()
        
        
    }
    
    private func setLabel() {
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        label.textAlignment = .center
        bringSubviewToFront(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    private func setupLayer() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = .zero
        layer.shadowRadius = 10
        
        layer.addSublayer(keyLayer)
    }
}
