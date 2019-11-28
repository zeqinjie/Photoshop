//
//  ZQHomeSliderView.swift
//  Photoshop
//
//  Created by 郑泽钦 on 2018/11/10.
//  Copyright © 2018 zhengzeqin. All rights reserved.
//

import UIKit
enum SliderType:Int {
    case `default`
    case size
    case alpha
}
class ZQHomeSliderView: BaseView {

    @IBOutlet weak var slider: GradientSlider!
    var sliderType = SliderType.default
    var actionBlock:((GradientSlider,CGFloat, Bool)->())?
    var value:CGFloat?{
        didSet{
            slider.value = value ?? 0
        }
    }
    
    var minValue:CGFloat?{
        didSet{
            slider.minimumValue = minValue ?? 0
        }
    }
    
    var maxValue:CGFloat?{
        didSet{
            slider.maximumValue = maxValue ?? 1
        }
    }
    
   
    // MARK: - Override
    override func defaultSet() {
        super.defaultSet()
        slider.actionBlock = {
           [weak self] (slider,newValue,finished) in
            self?.actionBlock?(slider,newValue,finished)
        }
        self.isHidden = true
    }
    
    // MARK: - Action
    @IBAction func resetAction(_ sender: UIButton) {
        slider.value = 0
        actionBlock?(slider,slider.value,true)
    }
    


}
