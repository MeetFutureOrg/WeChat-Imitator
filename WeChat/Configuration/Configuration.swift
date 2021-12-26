//
//  Configuration.swift
//  WeChat
//
//  Created by Sun on 2021/12/25.
//  Copyright © 2021 TheBoring. All rights reserved.
//

import UIKit

struct Configuration {

    struct Network {}

    struct Dimensions {
        static let inset: CGFloat = 8
        static let insets: UIEdgeInsets = .init(top: inset, left: inset, bottom: inset, right: inset)
        static let navigationBarHeight: CGFloat = 44
        
        static let cornerRadius: CGFloat = 5
        static let separatorHeight: CGFloat = 1
        static let borderWidth: CGFloat = 1
        static let buttonHeight: CGFloat = 40
        static let textFieldHeight: CGFloat = 40
        static let tableRowHeight: CGFloat = 44
    }

    struct Path {
        static let Document = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        static let Temporary = NSTemporaryDirectory()
    }

    struct MMKVKeys {}
    
    struct Font {
        static let titleFont = UIFont.systemFont(ofSize: 12)
    }
}
