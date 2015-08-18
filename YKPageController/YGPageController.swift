//
//  YGPageController.swift
//  
//
//  Created by C on 15/8/10.
//
//

import UIKit



public class YGPageController: UIViewController, UIScrollViewDelegate, NSCacheDelegate, MenuViewDelegate{

    //MARK: 公共变量门
    public var menuHeight: CGFloat = 40
    //MARK: 私有变量门
    private lazy var viewControllers: [AnyClass] = []
    private lazy var titles: [String] = Array()
    private lazy var frameDicts:[Int:CGRect] = [:]
    private var currentViewController: UIViewController!
    private var scrollView: UIScrollView!
    private var menuView: MenuView!
    private lazy var dispalyVC: [Int:UIViewController] = [:]
    public var cacheCount: Int!
    private lazy var controllerCache: NSCache = {
        [weak self] in
        var cache = NSCache()
        cache.delegate = self
        if self!.cacheCount == nil {
            cache.countLimit = 3
        } else {
            cache.countLimit = self!.cacheCount
        }
        return cache
    }()
    private var selectController: UIViewController!
    private var selectIndex: Int = -1
    public func loadViewControllers(vcArr: [AnyClass], andTitles titleArr:[String]) {
        self.viewControllers = vcArr
        self.titles = titleArr
        
    }
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        
    }
    public override func viewWillLayoutSubviews() {
        menuView = MenuView(frame: CGRect(x: 0, y:NAVIHEIGHT, width: WIDTH, height: menuHeight), andTitles: titles)
        menuView.delegate = self
        view.addSubview(menuView)
        menuView.backgroundColor = UIColor.redColor()
        scrollView = UIScrollView(frame: CGRect(x: 0, y: NAVIHEIGHT + menuHeight, width: WIDTH, height: HEIGHT - menuHeight - NAVIHEIGHT))
        view.addSubview(scrollView)
        scrollView.delegate = self
        scrollView.backgroundColor = UIColor.yellowColor()
        scrollView.contentSize = CGSize(width: CGFloat(viewControllers.count) * WIDTH, height: 0)
        scrollView.pagingEnabled = true
        for var i = 0; i < viewControllers.count ; i++ {
            let X = CGFloat(i) * WIDTH
            let Y = CGFloat(0)
            let W = WIDTH
            let H = scrollView.frame.height
            let rect = CGRect(x: X, y: Y, width: W, height: H)
            frameDicts[i] = rect
        }
        addViewControllersAtIndex(0)
    }
    private func addViewControllersAtIndex(index: Int) {
        let vcc: AnyClass = viewControllers[index]
        let vc = vcc.new() as! UIViewController
        self.addChildViewController(vc)
        vc.view.frame = frameDicts[index]!
        dispalyVC[index] = vc
        scrollView.addSubview(vc.view)
        selectController = vc
        
    }
    private func removeViewController(viewController: UIViewController, atIndex index: Int) {
        viewController.view.removeFromSuperview()
        viewController.willMoveToParentViewController(nil)
        viewController.removeFromParentViewController()
        dispalyVC.removeValueForKey(index)
        if controllerCache.objectForKey(index) == nil {
            controllerCache.setObject(viewController, forKey: index)
        } else {
            return
        }
    }
    private func addCacheViewController(viewcontroller: UIViewController, atIndex index: Int) {
        self.addChildViewController(viewcontroller)
        scrollView.addSubview(viewcontroller.view)
        dispalyVC[index] = viewcontroller
        selectController = viewcontroller
    }
    private func isInScreen(frame: CGRect) -> Bool {
        let x = frame.origin.x
        let width = scrollView.frame.size.width
        let contentoffsetX = scrollView.contentOffset.x
        if CGRectGetMaxX(frame) > contentoffsetX && x - contentoffsetX < width {
            return true
        } else {
            return false
        }
    }
    //MARK: menuViewDelegate
    public func menuViewBtnClickScrollToView(index: Int) {
        CGLog("\(index)")
        removeViewController(selectController, atIndex: selectIndex)
        selectIndex = index
        var vc = dispalyVC[index] as UIViewController?
        if vc == nil {
            vc = controllerCache.objectForKey(index) as? UIViewController
            if vc != nil {
                addCacheViewController(vc!, atIndex: index)
            } else {
                addViewControllersAtIndex(index)
            }
        }
        scrollView.setContentOffset(CGPoint(x: CGFloat(index) * scrollView.frame.width, y: 0), animated: false)
    }
    //MARK: ScrollViewDelegate
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.frame.width)
        let rate = scrollView.contentOffset.x / scrollView.frame.width
        
        for i in 0 ..< viewControllers.count {
            let frame = frameDicts[i]
            var vc: AnyObject? = dispalyVC[i]
            if isInScreen(frame!) {
                if (vc == nil) {
                    //从缓存中取vc
                    vc = controllerCache.objectForKey(i)
                    if vc != nil {//如果缓存中有值添加缓存里的vc
                        addCacheViewController(vc as! UIViewController, atIndex: i)
                    } else {
                        addViewControllersAtIndex(i)
                    }
                }
            } else {
                if vc != nil {
                    removeViewController(vc as! UIViewController, atIndex: i)
                }
            }
        }
        menuView.menuViewButtonMove(page, andRate: rate)
    }
    public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if scrollView.contentOffset.x < 0 || scrollView.contentOffset.x > scrollView.contentSize.width {return}
        let page = Int(scrollView.contentOffset.x / scrollView.frame.width)
        let name = String(format: "scrollViewEndFinish%@", menuView)
        NSNotificationCenter.defaultCenter().postNotificationName(name, object: nil, userInfo: ["index":page])
    }
    public func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    }
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    //MARK: NSCacheDelegate
    public func cache(cache: NSCache, willEvictObject obj: AnyObject) {
        CGLog(obj)
    }

}
