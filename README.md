# YKPageController
========
YKPageController，，啦啦啦
========
--------
使用方法
--------
        let beginingVC1: AnyClass = BeginingViewController.classForCoder()
        let pageController = YGPageController()
        pageController.loadViewControllers([beginingVC1,beginingVC1,beginingVC1], andTitles: ["正在进行", "已经完成", "申请项目"])
        pageController.menuViewStyle = .Line
        addChildViewController(pageController)
        view.addSubview(pageController.view)
*用自己定义的控制器来创建一个类型传入PageController里*
