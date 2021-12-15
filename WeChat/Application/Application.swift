//
//  Application.swift
//  WeChat
//
//  Created by Sun on 2021/12/15.
//  Copyright © 2021 TheBoring. All rights reserved.
//

import UIKit
import Components

final class Application {
    
    static let shared = Application()
    
    private
    weak var delegate: AppDelegate?
    private
    var launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    
    public private(set)
    var window: Window = Window(frame: UIScreen.main.bounds)

    func initialize(delegate: AppDelegate, launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        self.delegate = delegate
        self.launchOptions = launchOptions
        delegate.window = self.window
        
        configWeChat()
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
        
    }
    
    private func configMainInterface() {
        let tabBarController = RootTabBarController()
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
    
    private func configDelayInitialize() {
        
    }
}
