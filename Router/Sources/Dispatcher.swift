//
//  Dispatcher.swift
//  WeChat
//
//  Created by Sun on 2021/12/15.
//  Copyright © 2021 TheBoring. All rights reserved.
//

import Foundation
import Common

/// 跳转的来源，会区分来自内部调用和外部调通，一些敏感的跳转不支持从外部调用
public enum RouterDispatchSource: String {
    /// 来自APP内部的跳转
    case inside
    
    /// 来自外部的跳转
    case outside
}

public protocol RouterDispatcherProtocol {
    func dispatch(
        _ url: String,
        source: RouterDispatchSource,
        params: [String: Any]?,
        jsCallback: ((String) -> Void)?
    ) -> DispatchResult
    
    func canDispatchAndNotSystemDetail(_ url: String) -> Bool
}

extension Router {
    public static func dispatch(
        _ url: String,
        source: RouterDispatchSource = .inside,
        params: [String: Any]? = nil,
        jsCallback: ((String) -> Void)? = nil
    ) -> DispatchResult {
        self.routerDispatcher?.dispatch(
            url,
            source: source,
            params: params,
            jsCallback: jsCallback
        ) ?? .unrecognize
    }
    
    public static func canDispatchAndNotSystemDetail(_ url: String) -> Bool {
        self.routerDispatcher?.canDispatchAndNotSystemDetail(url) == true
    }
}
