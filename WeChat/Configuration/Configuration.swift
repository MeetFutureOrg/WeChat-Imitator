//
//  Configuration.swift
//  WeChat
//
//  Created by Sun on 2021/12/25.
//  Copyright © 2021 TheBoring. All rights reserved.
//

import UIKit

enum Configuration {

    enum Network {}

    enum Dimensions: CGFloat {
        case inset
        case navigationBarHeight
        case cornerRadius
        case separatorHeight
        case borderWidth
        case buttonHeight
        case textFieldHeight
        case tableRowHeight
        
        var rawValue: CGFloat {
            switch self {
            case .inset: return 8
            case .navigationBarHeight: return 44
            case .cornerRadius: return 5
            case .separatorHeight: return 1
            case .borderWidth: return 1
            case .buttonHeight: return 40
            case .textFieldHeight: return 40
            case .tableRowHeight: return 44
            }
        }
    }
    
    static func dimension(_ constant: Dimensions) -> Dimensions.RawValue {
        return constant.rawValue
    }

    enum PathPosition: String {
        case document
        case temporary
        
        var rawValue: String {
            switch self {
            case .document: return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            case .temporary: return NSTemporaryDirectory()
            }
        }
    }
    
    static func path(_ position: PathPosition) -> PathPosition.RawValue {
        return position.rawValue
    }

    enum MMKVKeys: String {
        case isFirstLaunch
        
        private var baseDomain: String {
            "com.sunimp.wechat."
        }
        
        var value: String {
            baseDomain + rawValue
        }
    }
    
    static func mmkvKey(_ key: MMKVKeys) -> MMKVKeys.RawValue {
        return key.value
    }
    
    enum FontStyle: RawRepresentable {
        
        init?(rawValue: UIFont) {
            self = .title
        }
        
        typealias RawValue = UIFont
        
        case title
        case tabBarItem
        case tabBarItemBadge
        
        var rawValue: UIFont {
            switch self {
            case .title: return font(ofSize: 12.0)
            case .tabBarItem: return font(ofSize: 9.0)
            case .tabBarItemBadge: return font(ofSize: 9.0)
            }
        }
        
        fileprivate func font(ofSize size: CGFloat, weight: UIFont.Weight = .regular) -> UIFont {
            UIFont.systemFont(ofSize: size, weight: weight)
        }
    }
    
    static func font(_ style: FontStyle) -> FontStyle.RawValue {
        return style.rawValue
    }
}
