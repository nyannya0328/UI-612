//
//  Extension.swift
//  UI-612
//
//  Created by nyannyan0328 on 2022/07/14.
//

import SwiftUI

struct BoundsPrefrence : PreferenceKey{
    
    static var defaultValue: [String:Anchor<CGRect>] = [:]
    
    static func reduce(value: inout [String : Anchor<CGRect>], nextValue: () -> [String : Anchor<CGRect>]) {
        
        value.merge(nextValue()){$1}
    }
}
