//
//  RxTableNodeReactiveArrayDataSource.swift
//  WeChat
//
//  Created by Sun on 2021/12/25.
//  Copyright © 2021 TheBoring. All rights reserved.
//

import AsyncDisplayKit
import RxSwift
import RxCocoa

// objc monkey business
class _RxTableNodeReactiveArrayDataSource: NSObject, ASTableDataSource {
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1
    }
   
    fileprivate func _tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return _tableNode(tableNode, numberOfRowsInSection: section)
    }

    fileprivate func _tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        ASDKRxAbstractMethod()
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return _tableNode(tableNode, nodeBlockForRowAt: indexPath)
    }
}

class RxTableNodeReactiveArrayDataSourceSequenceWrapper<Sequence: Swift.Sequence>: RxTableNodeReactiveArrayDataSource<Sequence.Element>, RxTableNodeDataSourceType {
    typealias Element = Sequence

    override init(nodeFactory: @escaping NodeFactory) {
        super.init(nodeFactory: nodeFactory)
    }

    func tableNode(_ tableNode: ASTableNode, observedEvent: Event<Sequence>) {
        Binder(self) { tableDataSource, sectionModels in
            let sections = Array(sectionModels)
            tableDataSource.tableNode(tableNode, observedElements: sections)
        }.on(observedEvent)
    }
}

// Please take a look at `DelegateProxyType.swift`
class RxTableNodeReactiveArrayDataSource<Element>: _RxTableNodeReactiveArrayDataSource, SectionedViewDataSourceType {
    typealias NodeFactory = (ASTableNode, IndexPath, Element) -> ASCellNodeBlock
    
    var itemModels: [Element]?
    
    func modelAtIndex(_ index: Int) -> Element? {
        return itemModels?[index]
    }

    func model(at indexPath: IndexPath) throws -> Any {
        precondition(indexPath.section == 0)
        guard let item = itemModels?[indexPath.item] else {
            throw RxCocoaError.itemsNotYetBound(object: self)
        }
        return item
    }

    let nodeFactory: NodeFactory
    
    init(nodeFactory: @escaping NodeFactory) {
        self.nodeFactory = nodeFactory
    }
    
    override func _tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return itemModels?.count ?? 0
    }
    
    override func _tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return nodeFactory(tableNode, indexPath, itemModels![indexPath.row])
    }
    
    // reactive
    
    func tableNode(_ tableNode: ASTableNode, observedElements: [Element]) {
        self.itemModels = observedElements
        
        tableNode.reloadData()
    }
}
