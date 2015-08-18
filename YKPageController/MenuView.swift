//
//  MenuView.swift
//  YGPageControl
//
//  Created by C on 15/8/10.
//  Copyright (c) 2015年 YoungKook. All rights reserved.
//

import UIKit

protocol MenuViewDelegate {
    func menuViewBtnClickScrollToView(index: Int)
}

public class MenuView: UIView, UIScrollViewDelegate {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    public required init(coder aDecoder: NSCoder) {
        fatalError("")
    }
    
    private var margin: CGFloat = 8
    private lazy var titles: [String] = Array()
    private var scrollView: UIScrollView!
    private var selectedBtn: CGButton = CGButton()
    var delegate: MenuViewDelegate!
    
    public convenience init(frame: CGRect, andTitles title: [String]) {
        self.init(frame: frame)
        self.titles = title
        configScrollView()
    }
    private func configScrollView() {
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = false
        scrollView.delegate = self
        scrollView.backgroundColor = UIColor.grayColor()
        addSubview(scrollView)
        configCGButton()
    }
    private func configCGButton(){
        for i in 0 ..< titles.count {
            let btn = CGButton()
            btn.tag = i + 100
            btn.titleLabel?.font = fontWithCGFloat(16)
            btn.setTitle(titles[i], forState: .Normal)
//            btn.backgroundColor = UIColor.redColor()
            btn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            btn.setTitleColor(UIColor.redColor(), forState: UIControlState.Selected)
            btn.addTarget(self, action: Selector("btnClick:"), forControlEvents: .TouchUpInside)
            scrollView.addSubview(btn)
        }
    }
    public override func layoutSubviews() {
        var btnX: CGFloat = 0 ,btnY: CGFloat ,btnW: CGFloat ,btnH: CGFloat, sumWidth: CGFloat = 0
        var btnPre: CGButton = CGButton()
        for i in 0..<scrollView.subviews.count {
            var btn = scrollView.subviews[i] as! CGButton
            if i >= 1 {
                btnPre = scrollView.subviews[i - 1] as! CGButton
            }
            btn = scrollView.subviews[i] as! CGButton
            btnW = (btn.titleLabel?.text)!.sizeWithFonts(fontWithCGFloat(16)).width
            btnY = 0
            btnX = btnPre.frame.origin.x + btnPre.frame.width + margin
            btnH = scrollView.frame.height
            btn.frame = CGRect(x: btnX, y: btnY, width: btnW, height: btnH)
            sumWidth += btnW
            if let btn = scrollView.subviews.last as? CGButton {
                scrollView.contentSize = CGSize(width: btnX + btnW + margin, height: 0)
            }
            if i == 0 {
                btn.selected = true
                selectedBtn = btn
            }
        }
        if scrollView.contentSize.width < self.frame.width {
            margin = (self.frame.width - sumWidth) / CGFloat(scrollView.subviews.count + 1)
            CGLog(margin)
            for i in 0..<scrollView.subviews.count {
                var btn = scrollView.subviews[i] as! CGButton
                var btnPre = CGButton()
                if i >= 1 {
                    btnPre = scrollView.subviews[i - 1] as! CGButton
                }
                btnX = btnPre.frame.origin.x + btnPre.frame.width + margin
                CGLog(btnX)
                self.setNeedsLayout()
            }
        }
        
    }

    public func btnClick(btn: CGButton) {
        menuButtonClickMove(btn.tag - 100)
        self.delegate.menuViewBtnClickScrollToView(btn.tag - 100)
        if selectedBtn == btn {return}
        selectedBtn.selected = false
        btn.selected = true
        selectedBtn = btn
    }
    private func menuButtonClickMove(index: Int) {

        let count = scrollView.subviews.count
        let btn = scrollView.subviews[index] as! CGButton
        let newFrame = btn.convertRect(self.bounds, toView: nil)
        let cc = newFrame.origin.x - self.center.x
        let contentOffSetX = scrollView.contentOffset.x
        if  index > count - 1 {return}
        if scrollView.contentOffset.x + btn.frame.origin.x > self.center.x {
            scrollView.setContentOffset(CGPoint(x: contentOffSetX + cc + btn.frame.width, y: 0), animated: true)
        } else {
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }

    }
    
    public func menuViewButtonMove(index: Int, andRate rate: CGFloat) {
        let name = String(format: "scrollViewEndFinish%@", self)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "moveIntoCenter:", name: name, object: nil)
        let count = scrollView.subviews.count
        if rate <= 0 {return}
        if (index > count - 1 || rate > CGFloat(count - 1)) {return}
        selectedBtn.selected = false
        let btn = scrollView.subviews[index] as! CGButton
        btn.selected = true
        selectedBtn = scrollView.subviews[index] as! CGButton
        selectedBtn.selected = true
//        menuButtonClickMove(index)

    }
    public func moveIntoCenter(info: NSNotification) {
        let user = info.userInfo as NSDictionary?
        let page = user!.objectForKey("index") as! Int
        menuButtonClickMove(page)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.x <= 0{
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        } else if scrollView.contentOffset.x + self.frame.width >= scrollView.contentSize.width{
            scrollView.setContentOffset(CGPoint(x: scrollView.contentSize.width - self.frame.width, y: 0), animated: false)
        }
    }
}



extension NSString {
    func sizeWithFont(font: UIFont, andMaxSize maxSize:CGSize) -> CGSize {
        let atrribute = [NSFontAttributeName : font]
        return self.boundingRectWithSize(maxSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: atrribute, context: nil).size
    }
    func sizeWithFont(font: UIFont, andMaxX maxX: CGFloat) -> CGSize {
        let atrribute = [NSFontAttributeName : font]
        let maxSize = CGSize(width: maxX, height: CGFloat(MAXFLOAT))
        return self.boundingRectWithSize(maxSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: atrribute, context: nil).size
    }
    func sizeWithFonts(font: UIFont) -> CGSize {
        return sizeWithFont(font, andMaxX: CGFloat(MAXFLOAT))
    }
}

public class CGButton: UIButton {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    public required init(coder aDecoder: NSCoder) {
        fatalError("")
    }
}
