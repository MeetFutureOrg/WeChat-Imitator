//
//  RootTabBarController.swift
//  WeChat
//
//  Created by Sun on 2021/12/14.
//  Copyright © 2021 TheBoring. All rights reserved.
//

import AsyncDisplayKit
import ChatSession
import Contact
import Discovery
import Profile
import Common
import RxSwift
import sqlcipher
import Foundation

class RootTabBarController: UITabBarController {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        hidesBottomBarWhenPushed = true
        setChildViewControllers()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
         ASDisableLogging()
    }

    func setChildViewControllers() {

        let chatSessionViewController = ChatSessionViewController()
        let chatSession = generateChildViewController(title: "微信", image: nil, selectedImage: nil, viewController: chatSessionViewController)
        let contactViewController = ContactViewController()
        let contact = generateChildViewController(title: "通讯录", image: nil, selectedImage: nil, viewController: contactViewController)
        let discoveryViewController = DiscoveryViewController()
        let discovery = generateChildViewController(title: "发现", image: nil, selectedImage: nil, viewController: discoveryViewController)
        let profileViewController = ProfileViewController()
        let profile = generateChildViewController(title: "我的", image: nil, selectedImage: nil, viewController: profileViewController)

        let controllers = [
            chatSession,
            contact,
            discovery,
            profile
        ]
        setViewControllers(controllers, animated: false)
    }

    private func generateChildViewController(title: String?,
                                             image: UIImage?,
                                             selectedImage: UIImage?,
                                             viewController: ViewController) -> NavigationController {

        let navigationController = NavigationController(rootViewController: viewController)
        navigationController.tabBarItem = UITabBarItem(title: title, image: image, selectedImage: selectedImage)
        return navigationController
    }
    
    // MARK: - For ASManagesChildVisibilityDepth Use
    private var _parentManagesVisibilityDepth: Bool = false
    private var _visibilityDepth: Int = 0
}

// MARK: - ASManagesChildVisibilityDepth
extension RootTabBarController: ASManagesChildVisibilityDepth {
    func visibilityDepth(ofChildViewController childViewController: UIViewController) -> Int {
        if let viewControllers = self.viewControllers, viewControllers.contains(childViewController) {
            if selectedViewController == childViewController {
                return visibilityDepth()
            }
            return visibilityDepth() + 1
        }
        
        // If childViewController is not actually a child, return NSNotFound which is also a really large number.
        return NSNotFound
    }
    
    func visibilityDepth() -> Int {
        if let parent = self.parent, !_parentManagesVisibilityDepth {
            _parentManagesVisibilityDepth = parent is ASManagesChildVisibilityDepth
        }

        if _parentManagesVisibilityDepth, let parent = self.parent as? ASManagesChildVisibilityDepth {
            return parent.visibilityDepth(ofChildViewController: self)
        }
        return _visibilityDepth
    }
    
    func visibilityDepthDidChange() {
        viewControllers?.forEach({ element in
            if let viewController = element as? ASVisibilityDepth {
                viewController.visibilityDepthDidChange()
            }
        })
    }
    
    func setVisibilityDepth(_ visibilityDepth: Int) {
        guard _visibilityDepth != visibilityDepth else {
          return
        }
        _visibilityDepth = visibilityDepth
        visibilityDepthDidChange()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if !_parentManagesVisibilityDepth {
            setVisibilityDepth(1)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !_parentManagesVisibilityDepth {
            setVisibilityDepth(0)
        }
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        _parentManagesVisibilityDepth = false
        visibilityDepthDidChange()
    }
    
    override var viewControllers: [UIViewController]? {
        didSet {
            visibilityDepthDidChange()
        }
    }

    override func setViewControllers(_ viewControllers: [UIViewController]?, animated: Bool) {
        super.setViewControllers(viewControllers, animated: animated)
        visibilityDepthDidChange()
    }
    
    override var selectedIndex: Int {
        didSet {
            visibilityDepthDidChange()
        }
    }

    override var selectedViewController: UIViewController? {
        didSet {
            visibilityDepthDidChange()
        }
    }
}
