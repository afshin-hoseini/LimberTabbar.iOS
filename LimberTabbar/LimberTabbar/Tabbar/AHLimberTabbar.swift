//
//  AHLimberTabbar.swift
//  LimberTabbar
//
//  Created by Afshin Hoseini on 4/7/19.
//  Copyright © 2019 Afshin Hoseini. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
public class AHLimberTabbar : UITabBar {
    
    var _items: [UITabBarItem]?
    override public var items: [UITabBarItem]? {
        
        set {self._items = newValue}
        get {return self._items}
    }
    
    var borderLayer = CAShapeLayer()
    let pitDepth = CGFloat(40)
    let maxDepth = CGFloat(40)
    var tabs = [AHLimberTabBarItemView]()
    var selectedTabHolder : AHSelectedTabItem!
    var selectedTab : AHLimberTabBarItemView? {
        
        didSet {
            
            self.select(tab: selectedTab!)
        }
    }
    
    public var pitDepthScale = CGFloat(1) { didSet { renderBorder(pitCenterX: selectedTab?.center.x ?? 0) } }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    public override init(frame: CGRect) {
        
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
        
        
        self.selectedTabHolder = AHSelectedTabItem(size: 40)
        addSubview(selectedTabHolder)
        
        self.backgroundImage = UIImage()
        self.shadowImage = UIImage()
        addLayers()
        
        
        
        self.selectedTab = self.tabs[0]
    }
    
    public override func setItems(_ items: [UITabBarItem]?, animated: Bool) {
        
        self.items = items
        layoutItems()
    }
    
    func layoutItems() {
        
        let itemHeight = bounds.height
        let itemWidth = bounds.width / CGFloat(items?.count ?? 1)
        var x = CGFloat(0)
        
        items?.forEach({ (item) in
            
            let itemView = AHLimberTabBarItemView(tabBarItem: item)
            itemView.onSelected = self.select
            addSubview(itemView)
            
            itemView.frame = CGRect(x: x, y: 0, width: itemWidth, height: itemHeight)
            x += itemWidth
            tabs.append(itemView)
        })
    }
    
    func addLayers() {
        
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
        
        layer.insertSublayer(borderLayer, at: 0)
        
        self.backgroundColor = nil
    }
    
    /**
     * Renders the border of view including the hole
     */
    func renderBorder(pitCenterX : CGFloat) {
        
        borderLayer.path = getBorderPath(for: pitCenterX, depthScale: 1)
    }
    
    func getBorderPath(for pitCenterX: CGFloat, depthScale: CGFloat) -> CGMutablePath {
        
        //Initial calculations
        let pitWidth = pitDepth * 2
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
    
    
    func select(tab: AHLimberTabBarItemView) {
        
        selectedTabHolder.currentTab?.show()
        tab.hide()
        
        animatePit(fromCenterX: (selectedTabHolder.currentTab ?? tabs[0]).center.x, toCenterX: tab.center.x)
        
        //renderBorder(pitCenterX: tab.center.x)
        selectedTabHolder.currentTab = tab
    }
    
    
    func animatePit(fromCenterX: CGFloat, toCenterX : CGFloat) {
        
        
        let anim = CAKeyframeAnimation(keyPath: #keyPath(CAShapeLayer.path))
        anim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        anim.values = [
                        getBorderPath(for: fromCenterX, depthScale:1),
                        getBorderPath(for: fromCenterX + (toCenterX-fromCenterX)/2, depthScale:0.8),
                        getBorderPath(for: toCenterX, depthScale:1)
                    ]
        anim.keyTimes = [0,0.5,1]
        anim.duration = CFTimeInterval(0.8)
        anim.isRemovedOnCompletion = false
        anim.fillMode = .both
        
        borderLayer.add(anim, forKey: #keyPath(CAShapeLayer.path))
    }
    
    
}


extension AHLimberTabbar : CAAnimationDelegate {
    
    
}
