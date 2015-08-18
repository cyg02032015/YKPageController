//
//  ViewController.swift
//  YGPageControl
//
//  Created by C on 15/8/8.
//  Copyright (c) 2015年 YoungKook. All rights reserved.
//

import UIKit

let NAVIHEIGHT: CGFloat = 64
let WIDTH = UIScreen.mainScreen().bounds.width
let HEIGHT = UIScreen.mainScreen().bounds.height

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        let vc1: AnyClass = TBViewController().classForCoder
//        let vc2 = TBViewController()
//        let vc3 = TBViewController()
//        let vc4 = TBViewController()
//        let vc5 = TBViewController()
//        let vc6 = TBViewController()
//        let vc7 = TBViewController()
//        let vc8 = TBViewController()
//        let vc9 = TBViewController()
//        let vc10 = TBViewController()
        var vcs = [vc1,vc1,vc1,vc1,vc1,vc1,vc1,vc1,vc1,vc1]
        var titles = ["新闻", "专题", "视频","游戏中心","马甲","weibo","Picth","Swift", "木木","Joke"]
        let pageController = YGPageController()
        pageController.loadViewControllers(vcs, andTitles: titles)
        pageController.view.backgroundColor = UIColor.yellowColor()
        self.addChildViewController(pageController)
        view.addSubview(pageController.view)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

