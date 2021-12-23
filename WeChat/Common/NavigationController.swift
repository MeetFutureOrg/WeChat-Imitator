//
//  NavigationController.swift
//  WeChat
//
//  Created by Sun on 2021/12/14.
//  Copyright © 2021 TheBoring. All rights reserved.
//

import AsyncDisplayKit
import HBDNavigationBar

open class NavigationController: HBDNavigationController {
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - For ASManagesChildVisibilityDepth Use
    private var _parentManagesVisibilityDepth: Bool = false
    private var _visibilityDepth: Int = 0
}

// MARK: - ASManagesChildVisibilityDepth
extension NavigationController: ASManagesChildVisibilityDepth {
    open func visibilityDepth(ofChildViewController childViewController: UIViewController) -> Int {
        if let firstIndex = viewControllers.firstIndex(of: childViewController) {
            if firstIndex == viewControllers.count - 1 {
              // view controller is at the top, just return our own visibility depth.
              return visibilityDepth()
            } else if firstIndex == 0 {
              // view controller is the root view controller. Can be accessed by holding the back button.
              return visibilityDepth() + 1
            }
            
            return visibilityDepth() + viewControllers.count - 1 - firstIndex
        }
        
        // If childViewController is not actually a child, return NSNotFound which is also a really large number.
        return NSNotFound
    }
    
    open func visibilityDepth() -> Int {
        if let parent = self.parent, !_parentManagesVisibilityDepth {
            _parentManagesVisibilityDepth = parent is ASManagesChildVisibilityDepth
        }

        if _parentManagesVisibilityDepth, let parent = self.parent as? ASManagesChildVisibilityDepth {
            return parent.visibilityDepth(ofChildViewController: self)
        }
        return _visibilityDepth
    }
    
    open func visibilityDepthDidChange() {
        viewControllers.forEach({ element in
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
    
    // UIKit overrides
    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if !_parentManagesVisibilityDepth {
            setVisibilityDepth(1)
        }
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !_parentManagesVisibilityDepth {
            setVisibilityDepth(0)
        }
    }
    
    override open func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        _parentManagesVisibilityDepth = false
        visibilityDepthDidChange()
    }
    
    override open var viewControllers: [UIViewController] {
        didSet {
            visibilityDepthDidChange()
        }
    }

    override open func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        super.setViewControllers(viewControllers, animated: animated)
        visibilityDepthDidChange()
    }
    
    override open func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count == 1 {
            viewController.hidesBottomBarWhenPushed = true
        } else {
            viewController.hidesBottomBarWhenPushed = false
        }
        super.pushViewController(viewController, animated: animated)
        visibilityDepthDidChange()
    }
    
    override open func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        let viewControllers = super.popToViewController(viewController, animated: animated)
        visibilityDepthDidChange()
        return viewControllers
    }
    
    override open func popToRootViewController(animated: Bool) -> [UIViewController]? {
        let viewControllers = super.popToRootViewController(animated: animated)
        visibilityDepthDidChange()
        return viewControllers
    }
    
    override open func popViewController(animated: Bool) -> UIViewController? {
        let viewController = super.popViewController(animated: animated)
        visibilityDepthDidChange()
        return viewController
    }
}
