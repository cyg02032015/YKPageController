//
//  YGGlobel.swift
//  YKPageController
//
//  Created by C on 15/8/12.
//  Copyright (c) 2015年 YoungKook. All rights reserved.
//

import UIKit

func CGLog<T>(message: T,file: String = __FILE__,function: String = __FUNCTION__,line: Int = __LINE__) {
    println("\(file.lastPathComponent)[\(line)], \(function)---:\(message)")
}


func fontWithCGFloat(font: CGFloat) ->UIFont {
   return UIFont.systemFontOfSize(font)
}

let LINEHEIGHT: CGFloat = 2
let RATE: CGFloat = 1.25
let SELECTEDCOLOR: UIColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
let NORMALCOLOR: UIColor = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 1.0)