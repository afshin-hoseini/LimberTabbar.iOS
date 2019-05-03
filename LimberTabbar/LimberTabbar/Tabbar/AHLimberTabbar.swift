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
    
    @IBInspectable
    var observeSafeAreaInsets : Bool = true
    
    var boundObserver : NSKeyValueObservation?
    var safeViewInsetsObserver : NSKeyValueObservation?
    var itemObserver : NSKeyValueObservation?
    
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
        
        didSet {
            self.animateSelection(to: selectedTab)
            
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
    
    
    deinit {
        
        itemObserver = nil
        safeViewInsetsObserver = nil
        boundObserver = nil
    }
    
    
    func commonInit() {
        
        //Observes the selected item property and animates the selection.
        itemObserver = observe(\.selectedItem, changeHandler: { (ob, v) in
            
            if let selectedItem = self.selectedItem, let index = self.items?.firstIndex(of: selectedItem) {
                self.selectedTab = self.tabs[index]
            }
        })
        
        
        //Picks the background color and clear them from view
        self.defaultBackgroundColor = self.barTintColor ?? self.backgroundColor ?? UIColor.white
        self.barTintColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        
        //Removes default background images
        self.backgroundImage = UIImage()
        self.shadowImage = UIImage()
    }
    
    /**
     Calculates the maximum depth of the pit.
    */
    private func getPitDepth() -> CGFloat {
        
        var percentage = CGFloat(0.8)
        var safeAreaBottomInset = CGFloat(0)
        
        //Calculates the depth according to safeArea insets
        if observeSafeAreaInsets, #available(iOS 11, *) {
            
            safeAreaBottomInset = CGFloat(self.safeAreaInsets.bottom)
            percentage = safeAreaBottomInset > 0 ? 1 : percentage
        }
        
        return (bounds.height - safeAreaBottomInset) * percentage
    }
    
    
    public override func awakeFromNib() {
        
        
        //Observes the safe area insets change if determined
        if observeSafeAreaInsets, #available(iOS 11.0, *) {
            
            self.safeViewInsetsObserver = observe(\.safeAreaInsets, options: .init(arrayLiteral: .new, .old)) { (context, value) in
                
                if value.oldValue?.bottom != value.newValue?.bottom {
                    
                    print("Recalc pit height")
                    self.reselectCurrentTab()
                }
            }
        }
        
        //Initializes the selected tab holder view. (That circle view)
        self.selectedTabHolder = AHSelectedTabItem(size: getPitDepth())
        self.selectedTabHolder.tintColor = self.tintColor
        self.selectedTabHolder.defaultBackgroundColor = self.defaultBackgroundColor
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
        
        
        boundObserver = backgroundView.observe(
        \.bounds,
        options: NSKeyValueObservingOptions.ArrayLiteralElement(arrayLiteral: .initial, .new)) {
            
            (observer, value) in
            
            self.reselectCurrentTab()
        }
    }
    
    private func reselectCurrentTab() {
        
        DispatchQueue.main.async {
            
            let pitDepth = self.getPitDepth()
            self.backgroundView.pitDepth = pitDepth
            self.selectedTabHolder.frame.size = CGSize(width: pitDepth, height: pitDepth)
            self.selectedTabHolder.layer.cornerRadius = self.selectedTabHolder.frame.width/2
            
            self.animateSelection(to: self.selectedTab)
        }
    }
    
    public override func setItems(_ items: [UITabBarItem]?, animated: Bool) {
        
        self.items = items
        
        if(isInitialized) {
            
            layoutItems()
            
            var selectedIndex = 0
            if let tabBarItem = self.selectedTab.tabBarItem, let index = self.items?.firstIndex(of: tabBarItem){
                
                selectedIndex = index
            }
            
            self.selectedTab = self.tabs[selectedIndex]
            
        }
        
    }
    
    private func onItemTapped(tab: AHLimberTabBarItemView) {
        
        self.selectedTab = tab
        delegate?.tabBar!(self, didSelect: tab.tabBarItem!)
    }
    
    func layoutItems() {
        
        //Removes old tabs
        tabs.forEach { (tab) in
            
            tabsHolderView.removeArrangedSubview(tab)
            tab.removeFromSuperview()
        }
        tabs.removeAll()
        
        items?.forEach({ (item) in
            
            let itemView = AHLimberTabBarItemView(tabBarItem: item)
            itemView.onSelected = self.onItemTapped
            itemView.iconTintColor = self.tintColor
            tabsHolderView.addArrangedSubview(itemView)
            tabs.append(itemView)
        })
        
        tabsHolderView.layoutIfNeeded()
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
