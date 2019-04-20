//
//  CGMutablePath+pit.swift
//  LimberTabbar
//
//  Created by Afshin Hoseini on 4/7/19.
//  Copyright © 2019 Afshin Hoseini. All rights reserved.
//

import Foundation
import UIKit

extension CGMutablePath {
    
    class func calculatePitWith(maxPitDepth: CGFloat) -> CGFloat {
        
        return maxPitDepth * 2.25
    }
    
    /**
     Draws the pit's path from given starting point.
     
     In order to simplify the code, the scale parameter has been used once for the middle rect's height calculation. The other discussed parameters have bound to middle rect's height.
     
     **Returns** a tuple including guide rects and the end point.
     */
    @discardableResult
    public func addPit(toPath path: CGMutablePath, startingPointX : CGFloat, y: CGFloat, depth: CGFloat = 40, scale: CGFloat = 1) -> (guideRects: [CGRect], endPoint : CGPoint) {
        
        let pitWidth = CGMutablePath.calculatePitWith(maxPitDepth: depth) // Including the pit's domains
        let endPoint = CGPoint(x: startingPointX + pitWidth, y: y)
        
        let centerRectWidth = depth
        let centerRectHeight = depth * scale
        let smallRectsWidth = centerRectWidth / 2
        let smallRectsHeight = centerRectHeight / 2
        let pitCenterBottomPoint = CGPoint(x: startingPointX + (pitWidth / 2), y: centerRectHeight)
        
        
        let leftRect = CGRect(x: startingPointX, y: y, width: smallRectsWidth, height: smallRectsHeight)
        let centerRect = CGRect(x: leftRect.origin.x + leftRect.width, y: y, width: centerRectWidth, height: centerRectHeight)
        let rightRect = CGRect(x: centerRect.origin.x + centerRect.width, y: y, width: smallRectsWidth, height: smallRectsHeight)
        
        
        //Curves' control points calculations.
        //Right Curve's Top Control Point
        let RCTCP = CGPoint(x: endPoint.x - (abs(rightRect.height) * 1.25), y: y)
        //Right Curve's Bottom Control Point
        let RCBCP = CGPoint(x: pitCenterBottomPoint.x + abs(centerRectHeight), y: centerRectHeight)
        //Left Curve's Top Control Point
        let LCTCP = CGPoint(x: startingPointX + (abs(leftRect.height) * 1.25), y: y)
        //Left Curve's Bottom Control Point
        let LCBCP = CGPoint(x: pitCenterBottomPoint.x - abs(centerRectHeight), y: centerRectHeight)
        
        
        
        //Addes curves to the given path.
        
        path.addCurve(to: pitCenterBottomPoint, control1: LCTCP, control2: LCBCP)
        path.addCurve(to: endPoint, control1: RCBCP, control2: RCTCP)
        
        return([leftRect, centerRect, rightRect], endPoint)
    }
}
