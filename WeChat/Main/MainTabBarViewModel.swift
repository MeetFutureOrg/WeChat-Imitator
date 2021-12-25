//
//  MainTabBarViewModel.swift
//  WeChat
//
//  Created by Sun on 2021/12/24.
//  Copyright © 2021 TheBoring. All rights reserved.
//

import RxCocoa
import RxSwift

class MainTabBarViewModel: ViewModel, ViewModelType {

    struct Input {
        let trigger: Observable<Void>
    }

    struct Output {
        let tabBarItems: Driver<[MainTabBarItem]>
    }

    func transform(input: Input) -> Output {

        let tabBarItems = Observable<[MainTabBarItem]>.just([.chats, .contacts, .discover, .me]).asDriver(onErrorJustReturn: [])
        return Output(tabBarItems: tabBarItems)
    }

    func childViewModel(for tabBarItem: MainTabBarItem) -> ViewModel {
        switch tabBarItem {
        case .chats:
            let viewModel = ChatSessionViewModel(provider)
            return viewModel
        case .contacts:
            let viewModel = ContactsViewModel(provider)
            return viewModel
        case .discover:
            let viewModel = DiscoverViewModel(provider)
            return viewModel
        case .me:
            let viewModel = MeViewModel(provider)
            return viewModel
        }
    }
}
