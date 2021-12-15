//
//  ViewModelType.swift
//  WeChat
//
//  Created by Sun on 2021/12/15.
//  Copyright © 2021 TheBoring. All rights reserved.
//

import Foundation

public protocol ViewModelType {
    
    associatedtype Input
    associatedtype Output
        
    func transform(input: Input) -> Output
}
