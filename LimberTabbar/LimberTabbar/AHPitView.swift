//
//  UIPitView.swift
//  LimberTabbar
//
//  Created by Afshin Hoseini on 4/7/19.
//  Copyright © 2019 Afshin Hoseini. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
public class AHPitView : UIView {
    
    //MARK:- Properties
    var borderLayer = CAShapeLayer()
    var guideRectsLayer = CAShapeLayer()
    let pitDepth = CGFloat(40)
    let maxDepth = CGFloat(40)
    
    @IBInspectable
    public var pitPositionScale = CGFloat(0) {
        
        didSet {
            
            renderBorder()
        }
    }
    
    @IBInspectable
    public var pitDepthScale = CGFloat(0) {
        
        didSet {
            
            renderBorder()
        }
    }
    
    @IBInspectable
    public var showRects = true {
        
        didSet {
            renderBorder()
        }
    }
    
    //MARK:- Initializers
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        
        //Initializes border and guide rects layers
        
        borderLayer.bounds = bounds
        borderLayer.fillColor = UIColor.red.cgColor
        borderLayer.strokeColor = UIColor.red.cgColor
        borderLayer.position = CGPoint(x: 0, y: 0)
        borderLayer.anchorPoint = CGPoint(x: 0, y: 0)
        borderLayer.lineJoin = .round
        
        borderLayer.shadowColor = UIColor.black.cgColor
        borderLayer.shadowOffset = CGSize(width: 0, height: -2)
        borderLayer.shadowRadius = 1
        borderLayer.shadowOpacity = 0.3
        
        
        guideRectsLayer.fillColor = nil
        guideRectsLayer.strokeColor = UIColor.cyan.cgColor
        guideRectsLayer.position = CGPoint(x: 0, y: 0)
        guideRectsLayer.bounds = bounds
        guideRectsLayer.anchorPoint = CGPoint(x: 0, y: 0)
        
        layer.addSublayer(borderLayer)
        layer.addSublayer(guideRectsLayer)
        
        renderBorder()
        self.backgroundColor = nil
    }
    
    //MARK:- Functions
    public override func prepareForInterfaceBuilder() {
        
        pitPositionScale = CGFloat(0.5)
        pitDepthScale = CGFloat(1)
    }
    
    /**
     * Renders the border of view including the hole
     */
    func renderBorder() {
        
        //Initial calculations
        let pitWidth = CGMutablePath.calculatePitWith(maxPitDepth: pitDepth)
        let y = CGFloat(0)
        let possibleDiggingWidth = bounds.width - pitWidth
        let holeStartingPointX = CGFloat(possibleDiggingWidth * pitPositionScale)
        
        //Creates the hole
        let borderPath = CGMutablePath()
        borderPath.move(to: CGPoint.zero)
        borderPath.addLine(to: CGPoint(x: holeStartingPointX, y: y))
        
        let guideRects = borderPath.addPit(toPath: borderPath, startingPointX: holeStartingPointX, y: y, depth: pitDepth, scale: pitDepthScale).guideRects
        
        borderPath.addLine(to: CGPoint(x: bounds.width, y: 0))
        borderPath.addLine(to: CGPoint(x: bounds.width, y: bounds.height))
        borderPath.addLine(to: CGPoint(x: 0, y: bounds.height))
        borderPath.addLine(to: CGPoint(x: 0, y: 0))
        
        borderLayer.path = borderPath
        
        //Rects layer
        
        if (showRects) {
            
            let rectPath = CGMutablePath()
            rectPath.addRects(guideRects)
            guideRectsLayer.path = rectPath
        }
        else {
            guideRectsLayer.path = nil
        }
        
    }
}
