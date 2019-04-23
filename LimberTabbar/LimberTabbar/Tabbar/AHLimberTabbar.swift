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
    
    var boundObserver : NSKeyValueObservation?
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
    
    /**A horizontal stack view to keep items in a row*/
    var tabsHolderView : UIStackView!
    
    /**Represents pit like background*/
    var backgroundView : AHLimberTabbarBackgroundView!
    /**A circular view, holding the selectd tab item*/
    var selectedTabHolder : AHSelectedTabItem!
    /**Triggers the selection process animation*/
    var selectedTab : AHLimberTabBarItemView! {
        
        didSet { self.animateSelection(to: selectedTab) }
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
        
        //Removes default background images
        self.backgroundImage = UIImage()
        self.shadowImage = UIImage()
    }
    
    
    public override func awakeFromNib() {
        
        //Initializes the selected tab holder view. (That circle view)
        self.selectedTabHolder = AHSelectedTabItem(size: 40)
        self.selectedTabHolder.tintColor = self.tintColor
        self.selectedTabHolder.backgroundColor = self.defaultBackgroundColor
        addSubview(selectedTabHolder)
        
        //Initializes the background view which responsible to animate the pit under selected item.
        self.backgroundView = AHLimberTabbarBackgroundView(parent: self)
        self.backgroundView.defaultBackgroundColor = self.defaultBackgroundColor
        
        //Initializing tabs holder view
        tabsHolderView = UIStackView()
        tabsHolderView.distribution = .fillEqually
        tabsHolderView.axis = .horizontal
        tabsHolderView.alignment = .fill
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
        
        isInitialized = true
        layoutItems()
        self.selectedTab = self.tabs[0]
        
        
        boundObserver = self.observe(\.bounds, options: NSKeyValueObservingOptions.new) { (observer, value) in
            
            DispatchQueue.main.async {
                self.animateSelection(to: self.selectedTab)
            }
        }
    }
    
    
    public override func setItems(_ items: [UITabBarItem]?, animated: Bool) {
        
        self.items = items
        
        if(isInitialized) {
            
            layoutItems()
        }
        
    }
    
    private func onItemTapped(tab: AHLimberTabBarItemView) {
        
        self.selectedTab = tab
    }
    
    func layoutItems() {
        
        //Removes old tabs
        tabs.forEach { (tab) in
            tabsHolderView.removeArrangedSubview(tab)
        }
        tabs.removeAll()
        
        items?.forEach({ (item) in
            
            let itemView = AHLimberTabBarItemView(tabBarItem: item)
            itemView.onSelected = self.onItemTapped
            itemView.iconTintColor = self.tintColor
            tabsHolderView.addArrangedSubview(itemView)
            tabs.append(itemView)
        })
    }
    
    /**
     Performs and controls the selectetion process animation.
     */
    private func animateSelection(to tab: AHLimberTabBarItemView) {
        
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
