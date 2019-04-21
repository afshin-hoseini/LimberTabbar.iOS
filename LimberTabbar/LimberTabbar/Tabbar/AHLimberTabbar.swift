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
    
    var isInitialized = false
    var tabs = [AHLimberTabBarItemView]()
    var tabsHolderView : UIView!
    var backgroundView : AHLimberTabbarBackgroundView!
    var selectedTabHolder : AHSelectedTabItem!
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
        
        
        self.selectedTabHolder = AHSelectedTabItem(size: 40)
        addSubview(selectedTabHolder)
        
        self.backgroundView = AHLimberTabbarBackgroundView(parent: self)
        
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
            tabsHolderView.addSubview(itemView)
            
            itemView.frame = CGRect(x: x, y: 0, width: itemWidth, height: itemHeight)
            x += itemWidth
            tabs.append(itemView)
        })
    }
    
    
    func select(tab: AHLimberTabBarItemView) {
        
        selectedTabHolder.currentTab?.show()
        tab.hide()
        
        if let tab = tab.tabBarItem as? AHLimberTabbarItem, let bkg = tab.backgroundColor {
            
            backgroundView.animateColor(to: bkg)
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


extension AHLimberTabbar : CAAnimationDelegate {
    
    
}
