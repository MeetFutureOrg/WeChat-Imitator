//
//  Application.swift
//  WeChat
//
//  Created by Sun on 2021/12/15.
//  Copyright © 2021 TheBoring. All rights reserved.
//

import UIKit
import SwifterSwift

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
        
        appearance.stackedLayoutAppearance.normal.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -2)
        appearance.stackedLayoutAppearance.normal.iconColor = Colors.black
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: Colors.black,
            .font: Configuration.font(.tabBarItem)
        ]
        appearance.stackedLayoutAppearance.normal.badgePositionAdjustment = UIOffset(horizontal: -2, vertical: -2)
            appearance.stackedLayoutAppearance.normal.badgeBackgroundColor = Color.red
        appearance.stackedLayoutAppearance.normal.badgeTextAttributes = [
            .foregroundColor: Colors.white,
            .font: Configuration.font(.tabBarItemBadge)
        ]
        
        appearance.stackedLayoutAppearance.selected.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -2)
        appearance.stackedLayoutAppearance.selected.iconColor = Colors.tintColor
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: Colors.tintColor,
            .font: Configuration.font(.tabBarItem)
        ]
        appearance.stackedLayoutAppearance.selected.badgePositionAdjustment = UIOffset(horizontal: -2, vertical: -2)
        appearance.stackedLayoutAppearance.selected.badgeBackgroundColor = Color.red
        appearance.stackedLayoutAppearance.selected.badgeTextAttributes = [
            .foregroundColor: Colors.white,
            .font: Configuration.font(.tabBarItemBadge)
        ]
        
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
