//
//  JsonFileDataProvider.swift
//  Lottie_demo
//
//  Created by jixiangfeng on 2021/6/10.
//

import Foundation

class JsonFileDataProvider {
    
    class func dataSource() -> [String] {
        let paths = Bundle.main.paths(forResourcesOfType:"json", inDirectory: "Animations")
        return paths
    }
    
}
