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
        let vc1 = TBViewController()
        let vc2 = UIViewController()
        vc2.view.backgroundColor = UIColor.redColor()
        var vcs = [vc2,vc2]
        var titles = ["1", "2", "3"]
        let pageController = YGPageController()
        pageController.loadViewControllers(vcs, andTitles: titles)
        pageController.view.backgroundColor = UIColor.yellowColor()
        view.addSubview(pageController.view)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

