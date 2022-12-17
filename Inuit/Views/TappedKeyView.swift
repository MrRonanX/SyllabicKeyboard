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
        
        path.fill()
        path.lineWidth = 1
        path.stroke()
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

final class LongTapPopUp: UIView {

    var direction: Direction
    var popUpColor: UIColor
    var originalButtonWidth: CGFloat
    var selectedCharacter = ""
    let stackView = UIStackView()

    init(direction: Direction, color: UIColor, originalWidth: CGFloat) {
        self.direction = direction
        self.popUpColor = color
        self.originalButtonWidth = originalWidth
        super.init(frame: .zero)
        backgroundColor = .clear
        setupStackView()
        self.tag = 9999
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        let path = direction.drawShape(in: rect)
        popUpColor.set()
        UIColor.systemWhite.setStroke()
        path.fill()
        path.lineWidth = 1
        path.stroke()
    }

    enum Direction {
        case left
        case right

        func drawShape(in rect: CGRect) -> UIBezierPath {
            return self == .right ? drawToRight(in: rect) : drawToLeft(in: rect)
        }

        private func drawToRight(in rect: CGRect) -> UIBezierPath {
            let rowSpacer = rect.height / 11
            let sideExpansion = rect.width / 6
            let upperRadius = (rect.width / 12) + 4
            let upperWidth = rect.width - 2 * upperRadius
            let bottomWidth = rect.width / 2 - 2 * upperRadius

            let sideRadius = rect.height / 14

            let curveTopPoint = (rect.height / 2) - rowSpacer / 2
            let curveBottomPoint = (rect.height / 2) + rowSpacer
            let controlHeight = rect.midY

            let path = UIBezierPath()
            var point = rect.origin
            var control1 = CGPoint.zero
            var control2 = CGPoint.zero

            // Top Left Corner
            point.x = upperRadius
            path.move(to: point)

            // Top Right Corner
            point.x = upperWidth + upperRadius
            path.addLine(to: point)

            // Top Right Arch
            point.y += upperRadius
            path.addArc(withCenter: point, radius: upperRadius, startAngle: 3.0 * .pi / 2.0, endAngle: 4.0 * .pi / 2.0, clockwise: true)

            // Middle Right Side
            point.x = rect.maxX
            point.y = controlHeight - upperRadius / 2
            path.addLine(to: point)

            point.x = rect.maxX - upperRadius
            path.addArc(withCenter: point, radius: upperRadius, startAngle: 2.0 * .pi, endAngle: .pi / 2.0, clockwise: true)

            // Middle To Bottom
            point.x = rect.maxX / 2 + upperRadius / 2
            point.y = controlHeight + upperRadius  / 2
            path.addLine(to: point)

            point.y = point.y + sideRadius
            path.addArc(withCenter: point, radius: sideRadius, startAngle: 3.0 * .pi / 2.0, endAngle: .pi, clockwise: false)

            // Bottom Right Corner
            point.x = point.x - sideRadius
            point.y = rect.maxY - upperRadius
            path.addLine(to: point)

            point.x = point.x - upperRadius
            path.addArc(withCenter: point, radius: upperRadius, startAngle: 2.0 * .pi, endAngle: .pi / 2.0, clockwise: true)

            // Bottom Left Corner
            point.x = rect.minX + sideExpansion + upperRadius
            point.y = rect.maxY - upperRadius
            path.addArc(withCenter: point, radius: upperRadius, startAngle: 1.0 * .pi / 2.0, endAngle: 2.0 * .pi / 2.0, clockwise: true)

            // Bottom Middle Line
            point.y = curveBottomPoint
            point.x = rect.minX + sideExpansion
            path.addLine(to: point)

            // Bottom Middle Curve
            control1 = CGPoint(x: sideExpansion, y: controlHeight)
            control2 = CGPoint(x: rect.minX, y: controlHeight)

            point.x = rect.minX
            point.y = curveTopPoint
            path.addCurve(to: point, controlPoint1: control1, controlPoint2: control2)

            // Middle Left corner
            point.y = upperRadius
            path.addLine(to: point)

            point.x = upperRadius
            path.addArc(withCenter: point, radius: upperRadius, startAngle: 2.0 * .pi / 2.0, endAngle: 3.0 * .pi / 2.0, clockwise: true)

            path.close()

            return path
        }

