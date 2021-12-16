//
//  RouterDispatchType.swift
//  WeChat
//
//  Created by Sun on 2021/12/16.
//  Copyright © 2021 TheBoring. All rights reserved.
//

import Router

/// 枚举的 rawValue 为 url 的 Path, 例如 wechat://wechat/session 的 rawValue 为 "/session"
enum RouterDispatcherType: String, CaseIterable {
    /// 聊天列表, url 参数
    case session             = "/session"
}

extension RouterDispatcherType {
    
    static func build(_ URLString: String?) -> RouterDispatcherType? {
        guard let URLString = URLString, let invokeURL = URL(string: URLString) else {
            return nil
        }
        
        guard invokeURL.scheme == "wechat", invokeURL.host == "wechat" else {
            return nil
        }
        
        return RouterDispatcherType(rawValue: invokeURL.path) ?? RouterDispatcherType(rawValue: "/" + invokeURL.lastPathComponent)
    }
    
    func support(_ sourceType: RouterDispatchSourceType) -> Bool {
        return true
    }
}
