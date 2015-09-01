//
//  CGButton.swift
//  YKPageController
//
//  Created by C on 15/8/17.
//  Copyright (c) 2015年 YoungKook. All rights reserved.
//

import UIKit

public class CGButton: UIButton {
    
    public var rate: CGFloat = RATE
    private var rgba: [CGFloat] = [0,0,0,0]
    private var rgbaGap: [CGFloat] = [0,0,0,0]
    public var selectedColor: UIColor? = SELECTEDCOLOR
    public var normalColor: UIColor? = NORMALCOLOR
    public var titleColor: UIColor?
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setTitleColor(normalColor, forState: .Normal)

        
    }
    public required init(coder aDecoder: NSCoder) {
        fatalError("")
    }

    public convenience init(titles: [String], andIndex index: Int) {
        self.init()
        let title = titles[index]
        self.setTitle(title, forState: .Normal)
    }

    public override var selected: Bool {
        didSet {
            if selected == true {
                self.setTitleColor(selectedColor, forState: .Normal)
            } else {
                self.setTitleColor(normalColor, forState: .Normal)
            }
        }
    }
    
    public func selectedItemBecomeBigger() {
        self.selected = true
        UIView.animateWithDuration(0.3, animations: {
            self.transform = CGAffineTransformMakeScale(self.rate, self.rate)
        })
    }
    public func preItemBecomeSmaller() {
        self.selected = false
        UIView.animateWithDuration(0.3, animations: {
            self.transform = CGAffineTransformIdentity
        })
    }
    
    private func configRGBA() {
        let intnormal = CGColorGetNumberOfComponents(normalColor?.CGColor)
        let intselected = CGColorGetNumberOfComponents(selectedColor?.CGColor)
        if intnormal == 4 && intselected == 4 {
            let fNormal = CGColorGetComponents(normalColor?.CGColor)
            let fSelected = CGColorGetComponents(selectedColor?.CGColor)
            rgba[0] = fNormal[0]
            rgbaGap[0] = fSelected[0] - rgba[0]
            rgba[1] = fNormal[1]
            rgbaGap[1] = fSelected[1] - rgba[1]
            rgba[2] = fNormal[2]
            rgbaGap[2] = fSelected[2] - rgba[2]
            rgba[3] = fNormal[3]
            rgbaGap[3] = fSelected[3] - rgba[3]
        } else {
            if intnormal == 2 {
                let fNormal = CGColorGetComponents(self.normalColor?.CGColor)
                normalColor = UIColor(red: fNormal[0], green: fNormal[0], blue: fNormal[0], alpha: fNormal[1])
            } else {
                let fSelected = CGColorGetComponents(self.selectedColor?.CGColor)
                selectedColor = UIColor(red: fSelected[0], green: fSelected[0], blue: fSelected[0], alpha: fSelected[1])
            }
        }
        
    }
    public func changeItemColorWithRate(pageRate: CGFloat) {
        configRGBA()
        let r = rgba[0] + rgbaGap[0] * (1 - pageRate)
        let g = rgba[1] + rgbaGap[1] * (1 - pageRate)
        let b = rgba[2] + rgbaGap[2] * (1 - pageRate)
        let a = rgba[3] + rgbaGap[3] * (1 - pageRate)
        titleColor = UIColor(red: r, green: g, blue: b, alpha: a)
        self.setTitleColor(titleColor, forState: UIControlState.Normal)
    }
    
    public func changeItemColorWithScale(pageRate: CGFloat) {
        changeItemColorWithRate(pageRate)
        let scale = rate - pageRate * (rate - 1)
        self.transform = CGAffineTransformMakeScale(scale, scale)
    }

}
