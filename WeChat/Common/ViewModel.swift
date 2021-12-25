//
//  ViewModel.swift
//  WeChat
//
//  Created by Sun on 2021/12/23.
//  Copyright © 2021 TheBoring. All rights reserved.
//

import RxSwift
import RxCocoa
import ObjectMapper

class ViewModel: NSObject {

    let provider: WeChatProvider

    var page = 1

    let loading = ActivityIndicator()
    let headerLoading = ActivityIndicator()
    let footerLoading = ActivityIndicator()

    let error = ErrorTracker()
    let serverError = PublishSubject<Error>()
    let parsedError = PublishSubject<NetworkError>()

    init(_ provider: WeChatProvider) {
        self.provider = provider
        super.init()

        serverError.asObservable().map { error -> NetworkError? in
            do {
                let errorResponse = error as? MoyaError
                if let body = try errorResponse?.response?.mapJSON() as? [String: Any],
                    let errorResponse = Mapper<ErrorResponse>().map(JSON: body) {
                    return NetworkError.serverError(response: errorResponse)
                }
            } catch {
                print(error)
            }
            return nil
        }.filterNil().bind(to: parsedError).disposed(by: rx.disposeBag)

        parsedError.subscribe(onNext: { error in
            debugPrint("\(error)")
        }).disposed(by: rx.disposeBag)
    }

    deinit {
        debugPrint("\(type(of: self)): Deinited")
    }
}
