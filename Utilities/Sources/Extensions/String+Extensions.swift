//
//  String+Extensions.swift
//  Utilities
//
//  Created by Sun on 2021/12/16.
//  Copyright © 2021 TheBoring. All rights reserved.
//

import Foundation

extension String {
    
    public func appendURLParameter(parameter: [String : String]) -> String {
        var result = self
        let symbol = result.contains("?") ? "&" : "?"
        result.append(symbol)
        result.append(parameter.map({ "\($0.key)=\($0.value)" }).joined(separator: "&"))
        return result
    }
    
    public func decodeURLParameters() -> [String: String]? {
        var paramsDic: [String: String] = [:]
        
        guard let urlComponents = NSURLComponents(string: self) else {
            return nil
        }
        if let queryItems = urlComponents.queryItems {
            for item in queryItems {
                if !item.name.isEmpty {
                    paramsDic[item.name] = item.value ?? ""
                }
            }
        }
        return paramsDic
    }
    
    public func isURL() -> Bool {
        let expression = try? NSRegularExpression(pattern: "(https?|ftp|file|wechat)://[-A-Z0-9+&@#/%?=~_|!:,.;]*[-A-Z0-9+&@#/%=~_|]", options: .caseInsensitive)
        let numberOfMatchURL = expression?.numberOfMatches(in: self, options: .anchored, range: NSRange(location: 0, length: self.count))
        if let count = numberOfMatchURL {
            return count > 0
        } else {
            return false
        }
    }
    
    public func toURL() -> URL? {
        guard self.isURL() else {
            return nil
        }
        var result = URL(string: self)
        if result == nil {
            if let encodestr = self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
                result = URL(string: encodestr)
            }
        }
        return result
    }
    
}
