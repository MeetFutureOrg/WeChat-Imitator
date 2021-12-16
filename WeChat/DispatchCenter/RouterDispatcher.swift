//
//  RouterDispatcher.swift
//  WeChat
//
//  Created by Sun on 2021/12/16.
//  Copyright © 2021 TheBoring. All rights reserved.
//

import Model
import Router
import Component
import Logger
import Common
import Utilities
import Resource
import Networking

import SafariServices
import RxSwift

class RouterDispatcher: RouterDispatcherProtocol {
    
    func dispatchable(_ URLString: String) -> Bool {
        if self.supportHTTP(URLString) {
            return true
        }
        if RouterDispatcherType.build(URLString) != nil {
            return true
        }
        
        return false
    }
    
    func dispatch(
        _ URLString: String,
        sourceType: RouterDispatchSourceType,
        parameters: [String : Any]?,
        javaScriptCallback: ((String) -> Void)?
    ) -> DispatchResult {
        
        // LOG.info("Universal Jump, URLString: \(URLString),from: \(source.rawValue), parameters: \(parameters ?? [:])")
        
        guard let invokeURL = URLString.toURL() else {
            return .unrecognized
        }
        
        // 跳转到网页
        if invokeURL.scheme == "http" || invokeURL.scheme == "https" {
            let trackerURLString = self.configTracker(URLString, parameters: parameters)
            guard let trackerURL = trackerURLString.toURL() else {
                return .unrecognized
            }
            return dispatchHTTP(trackerURL.absoluteString)
        }
        
        guard let type = RouterDispatcherType.build(URLString), type.support(sourceType) else {
            return .unrecognized
        }
        
        // 将 url 参数解析为字典
        let parametersDictionary = invokeURL.absoluteString.decodeURLParameters()
        
        switch type {
        case .session:
            print(parametersDictionary ?? "")
            return .unrecognized
        }
    }
}

extension RouterDispatcher {
    fileprivate func configTracker(_ URLString: String, parameters: [String: Any]?) -> String {
        return URLString
    }
}

extension RouterDispatcher {
    
    private func supportHTTP(_ URLString: String) -> Bool {
        guard let invokeURL = URLString.toURL() else {
            return false
        }
        if invokeURL.scheme == "http" || invokeURL.scheme == "https" {
            guard invokeURL.host != nil else {
                // url 白名单处理
                return false
            }
            return true
        }
        return false
    }
    
    private func dispatchHTTP(_ URLString: String) -> DispatchResult {
        guard let host = URL(string: URLString)?.host else {
            return .unrecognized
        }
        
        return .unrecognized
    }
}
