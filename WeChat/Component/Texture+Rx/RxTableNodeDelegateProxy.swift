//
//  RxTableNodeDelegateProxy.swift
//  WeChat
//
//  Created by Sun on 2021/12/26.
//  Copyright © 2021 TheBoring. All rights reserved.
//

import AsyncDisplayKit
import RxSwift
import RxCocoa

extension ASTableNode: HasDelegate {
    public typealias Delegate = ASTableDelegate
}

/// For more information take a look at `DelegateProxyType`.
class RxTableNodeDelegateProxy: DelegateProxy<ASTableNode, ASTableDelegate>, DelegateProxyType, ASTableDelegate {

    /// Typed parent object.
    private(set) weak  var tableNode: ASTableNode?

    /// - parameter tableNode: Parent object for delegate proxy.
    init(tableNode: ParentObject) {
        self.tableNode = tableNode
        super.init(parentObject: tableNode, delegateProxy: RxTableNodeDelegateProxy.self)
    }

    // Register known implementations
    static func registerKnownImplementations() {
        self.register { RxTableNodeDelegateProxy(tableNode: $0) }
    }

    private var _contentOffsetBehaviorSubject: BehaviorSubject<CGPoint>?
    private var _contentOffsetPublishSubject: PublishSubject<()>?

    /// Optimized version used for observing content offset changes.
    var contentOffsetBehaviorSubject: BehaviorSubject<CGPoint> {
        if let subject = _contentOffsetBehaviorSubject {
            return subject
        }

        let subject = BehaviorSubject<CGPoint>(value: self.tableNode?.contentOffset ?? CGPoint.zero)
        _contentOffsetBehaviorSubject = subject

        return subject
    }

    /// Optimized version used for observing content offset changes.
    var contentOffsetPublishSubject: PublishSubject<()> {
        if let subject = _contentOffsetPublishSubject {
            return subject
        }

        let subject = PublishSubject<()>()
        _contentOffsetPublishSubject = subject

        return subject
    }
    
    // MARK: delegate methods

    /// For more information take a look at `DelegateProxyType`.
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let subject = _contentOffsetBehaviorSubject {
            subject.on(.next(scrollView.contentOffset))
        }
        if let subject = _contentOffsetPublishSubject {
            subject.on(.next(()))
        }
        self._forwardToDelegate?.scrollViewDidScroll?(scrollView)
    }
    
    deinit {
        if let subject = _contentOffsetBehaviorSubject {
            subject.on(.completed)
        }

        if let subject = _contentOffsetPublishSubject {
            subject.on(.completed)
        }
    }
}
