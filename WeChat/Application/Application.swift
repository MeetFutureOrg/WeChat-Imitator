//
//  Application.swift
//  WeChat
//
//  Created by Sun on 2021/12/15.
//  Copyright © 2021 TheBoring. All rights reserved.
//

import UIKit

let SharedApplication = Application.shared

final class Application {

    static let shared = Application()
    
    var provider: WeChatProvider
    let navigator: Navigator

    private weak var delegate: AppDelegate?
    private var launchOptions: [UIApplication.LaunchOptionsKey: Any]?

    private(set)
    var window: WeChatWindow = WeChatWindow(frame: UIScreen.main.bounds)
    
    private init() {
        navigator = Navigator.`default`
        provider = RestfulAPI()
    }

    func initialize(delegate: AppDelegate, launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        self.delegate = delegate
        self.launchOptions = launchOptions
        delegate.window = self.window
        configWeChat()
        let APPLICATION_END_TIME: CFAbsoluteTime = CFAbsoluteTimeGetCurrent()
        debugPrint(String(format: "WeChat: App startup time %.3lf", APPLICATION_END_TIME - APPLICATION_START_TIME))
    }

    private func configWeChat() {

        configModules()
        configAppearance()
        configMainInterface()
        configDelayInitialize()
    }

    private func configModules() {

    }

    private func configAppearance() {

        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        UITabBar.appearance().standardAppearance = appearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }

    private func configMainInterface() {
        let viewModel = MainTabBarViewModel(provider)
        let tabBarController = MainTabBarController(viewModel, navigator: navigator)
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }

    private func configDelayInitialize() {

    }
}
