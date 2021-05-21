//
//  MagnifyingGlassView.swift
//  MagnifyingGlassTest
//
//  Created by Maciej Sienkiewicz on 21/05/2021.
//

import UIKit

/// Provides magnifying glass effect for given view
public class MagnifyingGlassView: UIView {

    /// A view that will be magnified
    ///
    /// Set to nil to hide magnification glass
    ///
    public weak var magnifiedView: UIView? = nil {
        didSet {
            removeFromSuperview()
            magnifiedView?.addSubview(self)
        }
    }

    /// Location of magnification in `magnifiedView` coordinate system
    public var magnifiedPoint: CGPoint = CGPoint.zero {
        didSet {
            center = CGPoint(x: magnifiedPoint.x + offset.x, y: magnifiedPoint.y + offset.y)
        }
    }

    /// Offset by which magnification glass will be shifted from `magnifiedPoint`
    public var offset: CGPoint = CGPoint.zero

    /// Radius of magnification glass view
    public var radius: CGFloat = 50.0 {
        didSet {
            frame = CGRect(origin: frame.origin, size: CGSize(width: radius * 2, height: radius * 2))
            layer.cornerRadius = radius
            crosshair.path = crosshairPath(for: radius)
        }
    }
    
    /// Scale of magnification
    public var scale: CGFloat = 2.0
    
    /// Border color of magnification glass
    public var borderColor: UIColor = UIColor.lightGray {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    /// Border width of magnification glass
    public var borderWidth: CGFloat = 3.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    /// A Boolean indicating whether magnification glass shows crosshair
    public var showsCrosshair: Bool = true {
        didSet {
            crosshair.isHidden = !showsCrosshair
        }
    }
    
    /// Crosshair color
    public var crosshairColor: UIColor = UIColor.lightGray {
        didSet {
            crosshair.strokeColor = crosshairColor.cgColor
        }
    }
    
    /// Crosshair width
    public var crosshairWidth: CGFloat = 0.5 {
        didSet {
            crosshair.lineWidth = crosshairWidth
        }
    }
    
    /// Layer that draws crosshair
    private let crosshair: CAShapeLayer = CAShapeLayer()
    
    /// Initializes new magnification glass view according to given parameters
    ///
    /// - Parameters:
    ///     - offset: Offset by which magnification glass will be shifted from `magnifiedPoint`
    ///     - radius: Radius of magnification glass view
    ///     - scale: Scale of magnification
    ///     - borderColor: Border color of magnification glass
    ///     - borderWidth: Border width of magnification glass
    ///     - showsCrosshair: A Boolean indicating whether magnification glass shows crosshair
    ///     - crosshairColor: Crosshair color
    ///     - crosshairWidth: Crosshair width
    ///
    /// - Returns: New magnification glass view
    ///
    /// All arguments have default values so you can use only ones that you need.
    /// You can also directly access any of these parameters at any time of the view lifecycle.
    ///
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
    
    /// Moves magnification glass to given location and refreshes its contents
    ///
    /// - Parameter point: Location of magnification in `magnifiedView` view coordinate system
    ///
    /// Use this method every time you need to refresh magnification glass position
    /// - Precondition: Set `magnifiedView` to non nil value for this method to take effect
    ///
    public func magnify(at point: CGPoint) {
        guard magnifiedView != nil else { return }

        magnifiedPoint = point
        layer.setNeedsDisplay()
    }
    
    /// Creates crosshair path for given radius
    private func crosshairPath(for radius: CGFloat) -> CGPath {
        let path = CGMutablePath()
        path.move(to: CGPoint(x: radius, y: 0.0))
        path.addLine(to: CGPoint(x: radius, y: bounds.height))
        path.move(to: CGPoint(x: 0.0, y: radius))
        path.addLine(to: CGPoint(x: bounds.width, y: radius))
        return path
    }

    /// Renders magnification glass
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
