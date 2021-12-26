//
//  ContactCellViewModel.swift
//  WeChat
//
//  Created by Sun on 2021/12/25.
//  Copyright © 2021 TheBoring. All rights reserved.
//

import UIKit

class ContactCellViewModel: CellViewModel {
    
    let contact: Contact

    init(_ contact: Contact, isLastOne: Bool = false) {
        self.contact = contact
        super.init()
        
        guard let name = contact.name else { return }
        title.accept(NSAttributedString(string: name))
        isLast.accept(isLastOne)
    }
}
