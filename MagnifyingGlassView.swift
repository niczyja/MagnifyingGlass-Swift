//
//  MagnifyingGlassView.swift
//  Line Replication
//
//  Created by Maciej Sienkiewicz on 17/05/2021.
//

import UIKit

class MagnifyingGlassView: UIView {

    static let defaultRadius: CGFloat = 40.0
    static let defaultOffset: CGFloat = 0.0
    static let defaultScale: CGFloat = 1.5
    
    weak var magnifiedView: UIView? = nil
    var touchPoint: CGPoint = CGPoint.zero
    
    var imageView: UIImageView = UIImageView()
    
    convenience init(view: UIView?) {
        self.init(frame: CGRect(x: 0.0, y: 0.0, width: MagnifyingGlassView.defaultRadius * 2, height: MagnifyingGlassView.defaultRadius * 2))
        magnifiedView = view
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 3.0
        layer.cornerRadius = frame.width / 2
        layer.masksToBounds = true
        layer.backgroundColor = UIColor.systemBackground.cgColor
        
        imageView.frame = bounds
        addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func magnify(at point: CGPoint) {
        guard magnifiedView != nil else { return }
        
        touchPoint = CGPoint(x: point.x, y: point.y + (magnifiedView?.safeAreaInsets.top ?? 0.0))
        center = point

        setNeedsDisplay()
        layer.setNeedsDisplay()
        layer.displayIfNeeded()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let renderer = UIGraphicsImageRenderer(size: bounds.size)
        
        let img = renderer.image { context in
            let ctx = context.cgContext

            // crosshair
            let crosshair = CAShapeLayer()
            crosshair.backgroundColor = UIColor.clear.cgColor
            crosshair.strokeColor = UIColor.darkGray.cgColor
            crosshair.lineWidth = 0.5
            crosshair.path = {
                let path = CGMutablePath()
                path.move(to: CGPoint(x: bounds.width * 0.5, y: 0.0))
                path.addLine(to: CGPoint(x: bounds.width * 0.5, y: bounds.height))
                path.move(to: CGPoint(x: 0.0, y: bounds.height * 0.5))
                path.addLine(to: CGPoint(x: bounds.width, y: bounds.height * 0.5))
                return path
            }()
            crosshair.render(in: ctx)
            
            // magnified view
            ctx.translateBy(x: 1 * (bounds.width * 0.5), y: 1 * (bounds.height * 0.5))
            ctx.scaleBy(x: 2.0, y: 2.0)
            ctx.translateBy(x: -1 * (touchPoint.x), y: -1 * (touchPoint.y))
            magnifiedView?.layer.render(in: ctx)

//            ctx.setStrokeColor(UIColor.black.cgColor)
//            ctx.setLineWidth(2.0)
//            let points: [CGPoint] = [
//                CGPoint(x: bounds.width * 0.5, y: 0.0),
//                CGPoint(x: bounds.width * 0.5, y: bounds.height),
//                CGPoint(x: 0.0, y: bounds.height * 0.5),
//                CGPoint(x: bounds.width, y: bounds.height * 0.5)
//            ]
//            ctx.strokeLineSegments(between: points)
            
//            ctx.move(to: CGPoint(x: bounds.width * 0.5, y: 0.0))
//            ctx.addLine(to: CGPoint(x: bounds.width * 0.5, y: bounds.height))
//
//            ctx.move(to: CGPoint(x: 0.0, y: bounds.height * 0.5))
//            ctx.addLine(to: CGPoint(x: bounds.width, y: bounds.height * 0.5))
            
        }
        
        imageView.image = img
        
        
//        if touchPoint != CGPoint.zero {
//            guard let ctx = UIGraphicsGetCurrentContext() else { return }
//
//            ctx.clear(rect)
//
//            ctx.translateBy(x: 1 * (frame.width * 0.5), y: 1 * (frame.height * 0.5))
//            ctx.scaleBy(x: 1.5, y: 1.5)
//            ctx.translateBy(x: -1 * (touchPoint.x), y: -1 * (touchPoint.y))
//
//            magnifiedView?.layer.render(in: ctx)
//        }
    }

}
