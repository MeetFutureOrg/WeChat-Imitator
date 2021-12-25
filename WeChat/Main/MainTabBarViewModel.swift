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

        let tabBarItems = Observable<[MainTabBarItem]>.just([.wechat, .contact, .discovery, .profile]).asDriver(onErrorJustReturn: [])
        return Output(tabBarItems: tabBarItems)
    }

    func childViewModel(for tabBarItem: MainTabBarItem) -> ViewModel {
        switch tabBarItem {
        case .wechat:
            let viewModel = ChatSessionViewModel(provider)
            return viewModel
        case .contact:
            let viewModel = ContactViewModel(provider)
            return viewModel
        case .discovery:
            let viewModel = DiscoveryViewModel(provider)
            return viewModel
        case .profile:
            let viewModel = ProfileViewModel(provider)
            return viewModel
        }
    }
}
