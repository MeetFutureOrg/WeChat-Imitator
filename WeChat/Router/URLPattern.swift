//
//  URLPattern.swift
//  Router
//
//  Created by Sun on 2021/12/15.
//  Copyright © 2021 TheBoring. All rights reserved.
//

import Foundation

public struct URLPattern {

    /// URL的分段类型
    public enum Section {

        /// 普通字段
        case string(value: String)

        /// 通配字段
        case wild(name: String)

        /// 所包含的值
        public var value: String {
            switch self {
            case .string(let value):
                return value
            case .wild(let name):
                return name
            }
        }

        /// 转化成正则表达式时的值
        public var regex: String {
            switch self {
            case .string(let value):
                return value
            case .wild:
                return "([^/]+?)"
            }
        }

        /// 转化成格式化字符串时的值
        internal var format: String {
            switch self {
            case .string(let value):
                return value
            case .wild:
                return "%@"
            }
        }
    }

    private init(url: String,
                 scheme: String,
                 components: [Section],
                 parameters: [String: Any]) {
        self.url = url
        self.scheme = scheme
        self.components = components
        self.parameters = parameters
    }

    public init?(_ urlString: String) {

        guard let url = URL(string: urlString),
            let scheme = url.scheme,
            let host = url.host,
              !url.pathComponents.isEmpty else {
                return nil
        }

        var components = url.pathComponents
        self.url = urlString
        self.scheme = scheme

        components[0] = host

        self.components = components.compactMap({ comp -> Section? in
            if let char = comp.first {
                switch char {
                case ":":
                    return Section.wild(name: String(comp.dropFirst()))
                case "?":
                    return nil
                default:
                    return Section.string(value: String(comp))
                }
            } else {
                return nil
            }
        })

        if let query = url.query {
            self.parameters = query.components(separatedBy: "&").reduce(into: [:], { partialResult, pair in
                let key = pair.components(separatedBy: "=")
                if key.count == 2 {
                    partialResult[key[0]] = key[1] as AnyObject
                }
            })
        } else {
            self.parameters = [:]
        }
    }

    public let url: String
    public let scheme: String
    public let components: [Section]
    public let parameters: [String: Any]

    private var regexPattern: NSRegularExpression?

    public var regex: String {
        return "\(self.scheme)://\(self.components.map { $0.regex }.joined(separator: "/"))"
    }

    public var format: String {
        return "\(self.scheme)://\(self.components.map { $0.format }.joined(separator: "/"))"
    }

    public mutating func compile() {
        self.regexPattern = try? NSRegularExpression(pattern: self.regex, options: NSRegularExpression.Options.allowCommentsAndWhitespace)
    }

    public func match(_ url: String) -> [String: Any]? {
        if let pattern = URLPattern(url) {
            return self.match(pattern)
        }

        return nil
    }

    public func match(_ pattern: URLPattern) -> [String: Any]? {

        if let results = self.regexPattern?.matches(in: pattern.url, options: [], range: NSRange(location: 0, length: pattern.url.count)),
            let result = results.first {

            let wildSections = self.components.filter({ section -> Bool in
                switch section {
                case .wild:
                    return true
                default:
                    return false
                }
            })

            guard result.numberOfRanges == wildSections.count + 1 else {
                return nil
            }

            var parameters = self.parameters

            for (key, value) in pattern.parameters {
                parameters[key] = value
            }

            for (index, section) in wildSections.enumerated() {
                parameters[section.value] = (pattern.url as NSString).substring(with: result.range(at: index + 1)) as AnyObject
            }

            return parameters
        }

        return nil
    }

    public func compare(_ url: String) -> [String: Any]? {

        if let pattern = URLPattern(url) {
            return self.compare(pattern)
        }

        return nil
    }

    public func compare(_ pattern: URLPattern) -> [String: Any]? {

        guard pattern.components.count == self.components.count else {
            return nil
        }

        var parameters = self.parameters

        for (key, value) in pattern.parameters {
            parameters[key] = value
        }

        for (index, section) in self.components.enumerated() {
            let urlSection = pattern.components[index]

            switch (section, urlSection) {
            case let (.string(a), .string(b)):
                if a != b {
                    return nil
                }
            case let (.wild(a), .string(b)):
                parameters[a] = b as AnyObject
            default:
                return nil
            }
        }

        return parameters
    }
}
