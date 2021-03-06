//
//  YGGlobel.swift
//  YKPageController
//
//  Created by C on 15/8/12.
//  Copyright (c) 2015年 YoungKook. All rights reserved.
//

import UIKit

func CGLog<T>(message: T,file: String = __FILE__,function: String = __FUNCTION__,line: Int = __LINE__) {
    print("\((file as NSString).lastPathComponent)[\(line)], \(function)---:\(message)")
}


func fontWithCGFloat(font: CGFloat) ->UIFont {
   return UIFont.systemFontOfSize(font)
}

let MENUHEIGHT: CGFloat = 40
let TITLEFONT: CGFloat = 16
let NAVIHEIGHT: CGFloat = 64
let WIDTH = UIScreen.mainScreen().bounds.width
let HEIGHT = UIScreen.mainScreen().bounds.height
let LINEHEIGHT: CGFloat = 2  
let RATE: CGFloat = 1.25
let SELECTEDCOLOR: UIColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
let NORMALCOLOR: UIColor = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 1.0)
let MENUBACKCOLOR: UIColor = UIColor.whiteColor()