        private func drawToLeft(in rect: CGRect) -> UIBezierPath {
            let rowSpacer = rect.height / 11
            let sideExpansion = rect.width / 6
            let upperRadius = (rect.width / 12) + 4
            let upperWidth = rect.width - 2 * upperRadius
            let bottomWidth = rect.width / 2 - 2 * upperRadius

            let sideRadius = rect.height / 14

            let curveTopPoint = (rect.height / 2) - rowSpacer / 2
            let curveBottomPoint = (rect.height / 2) + rowSpacer
            let controlHeight = rect.midY

            let path = UIBezierPath()
            var point = rect.origin
            var control1 = CGPoint.zero
            var control2 = CGPoint.zero

            // Top Left Corner
            point.x = upperRadius
            path.move(to: point)

            // Top Right Corner
            point.x = upperWidth + upperRadius
            path.addLine(to: point)

            // Top Right Arch
            point.y += upperRadius
            path.addArc(withCenter: point, radius: upperRadius, startAngle: 3.0 * .pi / 2.0, endAngle: 4.0 * .pi / 2.0, clockwise: true)

            // Middle Right Side
            point.x = rect.maxX
            point.y = curveTopPoint
            path.addLine(to: point)

            // Middle Right Curve
            control1 = CGPoint(x: rect.maxX, y: controlHeight)
            control2 = CGPoint(x: rect.maxX - sideExpansion, y: controlHeight)

            point.x = rect.width - sideExpansion
            point.y = curveBottomPoint
            path.addCurve(to: point, controlPoint1: control1, controlPoint2: control2)

            // Middle To Bottom
            point.y = rect.maxY - upperRadius
            path.addLine(to: point)

            // Bottom Right Arc
            point.x = rect.maxX - sideExpansion - upperRadius
            path.addArc(withCenter: point, radius: upperRadius, startAngle: 4.0 * .pi / 2.0, endAngle: 1.0 * .pi / 2.0, clockwise: true)

            // Bottom Left Arch
            point.x = rect.maxX - bottomWidth - sideRadius * 2
            point.y = rect.maxY - upperRadius

            path.addArc(withCenter: point, radius: upperRadius, startAngle: 1.0 * .pi / 2.0, endAngle: 2.0 * .pi / 2.0, clockwise: true)

            // Bottom to Middle Left
            point.x = point.x - upperRadius
            point.y = controlHeight + upperRadius + upperRadius / 2
            path.addLine(to: point)

            // Middle Left Corner
            point.x = point.x - upperRadius
            path.addArc(withCenter: point, radius: upperRadius, startAngle: 2.0 * .pi, endAngle: 3.0 * .pi / 2.0, clockwise: false)

            // Middle Left to Left Side
            point.x = rect.minX + upperRadius
            point.y = point.y - upperRadius
            path.addLine(to: point)

            // Left Corner
            point.y = point.y - upperRadius
            path.addArc(withCenter: point, radius: upperRadius, startAngle: .pi / 2.0, endAngle: .pi, clockwise: true)

            // Left Corner to Left Top
            point.x = rect.minX
            point.y = rect.minY + upperRadius
            path.addLine(to: point)

            // Left Top Corner
            point.x = rect.minX + upperRadius
            point.x = rect.minX + upperRadius
            path.addArc(withCenter: point, radius: upperRadius, startAngle: .pi, endAngle: 3.0 * .pi / 2.0, clockwise: true)

            path.close()

            return path
        }
    }

    var largerFrame: CGRect {
        CGRect(
            x: frame.minX - 15,
            y: frame.minY - 50,
            width: frame.width + 30,
            height: frame.height + 100
        )
    }

    private func setupStackView() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.spacing = 10

        let heightMultiplier = DeviceTypes.olderIphone ? 0.3571 : 0.3846

        for number in 0...1 {
            let label = UILabel()
            label.textAlignment = .center
            label.text = String(number)
            label.textColor = .white
            label.font = .systemFont(ofSize: 20)
            label.tag = number
            label.layer.cornerRadius = 8
            label.layer.masksToBounds = true
            stackView.addArrangedSubview(label)
        }

        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            stackView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: heightMultiplier)
        ])
    }

    func handleSelection(for gesture: UILongPressGestureRecognizer) {
        let location = gesture.location(in: self)
        let tag = location.x > bounds.midX ? 1 : 0
        selectLabel(with: tag)
    }

    func selectLabel(with tag: Int) {
        stackView.arrangedSubviews.forEach { $0.backgroundColor = .clear }
        let view = stackView.arrangedSubviews.first(where: {$0.tag == tag}) as? UILabel
        view?.backgroundColor = .systemBlue
        guard let view, let text = view.text else { return }
        selectedCharacter = text
    }
}
