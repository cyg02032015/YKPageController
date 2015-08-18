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
