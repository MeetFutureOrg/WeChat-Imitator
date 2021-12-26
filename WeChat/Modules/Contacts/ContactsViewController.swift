//
//  ContactsViewController.swift
//  Contacts
//
//  Created by Sun on 2021/12/15.
//  Copyright © 2021 TheBoring. All rights reserved.
//

import AsyncDisplayKit

class ContactsViewController: TableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func setupSubnodes() {
        super.setupSubnodes()
        
        navigationTitle = "联系人"
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        guard let viewModel = viewModel as? ContactsViewModel else { return }

        let input = ContactsViewModel.Input(trigger: rx.viewDidLoad,
                                            cancelSearchTrigger: searchBar.rx.cancelButtonClicked.asDriver(),
                                            keywordTrigger: searchBar.rx.text.orEmpty.asDriver(),
                                            selections: node.rx.modelSelected(ContactCellViewModel.self).asDriver())
        let output = viewModel.transform(input: input)

        output.items.drive(node.rx.items(nodeType: ContactCellNode.self)) { _, viewModel in
            return {
                let cellNode = ContactCellNode()
                cellNode.bind(to: viewModel)
                return cellNode
            }
        }.disposed(by: rx.disposeBag)
    }
}
