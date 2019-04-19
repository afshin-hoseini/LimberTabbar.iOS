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
            
            let fromCenterX = center.x
            let toCenterX = currentTab?.center.x ?? center.x
            let midCenterX = fromCenterX + (toCenterX-fromCenterX)/2
            
            let fromY = CGFloat(-10) + (frame.height / 2)
            let midY = CGFloat(50) + (frame.height / 2)
            let toY = CGFloat(-10) + (frame.height / 2)
            
            let anim = CAKeyframeAnimation(keyPath: #keyPath(CALayer.transform))
            anim.values = [
                
                CGAffineTransform.init(translationX: fromCenterX, y: fromY),
                CGAffineTransform.init(translationX: midCenterX, y: midY),
                CGAffineTransform.init(translationX: toCenterX, y: toY)
            ]
            anim.duration = 0.8
            anim.keyTimes=[0,0.5,1]
            anim.isRemovedOnCompletion = false
            anim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            anim.fillMode = .both
            
//            layer.add(anim, forKey: #keyPath(CALayer.transform))
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                self.imgTabIcon.image = self.currentTab?.tabBarItem?.image
            }
            
            UIView.animateKeyframes(withDuration: 0.8, delay: 0, options: [], animations: {
                
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                    
                    self.center = CGPoint(x: midCenterX, y: midY)
                })
                
                UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
                    
                    self.center = CGPoint(x: toCenterX, y: toY)
                })
                
            }) { (finish) in
                
            }
            
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
        imgTabIcon.tintColor = UIColor.white
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
