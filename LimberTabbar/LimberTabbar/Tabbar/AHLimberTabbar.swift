//
//  AHLimberTabbar.swift
//  LimberTabbar
//
//  Created by Afshin Hoseini on 4/7/19.
//  Copyright © 2019 Afshin Hoseini. All rights reserved.
//

import Foundation
import UIKit

/**
 Extends `UITabBar` and implements some animations on item selection process.
 */
@IBDesignable
public class AHLimberTabbar : UITabBar {
    
    /**
     Since both background and bar tint colors will be null, this variable will capture the color on initialization.
    */
    var defaultBackgroundColor : UIColor!
    
    var _items: [UITabBarItem]?
    /** Since the items variable is a calculated property, I had to do like this. */
    override public var items: [UITabBarItem]? {
        
        set {self._items = newValue}
        get {return self._items}
    }
    
    var isInitialized = false
    var tabs = [AHLimberTabBarItemView]()
    
    /**This view will just hold all tabs and is useful to keep them separated from background view*/
    var tabsHolderView : UIView!
    
    /**Represents pit like background*/
    var backgroundView : AHLimberTabbarBackgroundView!
    /**A circular view, holding the selectd tab item*/
    var selectedTabHolder : AHSelectedTabItem!
    /**Triggers the selection process animation*/
    var selectedTab : AHLimberTabBarItemView? {
        
        didSet {
            
            self.select(tab: selectedTab!)
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
        
        //Picks the background color and clear them from view
        self.defaultBackgroundColor = self.barTintColor ?? self.backgroundColor ?? UIColor.white
        self.barTintColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        
        //Initializes the selected tab holder view. (That circle view)
        self.selectedTabHolder = AHSelectedTabItem(size: 40)
        self.selectedTabHolder.tintColor = self.tintColor
        self.selectedTabHolder.backgroundColor = self.defaultBackgroundColor
        addSubview(selectedTabHolder)
        
        //Initializes the background view which responsible to animate the pit under selected item.
        self.backgroundView = AHLimberTabbarBackgroundView(parent: self)
        self.backgroundView.defaultBackgroundColor = self.defaultBackgroundColor
        
        //Initializing tabs holder view
        tabsHolderView = UIView()
        addSubview(tabsHolderView)
        
        if #available(iOS 9.0, *) {
        
            tabsHolderView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                
                tabsHolderView.topAnchor.constraint(equalTo: topAnchor),
                tabsHolderView.leadingAnchor.constraint(equalTo: leadingAnchor),
                tabsHolderView.trailingAnchor.constraint(equalTo: trailingAnchor),
                tabsHolderView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }
        
        
        
        self.backgroundImage = UIImage()
        self.shadowImage = UIImage()
        
        isInitialized = true
        layoutItems()
        
    }
    
    public override func awakeFromNib() {
        
        self.selectedTab = self.tabs[0]
    }
    
    public override func setItems(_ items: [UITabBarItem]?, animated: Bool) {
        
        self.items = items
        
        if(isInitialized) {
            
            layoutItems()
        }
        
    }
    
    func layoutItems() {
        
        let itemHeight = bounds.height
        let itemWidth = bounds.width / CGFloat(items?.count ?? 1)
        var x = CGFloat(0)
        
        items?.forEach({ (item) in
            
            let itemView = AHLimberTabBarItemView(tabBarItem: item)
            itemView.onSelected = self.select
            itemView.iconTintColor = self.tintColor
            tabsHolderView.addSubview(itemView)
            
            itemView.frame = CGRect(x: x, y: 0, width: itemWidth, height: itemHeight)
            x += itemWidth
            tabs.append(itemView)
        })
    }
    
    /**
     Performs and controls the selectetion process animation.
     */
    func select(tab: AHLimberTabBarItemView) {
        
        //Determines the tint and background colors
        let iconTintColor = (tab.tabBarItem as? AHLimberTabbarItem)?.iconTintColor ?? tintColor ?? UIColor.gray
        let backgroundColor = (tab.tabBarItem as? AHLimberTabbarItem)?.backgroundColor ?? self.defaultBackgroundColor!
        
        //The previously selected tab must be shown
        selectedTabHolder.currentTab?.show()
        //The selected tab must be hidden
        tab.hide()
        
        //Changes the colors
        selectedTabHolder.iconTintColor = iconTintColor
        backgroundView.animateColor(to: backgroundColor)
        
        tabs.forEach { (tab) in
            tab.iconTintColor = iconTintColor
        }
        
        backgroundView.animatePit(fromCenterX: (selectedTabHolder.currentTab ?? tabs[0]).center.x, toCenterX: tab.center.x)
        
    
        if  let prevTab = selectedTabHolder.currentTab,
            let prevTabIndex = tabs.firstIndex(of: prevTab),
            let selectedTabIndex = tabs.firstIndex(of: tab),
            abs(prevTabIndex - selectedTabIndex) > 1 {
            
                let minIdx = min(prevTabIndex,selectedTabIndex)+1
                let maxIdx = max(prevTabIndex,selectedTabIndex)
            
                for  tabIndex in minIdx..<maxIdx {
                    
                    tabs[tabIndex].pulse()
                }
        }
        
        selectedTabHolder.currentTab = tab
        
    }
}
