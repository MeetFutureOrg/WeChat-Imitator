//
//  AppDelegate.swift
//  WeChat
//
//  Created by Sun on 2021/12/13.
//  Copyright © 2021 TheBoring. All rights reserved.
//

import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        Application.shared.initialize(delegate: self, launchOptions: launchOptions)

        return true
    }
}
