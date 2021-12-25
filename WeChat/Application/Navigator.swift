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
    
    func pop(sender: UIViewController?, toRoot: Bool = false) {
        if toRoot {
            sender?.navigationController?.popToRootViewController(animated: true)
        } else {
            sender?.navigationController?.popViewController()
        }
    }

    func dismiss(sender: UIViewController?) {
        sender?.navigationController?.dismiss(animated: true, completion: nil)
    }
}
