//
//  Navigator.swift
//  WeChat
//
//  Created by Sun on 2021/12/23.
//  Copyright © 2021 TheBoring. All rights reserved.
//

import RxSwift
import RxCocoa
import SafariServices

protocol Navigatable {
    var navigator: Navigator { get set }
}

class Navigator {
    static var `default` = Navigator()

    // MARK: - all app scenes
    enum Scene {
    }
}
