//
//  ChatSessionViewController.swift
//  ChatSession
//
//  Created by Sun on 2021/12/15.
//  Copyright © 2021 TheBoring. All rights reserved.
//

import AsyncDisplayKit

class ChatSessionViewController: TableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()   
    }
    
    override func setupSubnodes() {
        super.setupSubnodes()
        
        navigationTitle = "微信"
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        guard let viewModel = viewModel as? ChatSessionViewModel else { return }

        let input = ChatSessionViewModel.Input(trigger: rx.viewDidLoad,
                                               cancelSearchTrigger: searchBar.rx.cancelButtonClicked.asDriver(),
                                               keywordTrigger: searchBar.rx.text.orEmpty.asDriver(),
                                               selection: node.rx.modelSelected(ChatSessionCellViewModel.self).asDriver())
        let output = viewModel.transform(input: input)

        output.items.drive(node.rx.items(nodeType: ChatSessionCellNode.self)) { _, viewModel in
            return {
                let cellNode = ChatSessionCellNode()
                cellNode.bind(to: viewModel)
                return cellNode
            }
        }.disposed(by: rx.disposeBag)
    }
}
