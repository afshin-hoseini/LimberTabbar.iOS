//
//  AHSelectedTabItem.swift
//  LimberTabbar
//
//  Created by Afshin Hoseini on 4/19/19.
//  Copyright © 2019 Afshin Hoseini. All rights reserved.
//

import Foundation
import UIKit

/**
 A wrapper which animates the selected tab item, inside a circular view.
 */
class AHSelectedTabItem: UIView {
    
    var defaultBackgroundColor : UIColor = UIColor.white
    var iconTintColor = UIColor.gray {
        
        didSet {
            
            UIView.animate(withDuration: AnimationConfig.iconTintAnimDuration) {
                
                self.imgTabIcon.tintColor = self.iconTintColor
            }
            
        }
    }
    
    var imgTabIcon : UIImageView!
    
    /**
     Determines the selected tab view and perform related animates
    */
    var currentTab : AHLimberTabBarItemView? {
        
        didSet {
            
            //Animates the position on this view
            
            
            //Changes the icon image on half of animation duration
            DispatchQueue.main.asyncAfter(deadline: .now() + AnimationConfig.duration/2) {
                self.imgTabIcon.image = self.currentTab?.tabBarItem?.image
            }
            
            //Background color animation
            let backgroundColor = (self.currentTab?.tabBarItem as? AHLimberTabbarItem)?.backgroundColor ?? self.defaultBackgroundColor
            UIView.animate(withDuration: AnimationConfig.duration / 1.5) { self.backgroundColor = backgroundColor }
            
            
            //Calculations
            let fromCenterX = center.x
            let toCenterX = currentTab?.center.x ?? center.x
            let midCenterX = fromCenterX + (toCenterX-fromCenterX)/2
            
            let midY = CGFloat(50) + (frame.height / 2)
            let toY = CGFloat(-10) + (frame.height / 2)
            
            //View position animation
            UIView.animateKeyframes(withDuration: AnimationConfig.duration, delay: 0, options: [], animations: {
                
                
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                    
                    self.center = CGPoint(x: midCenterX, y: midY)
                })
                
                UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
                    
                    self.center = CGPoint(x: toCenterX, y: toY)
                })
                
            }, completion: nil)
            
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
        imgTabIcon.tintColor = self.iconTintColor
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
