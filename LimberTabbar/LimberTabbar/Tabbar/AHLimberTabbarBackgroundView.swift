//
//  AHLimberTabbarBackgroundView.swift
//  LimberTabbar
//
//  Created by Afshin Hoseini on 4/20/19.
//  Copyright © 2019 Afshin Hoseini. All rights reserved.
//

import Foundation
import UIKit

/**
 Shows the pit like background and responsible to animated the pit around the selected tab.
 */
class AHLimberTabbarBackgroundView : UIView {
    
    var defaultBackgroundColor = UIColor.white
    var borderLayer = CAShapeLayer()
    var pitDepth = CGFloat(40)
    
    convenience init(parent: UIView) {
        
        self.init(frame: parent.bounds)
        
        
        parent.addSubview(self)
        
        if #available(iOS 9.0, *) {
            translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                
                topAnchor.constraint(equalTo: parent.topAnchor),
                leadingAnchor.constraint(equalTo: parent.leadingAnchor),
                trailingAnchor.constraint(equalTo: parent.trailingAnchor),
                bottomAnchor.constraint(equalTo: parent.bottomAnchor)
                ])
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    public override init(frame: CGRect) {
        
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
        
        addLayers()
    }
    
    /**
     Adds and configure the layer which contains the pit-like path.
    */
    func addLayers() {
        
        //Initializes border and guide rects layers
        
        borderLayer.bounds = bounds
        borderLayer.fillColor = self.defaultBackgroundColor.cgColor
        borderLayer.position = CGPoint(x: 0, y: 0)
        borderLayer.anchorPoint = CGPoint(x: 0, y: 0)
        borderLayer.lineJoin = .round
        
        borderLayer.shadowColor = UIColor.black.cgColor
        borderLayer.shadowOffset = CGSize(width: 0, height: -2)
        borderLayer.shadowRadius = 1
        borderLayer.shadowOpacity = 0.3
        
        layer.addSublayer(borderLayer)
    }
    
    /**
     * Renders the border of view including the hole
     */
    func renderBorder(pitCenterX : CGFloat) {
        
        borderLayer.path = getBorderPath(for: pitCenterX, depthScale: 1)
    }
    
    /**
     Creates the pit-like path according to the given pit center x point and depth scale.
    */
    func getBorderPath(for pitCenterX: CGFloat, depthScale: CGFloat) -> CGMutablePath {
        
        //Initial calculations
        let pitWidth = CGMutablePath.calculatePitWith(maxPitDepth: pitDepth)
        let y = CGFloat(0)
        let holeStartingPointX = pitCenterX - (pitWidth/2)
        
        //Creates the hole
        let borderPath = CGMutablePath()
        borderPath.move(to: CGPoint.zero)
        borderPath.addLine(to: CGPoint(x: holeStartingPointX, y: y))
        
        borderPath.addPit(toPath: borderPath, startingPointX: holeStartingPointX, y: y, depth: pitDepth, scale: depthScale)
        
        borderPath.addLine(to: CGPoint(x: bounds.width, y: 0))
        borderPath.addLine(to: CGPoint(x: bounds.width, y: bounds.height))
        borderPath.addLine(to: CGPoint(x: 0, y: bounds.height))
        borderPath.addLine(to: CGPoint(x: 0, y: 0))
        
        return borderPath
    }
    
    /**
     Animates background color.
    */
    func animateColor(to: UIColor) {
        
        UIView.animate(withDuration: AnimationConfig.duration) {
            
            self.borderLayer.fillColor = to.cgColor
        }
    }
    
    /**
     Moves and animates the pit-like thing to given centerX.
    */
    func animatePit(fromCenterX: CGFloat, toCenterX : CGFloat) {
        
        let distance = (toCenterX-fromCenterX)
        let maxDistance = bounds.width
        let minDepthShrinking = CGFloat(0.6)
        let maxDepthShrinking = CGFloat(0.8)
        
        let distanceRatio = abs(distance) / maxDistance
        let depthShrinking = maxDepthShrinking - ((maxDepthShrinking - minDepthShrinking) * distanceRatio)
        
        let anim = CAKeyframeAnimation(keyPath: #keyPath(CAShapeLayer.path))
        anim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        anim.values = [
            getBorderPath(for: fromCenterX, depthScale:1),
            getBorderPath(for: fromCenterX + distance/2, depthScale:depthShrinking),
            getBorderPath(for: toCenterX, depthScale:1)
        ]
        anim.keyTimes = [0,0.5,1]
        anim.duration = AnimationConfig.duration
        anim.isRemovedOnCompletion = false
        anim.fillMode = .both
        
        borderLayer.add(anim, forKey: #keyPath(CAShapeLayer.path))
    }
}
