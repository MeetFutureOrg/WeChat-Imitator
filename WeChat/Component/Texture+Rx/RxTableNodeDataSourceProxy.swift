//
//  RxTableNodeDataSourceProxy.swift
//  WeChat
//
//  Created by Sun on 2021/12/26.
//  Copyright © 2021 TheBoring. All rights reserved.
//

import AsyncDisplayKit
import RxSwift
import RxCocoa
    
extension ASTableNode: HasDataSource {
    public typealias DataSource = ASTableDataSource
}

private let tableNodeDataSourceNotSet = TableNodeDataSourceNotSet()

private let dataSourceNotSet = "DataSource not set"

private final class TableNodeDataSourceNotSet: NSObject, ASTableDataSource {

    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
        
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        ASDKRxAbstractMethod(message: dataSourceNotSet)
    }
}

/// For more information take a look at `DelegateProxyType`.
class RxTableNodeDataSourceProxy: DelegateProxy<ASTableNode, ASTableDataSource>, DelegateProxyType, ASTableDataSource {

    /// Typed parent object.
    private(set) weak var tableNode: ASTableNode?

    /// - parameter tableNode: Parent object for delegate proxy.
    init(tableNode: ASTableNode) {
        self.tableNode = tableNode
        super.init(parentObject: tableNode, delegateProxy: RxTableNodeDataSourceProxy.self)
    }

    // Register known implementations
    static func registerKnownImplementations() {
        self.register { RxTableNodeDataSourceProxy(tableNode: $0) }
    }

    private weak var _requiredMethodsDataSource: ASTableDataSource? = tableNodeDataSourceNotSet

    // MARK: delegate

    /// Required delegate method implementation.
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return (_requiredMethodsDataSource ?? tableNodeDataSourceNotSet).tableNode?(tableNode, numberOfRowsInSection: section) ?? 0
    }

    /// Required delegate method implementation.
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return (_requiredMethodsDataSource ?? tableNodeDataSourceNotSet).tableNode?(tableNode, nodeBlockForRowAt: indexPath) ?? { return ASCellNode() }
    }

    // For more information take a look at `DelegateProxyType`.
    override func setForwardToDelegate(_ forwardToDelegate: ASTableDataSource?, retainDelegate: Bool) {
        _requiredMethodsDataSource = forwardToDelegate ?? tableNodeDataSourceNotSet
        super.setForwardToDelegate(forwardToDelegate, retainDelegate: retainDelegate)
    }
}
