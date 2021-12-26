//
//  ChatSessionViewModel.swift
//  WeChat
//
//  Created by Sun on 2021/12/25.
//  Copyright © 2021 TheBoring. All rights reserved.
//

import RxSwift
import RxCocoa
import RxDataSources

class ChatSessionViewModel: ViewModel, ViewModelType {
    
    struct Input {
        let trigger: ControlEvent<Void>
        let cancelSearchTrigger: Driver<Void>
        let keywordTrigger: Driver<String>
        let selection: Driver<ChatSessionCellViewModel>
    }
    
    struct Output {
        let items: Driver<[ChatSessionCellViewModel]>
        let cancelSearchEvent: Driver<Void>
        let sessionSelected: Driver<ChatSession>
    }
    
    let keyword = BehaviorRelay<String>(value: "")
    let sessionSelected = PublishSubject<ChatSession>()
    
    func transform(input: Input) -> Output {
        let elements = BehaviorRelay<[ChatSessionCellViewModel]>(value: [])
        
        let refresh = Observable.of(input.trigger.asObservable(), keyword.mapToVoid()).merge()
        
        input.keywordTrigger
            .skip(1)
            .throttle(DispatchTimeInterval.milliseconds(300))
            .distinctUntilChanged()
            .asObservable()
            .bind(to: keyword)
            .disposed(by: rx.disposeBag)
        
        refresh.flatMapLatest({ [weak self] () -> Observable<[ChatSessionCellViewModel]> in
            guard let self = self else { return Observable.just([]) }
            return ChatSessionsManager.default.fetchSessions(self.keyword.value)
                .trackActivity(self.loading)
                .trackError(self.error)
                .map { chatSessions in
                    var results: [ChatSessionCellViewModel] = []
                    for (index, chatSession) in chatSessions.enumerated() {
                        let viewModel = ChatSessionCellViewModel(chatSession, isLastOne: index == chatSessions.endIndex - 1)
                        results += [viewModel]
                    }
                    return results
                }
        }).debug("aaaaa").subscribe(onNext: {
            elements.accept($0)
        }, onError: {
            debugPrint($0.localizedDescription)
        }).disposed(by: rx.disposeBag)
        
        let cancelSearchEvent = input.cancelSearchTrigger
        
        input.selection.map { $0.chatSession }.asObservable().bind(to: sessionSelected).disposed(by: rx.disposeBag)
        
        return Output(items: elements.asDriver(),
                      cancelSearchEvent: cancelSearchEvent,
                      sessionSelected: sessionSelected.asDriver(onErrorJustReturn: ChatSession()))
    }
}
