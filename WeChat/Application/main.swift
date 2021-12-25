//
//  main.swift
//  WeChat
//
//  Created by Sun on 2021/12/15.
//  Copyright © 2021 TheBoring. All rights reserved.
//

import UIKit

let APPLICATION_START_TIME: CFAbsoluteTime = CFAbsoluteTimeGetCurrent()
_ = UIApplicationMain(
    CommandLine.argc,
    UnsafeMutableRawPointer(CommandLine.unsafeArgv)
        .bindMemory(
            to: UnsafeMutablePointer<Int8>?.self,
            capacity: Int(CommandLine.argc)
    ),
    nil,
    NSStringFromClass(AppDelegate.self)
)
