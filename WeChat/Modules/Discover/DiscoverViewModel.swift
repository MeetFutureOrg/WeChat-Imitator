//
//  DiscoverViewModel.swift
//  WeChat
//
//  Created by Sun on 2021/12/25.
//  Copyright © 2021 TheBoring. All rights reserved.
//

import Foundation
import RxSwift

class DiscoverViewModel: ViewModel, ViewModelType {
    
    enum Sections {
        case moment(Moment)
        case shortVideo(ShortVideo)
        case specialFeature(SpecialFeature)
        case content(Content)
        case live(Live)
        case shoppingAndGames(ShoppingAndGames)
        case miniProgram(MiniProgram)
    }
    
    enum Moment {
        case moment
    }
    
    enum ShortVideo {
        case shortVideo
    }
    
    enum SpecialFeature {
        case scan
        case shake
    }
    
    enum Content {
        case look
        case search
    }
    
    enum Live {
        case live
    }
    
    enum ShoppingAndGames {
        case shopping
        case games
    }
    
    enum MiniProgram {
        case miniPrograme
    }
    
    struct Input {}

    struct Output {}
    
    let itemSelected = PublishSubject<Contact>()

    func transform(input: Input) -> Output {
        return Output()
    }
}
