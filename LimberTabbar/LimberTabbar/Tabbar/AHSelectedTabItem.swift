//
//  AHSelectedTabItem.swift
//  LimberTabbar
//
//  Created by Afshin Hoseini on 4/19/19.
//  Copyright © 2019 Afshin Hoseini. All rights reserved.
//

import Foundation
import UIKit

class AHSelectedTabItem: UIView {
    
    var imgTabIcon : UIImageView!
    var currentTab : AHLimberTabBarItemView? {
        
        didSet {
            
            imgTabIcon.image = currentTab?.tabBarItem?.image
            center.x = currentTab?.center.x ?? center.x
            
        }
    }
    
    convenience init(size: CGFloat) {
        
        self.init(frame: CGRect(x: 0, y: -10, width: size, height: size))
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        
        backgroundColor = UIColor.red
        
        layer.cornerRadius = self.frame.width/2
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 2
        
        imgTabIcon = UIImageView()
        addSubview(imgTabIcon)
        
        imgTabIcon.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 9.0, *) {
            NSLayoutConstraint.activate([
                
                imgTabIcon.topAnchor.constraint(equalTo: topAnchor, constant: 5),
                imgTabIcon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
                imgTabIcon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
                imgTabIcon.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
                ])
        }
    }
}
