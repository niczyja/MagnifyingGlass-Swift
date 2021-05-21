//
//  MagnifyingGlassView.swift
//  MagnifyingGlassTest
//
//  Created by Maciej Sienkiewicz on 21/05/2021.
//

import UIKit

public class MagnifyingGlassView: UIView {

    public weak var magnifiedView: UIView? = nil {
        didSet {
            removeFromSuperview()
            magnifiedView?.addSubview(self)
        }
    }

    public var magnifiedPoint: CGPoint = CGPoint.zero {
        didSet {
            center = CGPoint(x: magnifiedPoint.x + offset.x, y: magnifiedPoint.y + offset.y)
        }
    }

    public var offset: CGPoint = CGPoint.zero

    public var radius: CGFloat = 50.0 {
        didSet {
            frame = CGRect(origin: frame.origin, size: CGSize(width: radius * 2, height: radius * 2))
            layer.cornerRadius = radius
            crosshair.path = crosshairPath(for: radius)
        }
    }
    
    public var scale: CGFloat = 2.0
    
    public var borderColor: UIColor = UIColor.lightGray {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    public var borderWidth: CGFloat = 3.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    public var showsCrosshair: Bool = true {
        didSet {
            crosshair.isHidden = !showsCrosshair
        }
    }
    
    public var crosshairColor: UIColor = UIColor.lightGray {
        didSet {
            crosshair.strokeColor = crosshairColor.cgColor
        }
    }
    
    public var crosshairWidth: CGFloat = 0.5 {
        didSet {
            crosshair.lineWidth = crosshairWidth
        }
    }
    
    private let crosshair: CAShapeLayer = CAShapeLayer()
    
    public convenience init(offset: CGPoint = CGPoint.zero,
                            radius: CGFloat = 50.0,
                            scale: CGFloat = 2.0,
                            borderColor: UIColor = UIColor.lightGray,
                            borderWidth: CGFloat = 3.0,
                            showsCrosshair: Bool = true,
                            crosshairColor: UIColor = UIColor.lightGray,
                            crosshairWidth: CGFloat = 0.5) {
        self.init(frame: CGRect.zero)

        layer.masksToBounds = true
        layer.addSublayer(crosshair)

        defer {
            self.offset = offset
            self.radius = radius
            self.scale = scale
            self.borderColor = borderColor
            self.borderWidth = borderWidth
            self.showsCrosshair = showsCrosshair
            self.crosshairColor = crosshairColor
            self.crosshairWidth = crosshairWidth
        }
    }
    
    public func magnify(at point: CGPoint) {
        guard magnifiedView != nil else { return }

        magnifiedPoint = point
        layer.setNeedsDisplay()
    }
    
    private func crosshairPath(for radius: CGFloat) -> CGPath {
        let path = CGMutablePath()
        path.move(to: CGPoint(x: radius, y: 0.0))
        path.addLine(to: CGPoint(x: radius, y: bounds.height))
        path.move(to: CGPoint(x: 0.0, y: radius))
        path.addLine(to: CGPoint(x: bounds.width, y: radius))
        return path
    }

    public override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }

        context.translateBy(x: radius, y: radius)
        context.scaleBy(x: scale, y: scale)
        context.translateBy(x: -magnifiedPoint.x, y: -magnifiedPoint.y)

        removeFromSuperview()
        magnifiedView?.layer.render(in: context)
        magnifiedView?.addSubview(self)
    }

}
