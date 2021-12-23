//
//  NetworkError.swift
//  WeChat
//
//  Created by Sun on 2021/12/23.
//  Copyright © 2021 TheBoring. All rights reserved.
//

import RxSwift
import RxCocoa
import Moya
import ObjectMapper
import Alamofire

struct ErrorResponse: Mappable {
    var message: String?
    var errors: [ErrorModel] = []
    var documentationUrl: String?

    init?(map: Map) {}
    init() {}

    mutating func mapping(map: Map) {
        message <- map["message"]
        errors <- map["errors"]
        documentationUrl <- map["documentation_url"]
    }

    func detail() -> String {
        return errors.map { $0.message ?? "" }
            .joined(separator: "\n")
    }
}

struct ErrorModel: Mappable {
    var code: String?
    var message: String?
    var field: String?
    var resource: String?

    init?(map: Map) {}
    init() {}

    mutating func mapping(map: Map) {
        code <- map["code"]
        message <- map["message"]
        field <- map["field"]
        resource <- map["resource"]
    }
}

typealias MoyaError = Moya.MoyaError

enum NetworkError: Error {
    case serverError(response: ErrorResponse)

    var title: String {
        switch self {
        case .serverError(let response): return response.message ?? ""
        }
    }

    var description: String {
        switch self {
        case .serverError(let response): return response.detail()
        }
    }
}
