//
//  ChatSessionCellNode.swift
//  WeChat
//
//  Created by Sun on 2021/12/26.
//  Copyright © 2021 TheBoring. All rights reserved.
//

import AsyncDisplayKit

class ChatSessionCellNode: CellNode {
    
    private let draftNode = ASTextNode()
    private let muteNode = ASImageNode()

    override func bind(to viewModel: CellViewModel) {
        super.bind(to: viewModel)
        guard let cellViewModel = viewModel as? ChatSessionCellViewModel else {
            return
        }
        
        DispatchQueue.main.async {
            cellViewModel.drafts.asDriver().drive(self.draftNode.rx.attributedText).disposed(by: self.rx.disposeBag)
            cellViewModel.isMuted.asDriver().drive(self.muteNode.rx.isHidden).disposed(by: self.rx.disposeBag)
        }
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return super.layoutSpecThatFits(constrainedSize)
    }
}
