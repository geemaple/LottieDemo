//
//  TestCaseDataSourceProvider.swift
//  Lottie_swift
//
//  Created by jixiangfeng on 2021/6/10.
//

import Foundation
import UIKit

class TestItem {
    var name : String?
    var className : UIViewController.Type?
    required init(name : String?, className : UIViewController.Type?) {
        self.name = name
        self.className = className
    }
}


class TestCaseDataSourceProvider {
    class func dataSource() -> [TestItem] {
        var dataSource = [TestItem]()
        dataSource.append(TestItem(name: "Animation Explorer(动画浏览)", className: AnimationExplorerViewController.self))
//        dataSource.append(TestItem(name: "Animation Explorer(动画浏览)", className: AnimationExplorerViewController.self))
//        dataSource.append(TestItem(name: "Animation Explorer(动画浏览)", className: AnimationExplorerViewController.self))
        
        //。。。
        
        return dataSource
    }
}
