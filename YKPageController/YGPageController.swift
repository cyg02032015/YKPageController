//
//  YGPageController.swift
//  
//
//  Created by C on 15/8/10.
//
//

import UIKit

public class YGPageController: UIViewController, UIScrollViewDelegate {

    //MARK: 公共变量门
    public var menuHeight: CGFloat = 40
    //MARK: 私有变量门
    private var viewControllers: [UIViewController] = []
    private var titles: [String] = []
    private lazy var frameDicts:[Int:CGRect] = [:]
    private var currentViewController: UIViewController!
    private var scrollView: UIScrollView!
    private var menuView: MenuView!
    
    public func loadViewControllers(vcArr: [UIViewController], andTitles titleArr:[String]) {
        self.viewControllers = vcArr
        self.titles = titleArr
        
    }
    public override func viewDidLoad() {
        super.viewDidLoad()
        menuView = MenuView(frame: CGRect(x: 0, y:NAVIHEIGHT, width: WIDTH, height: menuHeight))
        view.addSubview(menuView)
        menuView.backgroundColor = UIColor.redColor()
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 64, width: WIDTH, height: HEIGHT - menuHeight - NAVIHEIGHT))
        scrollView.delegate = self
        scrollView.backgroundColor = UIColor.yellowColor()
        scrollView.contentSize = CGSize(width: CGFloat(viewControllers.count) * WIDTH, height: 0)
        scrollView.pagingEnabled = true
        view.addSubview(scrollView)
//        for var i = 0; i < viewControllers.count ; i++ {
//            let vc = viewControllers[i]
//            self.addChildViewController(vc)
//            vc.view.frame = CGRect(x: 0, y: 0, width: WIDTH, height: scrollView.frame.height)
//            scrollView.addSubview(vc.view)
//        }
    }
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    

}
