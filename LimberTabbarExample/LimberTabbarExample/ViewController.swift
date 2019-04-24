//
//  ViewController.swift
//  LimberTabbarExample
//
//  Created by Afshin Hoseini on 4/7/19.
//  Copyright © 2019 Afshin Hoseini. All rights reserved.
//

import UIKit
import LimberTabbar

class ViewController: UIViewController, UITabBarDelegate {

    @IBOutlet weak var pitView: AHPitView!
    @IBOutlet weak var slider_pitPosition: UISlider!
    @IBOutlet weak var slider_pitDepthScale: UISlider!
    @IBOutlet weak var switch_guideSquares: UISwitch!
    @IBOutlet weak var tabbar: AHLimberTabbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pitView.pitDepthScale = CGFloat(slider_pitDepthScale.value)
        pitView.pitPositionScale = CGFloat(slider_pitPosition.value)
        pitView.showRects = switch_guideSquares.isOn
        tabbar.delegate = self
        
    }

    @IBAction func onPitPositionChanged(_ slider: UISlider) {
        
        pitView.pitPositionScale = CGFloat(slider.value)
    }
    
    @IBAction func onPitDepthScaleChanged(_ slider: UISlider) {
        
        pitView.pitDepthScale = CGFloat(slider.value)
    }
    
    @IBAction func onGuideSquaresSwitchValueChanged(_ sender: UISwitch) {
        pitView.showRects = sender.isOn
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("Item selected")
    }
}

