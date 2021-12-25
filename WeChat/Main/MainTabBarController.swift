//
//  MainTabBarController.swift
//  WeChat
//
//  Created by Sun on 2021/12/14.
//  Copyright © 2021 TheBoring. All rights reserved.
//

import AsyncDisplayKit
import RxSwift
import UIKit

enum MainTabBarItem: String, CaseIterable {
    case chats
    case contacts
    case discover
    case me
    
    var title: String {
        switch self {
        case .chats:
            return "微信"
        case .contacts:
            return "联系人"
        case .discover:
            return "发现"
        case .me:
            return "我"
        }
    }

    var image: UIImage? {
        UIImage.svgImage(named: "icons_outlined_\(rawValue)", fillColor: Colors.black)
    }
    
    var selectedImage: UIImage? {
        UIImage.svgImage(named: "icons_filled_\(rawValue)", fillColor: Colors.tintColor)
    }
    
    var tag: Int {
        switch self {
        case .chats:
            return 0
        case .contacts:
            return 1
        case .discover:
            return 2
        case .me:
            return 3
        }
    }
    
    private func childController(_ viewModel: ViewModel, navigator: Navigator) -> UIViewController {
        switch self {
        case .chats:
            let chatSession = ChatSessionViewController(viewModel: viewModel, navigator: navigator)
            return NavigationController(rootViewController: chatSession)
        case .contacts:
            let contacts = ContactsViewController(viewModel: viewModel, navigator: navigator)
            return NavigationController(rootViewController: contacts)
        case .discover:
            let discover = DiscoverViewController(viewModel: viewModel, navigator: navigator)
            return NavigationController(rootViewController: discover)
        case .me:
            let me = MeViewController(viewModel: viewModel, navigator: navigator)
            return NavigationController(rootViewController: me)
        }
    }
    
    func getChildController(_ viewModel: ViewModel, navigator: Navigator) -> UIViewController {
        let vc = childController(viewModel, navigator: navigator)
        let item = UITabBarItem(title: title, image: image, selectedImage: selectedImage)
        item.tag = tag
        vc.tabBarItem = item
        return vc
    }
}

class MainTabBarController: UITabBarController {
    
    var viewModel: MainTabBarViewModel?
    var navigator: Navigator
    
    init(_ viewModel: ViewModel?, navigator: Navigator) {
        self.viewModel = viewModel as? MainTabBarViewModel
        self.navigator = navigator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
         // ASDisableLogging()
        setupSubviews()
        bindViewModel()
    }

    func setupSubviews() {
        tabBar.tintColor = Colors.tintColor
    }
    
    func bindViewModel() {
        guard let viewModel = viewModel else { return }

        let input = MainTabBarViewModel.Input(trigger: rx.viewDidAppear.mapToVoid())
        let output = viewModel.transform(input: input)

        output.tabBarItems.delay(.milliseconds(50)).drive(onNext: { [weak self] tabBarItems in
            guard let self = self else { return }
            let controllers = tabBarItems.map { $0.getChildController(viewModel.childViewModel(for: $0), navigator: self.navigator) }
            self.setViewControllers(controllers, animated: false)
        }).disposed(by: rx.disposeBag)
    }

    // MARK: - For ASManagesChildVisibilityDepth Use
    private var _parentManagesVisibilityDepth: Bool = false
    private var _visibilityDepth: Int = 0
}

// MARK: - ASManagesChildVisibilityDepth
extension MainTabBarController: ASManagesChildVisibilityDepth {
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
