//
//  WeChat.swift
//  WeChat
//
//  Created by Sun on 2021/12/14.
//  Copyright © 2021 TheBoring. All rights reserved.
//

import Foundation

public struct WeChatWrapper<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol WeChatCompatible: AnyObject { }

public protocol WeChatCompatibleValue {}

extension WeChatCompatible {
    public var wc: WeChatWrapper<Self> {
        get { return WeChatWrapper(self) }
        // swiftlint:disable unused_setter_value
        set { }
        // swiftlint:enable unused_setter_value
    }
}

extension WeChatCompatibleValue {
    public var wc: WeChatWrapper<Self> {
        get { return WeChatWrapper(self) }
        // swiftlint:disable unused_setter_value
        set { }
        // swiftlint:enable unused_setter_value
    }
}
