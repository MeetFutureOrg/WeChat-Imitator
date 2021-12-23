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
        let loginTrigger: Observable<Void>
    }

    struct Output {
        let tabBarItems: Driver<[MainTabBarItem]>
    }

    let authorized: Bool

    init(authorized: Bool, provider: WeChatProvider) {
        self.authorized = authorized
        super.init(provider: provider)
    }

    func transform(input: Input) -> Output {

        let tabBarItems = Observable<[MainTabBarItem]>.just([.wechat, .contact, .discovery, .profile]).asDriver(onErrorJustReturn: [])
        return Output(tabBarItems: tabBarItems)
    }

//    func viewModel(for tabBarItem: MainTabBarItem) -> ViewModel {
//        switch tabBarItem {
//        case .wechat:
//            let viewModel = WeChatViewModel(provider: provider)
//            return viewModel
//        case .contact:
//            let viewModel = ContactViewModel(mode: .user(user: user), provider: provider)
//            return viewModel
//        case .discovery:
//            let viewModel = DiscoveryViewModel(mode: .mine, provider: provider)
//            return viewModel
//        case .profile:
//            let viewModel = ProfileViewModel(provider: provider)
//            return viewModel
//        }
//    }
}
