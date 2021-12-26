//
//  CellViewModel.swift
//  WeChat
//
//  Created by Sun on 2021/12/25.
//  Copyright © 2021 TheBoring. All rights reserved.
//

import RxSwift
import RxCocoa

class CellViewModel {

    let title = BehaviorRelay<NSAttributedString?>(value: nil)
    let describtion = BehaviorRelay<NSAttributedString?>(value: nil)
    
    let image = BehaviorRelay<UIImage?>(value: nil)
    let imageURLString = BehaviorRelay<String?>(value: nil)
    
    let badge = BehaviorRelay<Int?>(value: nil)
    let badgeColor = BehaviorRelay<UIColor?>(value: nil)
    
    let hidesDisclosure = BehaviorRelay<Bool>(value: false)
    
    let separatorColor = BehaviorRelay<UIColor?>(value: nil)
    
    let isLast = BehaviorRelay<Bool>(value: false)

}
