//
//  Dispatcher.swift
//  WeChat
//
//  Created by Sun on 2021/12/15.
//  Copyright © 2021 TheBoring. All rights reserved.
//

import Foundation

/// 跳转的来源，会区分来自内部调用和外部调通，一些敏感的跳转不支持从外部调用
public enum RouterDispatchSourceType: String {
    /// 来自 App 内部的跳转
    case inside

    /// 来自外部的跳转
    case outside
}

public protocol RouterDispatcherProtocol {
    func dispatch(
        _ URLString: String,
        sourceType: RouterDispatchSourceType,
        parameters: [String: Any]?,
        javaScriptCallback: ((String) -> Void)?
    ) -> DispatchResult

    func dispatchable(_ URLString: String) -> Bool
}

extension Router {
    public static func dispatch(
        _ URLString: String,
        sourceType: RouterDispatchSourceType = .inside,
        parameters: [String: Any]? = nil,
        javaScriptCallback: ((String) -> Void)? = nil
    ) -> DispatchResult {
        routerDispatcher?.dispatch(
            URLString,
            sourceType: sourceType,
            parameters: parameters,
            javaScriptCallback: javaScriptCallback
        ) ?? .unrecognized
    }

    public static func dispatchable(_ URLString: String) -> Bool {
        routerDispatcher?.dispatchable(URLString) == true
    }
}
