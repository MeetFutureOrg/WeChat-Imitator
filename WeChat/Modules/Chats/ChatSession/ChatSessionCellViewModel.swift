//
//  ChatSessionCellViewModel.swift
//  WeChat
//
//  Created by Sun on 2021/12/26.
//  Copyright © 2021 TheBoring. All rights reserved.
//

import RxSwift
import RxCocoa
import Foundation

class ChatSessionCellViewModel: CellViewModel {
    
    let chatSession: ChatSession
    
    let drafts = BehaviorRelay<NSAttributedString?>(value: nil)
    let isMuted = BehaviorRelay<Bool>(value: false)

    init(_ chatSession: ChatSession, isLastOne: Bool = false) {
        self.chatSession = chatSession
        super.init()
        
        title.accept(chatSession.attributedStringForTitle())
        describtion.accept(chatSession.attributedStringForSubtitle())
        drafts.accept(chatSession.attributedStringForDrafts())
        isMuted.accept(chatSession.muted)
        isLast.accept(isLastOne)
    }
}
