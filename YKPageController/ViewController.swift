//
//  ViewController.swift
//  YGPageControl
//
//  Created by C on 15/8/8.
//  Copyright (c) 2015年 YoungKook. All rights reserved.
//

import UIKit



class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        let vc1: AnyClass = TBViewController().classForCoder
        var vcs = [vc1,vc1,vc1,vc1,vc1,vc1,vc1,vc1,vc1]
        var titles = ["新闻", "专题", "视频","新闻", "专题", "视频","新闻", "专题", "视频"]
        let pageController = YGPageController()
        pageController.loadViewControllers(vcs, andTitles: titles)
        pageController.menuViewStyle = .Default
        self.addChildViewController(pageController)
        view.addSubview(pageController.view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

