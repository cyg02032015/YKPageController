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
    
    private var margin: CGFloat = 8
    private lazy var titles = [String]()
    private var scrollView: UIScrollView!
    private var selectedBtn: CGButton = CGButton()
    private var line: UIView!
    private var sum: CGFloat!
    private var isNoEnter: Bool = false // 防止多次进入layoutSubViews方法里头
    var delegate: MenuViewDelegate!
    var menuViewStyle: MenuViewStyle = .Default
    
    public convenience init(frame: CGRect,
        andTitles title: [String],
        andStyle style: MenuViewStyle) {
            self.init(frame: frame)
            self.titles = title
            self.menuViewStyle = style
            self.backgroundColor = MENUBACKCOLOR
            configScrollView()
    }
    
    public override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        if self.menuViewStyle == .Line {
            addLineView()
        }
    }
    private func configScrollView() {
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = false
        scrollView.delegate = self
        addSubview(scrollView)
        configCGButton()
    }
    private func configCGButton(){
        for (i,_) in titles.enumerate() {
            let btn = CGButton(titles: titles, andIndex: i)
            btn.tag = i + 100
            btn.titleLabel?.font = fontWithCGFloat(TITLEFONT)
            btn.selectedColor = SELECTEDCOLOR
            btn.normalColor = NORMALCOLOR
            btn.addTarget(self, action: Selector("btnClick:"), forControlEvents: .TouchUpInside)
            btn.titleLabel?.textColor = NORMALCOLOR
            scrollView.addSubview(btn)
        }
    }
    public override func layoutSubviews() {
        if isNoEnter == true { return }
        
        var btn: CGButton = CGButton()
        var btnPre: CGButton = CGButton()
        var sumWidth: CGFloat = 0
        for (i, _) in scrollView.subviews.enumerate() {
            var btnX: CGFloat = 0 ,btnY: CGFloat ,btnW: CGFloat ,btnH: CGFloat
            btn = scrollView.subviews[i] as! CGButton
            if i >= 1 {
                btnPre = scrollView.subviews[i - 1] as! CGButton
            }
            btnW = (btn.titleLabel?.text)!.sizeWithFonts(fontWithCGFloat(TITLEFONT)).width + 2*margin
            btnY = 0
            btnX = btnPre.frame.origin.x + btnPre.frame.size.width + margin
            btnH = scrollView.frame.height
            btn.frame = CGRect(x: btnX, y: btnY, width: btnW, height: btnH)
            sumWidth += btnW
            if let btn = scrollView.subviews.last as? CGButton {
                scrollView.frame.size = CGSize(width: self.bounds.size.width, height: self.bounds.size.height)
                scrollView.contentSize = CGSize(width: btnX + btnW + margin, height: 0)
                scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
            }
//            btn.backgroundColor = UIColor.grayColor()
                if 0 == i {
                btn.selected = true
                selectedBtn = btn
                    if menuViewStyle == .Default {
                        selectedBtn.selectedItemBecomeBigger()
                    }
            }
            sum = sumWidth

        }
        if scrollView.contentSize.width < self.frame.width {
            //如果可滚动去小于menuview的宽度 重新计算MARGIN
            isNoEnter = true
            var btnP: CGButton = CGButton()
            let m = (WIDTH - sum) / CGFloat(scrollView.subviews.count + 1)
            for (i, _) in scrollView.subviews.enumerate() {
                let btn = scrollView.subviews[i] as! CGButton
                if i >= 1 {
                    btnP = scrollView.subviews[i - 1] as! CGButton
                }
                btn.frame.origin.x = btnP.frame.origin.x + btnP.frame.width + m
            }
        }
        
    }
    
    private func addLineView() {
        let btn = scrollView.subviews.first as! CGButton
        let lineView = LineView()
        var lineX: CGFloat, lineY: CGFloat, lineW: CGFloat, lineH: CGFloat
        lineView.backgroundColor = UIColor.redColor()
        lineX = btn.frame.origin.x
        lineY = btn.frame.height - 2
        lineW = btn.frame.width
        lineH = LINEHEIGHT
        lineView.frame = CGRect(x: lineX, y: lineY, width: lineW, height: lineH)
        line = lineView
        scrollView.addSubview(lineView)
    }
    public func btnClick(btn: CGButton) {
        isNoEnter == true
        if selectedBtn == btn {
            return
        }
        self.delegate.menuViewBtnClickScrollToView(btn.tag - 100)
        selectedBtn.selected = false
        btn.selected = true
        menuButtonClickMove(btn.tag - 100)
        
        if menuViewStyle == .Line {
            UIView.animateWithDuration(0.3, animations: {
                self.line.frame.origin.x = btn.frame.origin.x
                self.line.frame.size.width = btn.frame.size.width
            })
        } else {
            selectedBtn.preItemBecomeSmaller()
            btn.selectedItemBecomeBigger()
        }
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
    //MARK: PageControl调用
    public func menuViewButtonMove(index: Int, andRate rate: CGFloat) {
        let name = String(format: "scrollViewEndFinish%@", self)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "moveIntoCenter:", name: name, object: nil)
        
        let page = Int(rate + 0.5)
        let pageRate = rate - CGFloat(index)
        let count = scrollView.subviews.count
        if rate < 0 {return}
        if menuViewStyle == .Default {
            if index == count - 1 || index >= count - 1 {return}
        } else {
            if index == count - 2 || index >= count - 2 {return}
        }
        if pageRate == 0 {return}
        selectedBtn.selected = false
        let nextBtn = scrollView.subviews[index + 1] as! CGButton
        let currentBtn = scrollView.subviews[index] as! CGButton
        if menuViewStyle == .Line {
            isNoEnter = true
            var mg: CGFloat!
            if rate < CGFloat(count - 2) {
                if scrollView.contentSize.width < self.frame.size.width {
                    mg = (WIDTH - self.sum)/(CGFloat(scrollView.subviews.count + 1))
                    line.frame.origin.x = currentBtn.frame.origin.x + (currentBtn.frame.size.width + mg) * pageRate
                } else {
                    mg = margin
                    line.frame.origin.x = currentBtn.frame.origin.x + (currentBtn.frame.size.width + mg) * pageRate
                }
                line.frame.size.width = currentBtn.frame.size.width + (nextBtn.frame.size.width - currentBtn.frame.size.width) * pageRate
                currentBtn.changeItemColorWithRate(pageRate)
                nextBtn.changeItemColorWithRate(1 - pageRate)
            }
        } else {
            currentBtn.changeItemColorWithScale(pageRate)
            nextBtn.changeItemColorWithScale(1 - pageRate)
        }
        (scrollView.subviews[page] as! CGButton).selected = true
        selectedBtn = scrollView.subviews[page] as! CGButton
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
            scrollView.contentOffset = CGPoint(x: 0, y: 0)
        } else if scrollView.contentOffset.x + self.frame.width >= scrollView.contentSize.width{
            // 如果 总偏移量大于contentsize
            scrollView.contentOffset = CGPoint(x: scrollView.contentSize.width - self.frame.width, y: 0)
        }
    }
    public func selectItemWithIndex(index: Int, andOtherIndex other: Int) {
        selectedBtn = scrollView.subviews[index] as! CGButton
        let otherBtn = scrollView.subviews[other] as! CGButton
        selectedBtn.selected = true
        otherBtn.selected = false
        line.frame.origin.x = selectedBtn.frame.origin.x
        line.frame.size.width = selectedBtn.frame.size.width
        menuButtonClickMove(index)
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }
    
}

class LineView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("woca")
    }
    var radius: CGFloat = 2
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, 1.5)
        let minx = CGRectGetMinX(rect), midx = CGRectGetMidX(rect), maxx = CGRectGetMaxX(rect)
        let miny = CGRectGetMinY(rect), midy = CGRectGetMidY(rect), maxy = CGRectGetMaxY(rect)
        CGContextMoveToPoint(context, minx, midy)
        CGContextAddArcToPoint(context, minx, miny, midx, miny, radius)
        CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
        CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
        CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
        CGContextClosePath(context)
        CGContextSetFillColorWithColor(context, UIColor.redColor().CGColor);
        CGContextDrawPath(context,CGPathDrawingMode.Fill);
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


