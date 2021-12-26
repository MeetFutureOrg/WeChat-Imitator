//
//  RxTableNodeDataSourceType.swift
//  WeChat
//
//  Created by Sun on 2021/12/25.
//  Copyright © 2021 TheBoring. All rights reserved.
//

import AsyncDisplayKit
import UIKit
import RxSwift

/// Marks data source as `ASTableNode` reactive data source enabling it to be used with one of the `bindTo` methods.
protocol RxTableNodeDataSourceType /*: ASTableDataSource*/ {
    
    /// Type of elements that can be bound to table node.
    associatedtype Element
    
    /// New observable sequence event observed.
    ///
    /// - parameter tableNode: Bound table node.
    /// - parameter observedEvent: Event
    func tableNode(_ tableNode: ASTableNode, observedEvent: Event<Element>)
}
