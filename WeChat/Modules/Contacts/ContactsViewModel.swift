//
//  ContactsViewModel.swift
//  WeChat
//
//  Created by Sun on 2021/12/25.
//  Copyright © 2021 TheBoring. All rights reserved.
//

import RxSwift
import RxCocoa
import RxDataSources

class ContactsViewModel: ViewModel, ViewModelType {
    
    struct Input {
        let trigger: ControlEvent<Void>
        let cancelSearchTrigger: Driver<Void>
        let keywordTrigger: Driver<String>
        let selections: Driver<ContactCellViewModel>
    }
    
    struct Output {
        let items: Driver<[ContactCellViewModel]>
        let cancelSearchEvent: Driver<Void>
        let contactSelected: Driver<Contact>
    }
    
    let keyword = BehaviorRelay<String>(value: "")
    let contactSelected = PublishSubject<Contact>()
    
    func transform(input: Input) -> Output {
        let elements = BehaviorRelay<[ContactCellViewModel]>(value: [])
        
        let refresh = Observable.of(input.trigger.asObservable(), keyword.mapToVoid()).merge()
        
        input.keywordTrigger
            .skip(1)
            .throttle(DispatchTimeInterval.milliseconds(300))
            .distinctUntilChanged()
            .asObservable()
            .bind(to: keyword)
            .disposed(by: rx.disposeBag)
        
        refresh.flatMapLatest({ [weak self] () -> Observable<[ContactCellViewModel]> in
            guard let self = self else { return Observable.just([]) }
            return ContactsManager.default.fetchContacts(self.keyword.value)
                .trackActivity(self.loading)
                .trackError(self.error)
                .map { contacts in
                    var results: [ContactCellViewModel] = []
                    for (index, contact) in contacts.enumerated() {
                        let viewModel = ContactCellViewModel(contact, isLastOne: index == contacts.endIndex - 1)
                        results += [viewModel]
                    }
                    return results
                }
        }).subscribe(onNext: {
            elements.accept($0)
        }, onError: {
            debugPrint($0.localizedDescription)
        }).disposed(by: rx.disposeBag)
        
        let cancelSearchEvent = input.cancelSearchTrigger
        
        input.selections.map { $0.contact }.asObservable().bind(to: contactSelected).disposed(by: rx.disposeBag)
        
        return Output(items: elements.asDriver(),
                      cancelSearchEvent: cancelSearchEvent,
                      contactSelected: contactSelected.asDriver(onErrorJustReturn: Contact()))
    }
}
