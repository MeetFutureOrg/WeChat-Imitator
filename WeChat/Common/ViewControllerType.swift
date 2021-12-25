//
//  ViewControllerType.swift
//  WeChat
//
//  Created by Sun on 2021/12/25.
//  Copyright © 2021 TheBoring. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol ViewControllerType: UIViewController {
    
    var viewModel: ViewModel? { get set }
    var navigator: Navigator { get set }
    
    var isLoading: BehaviorRelay<Bool> { get set }
    var error: PublishSubject<NetworkError> { get set }

    var automaticallyAdjustsLeftBarButtonItem: Bool { get set }
    
    var navigationTitle: String { get set }

    var languageChanged: BehaviorRelay<Void> { get set }

    var orientationEvent: PublishSubject<Void> { get set }
    var motionShakeEvent: PublishSubject<Void> { get set }

    var searchBar: SearchBar { get }

    var backBarButton: BarButtonItem { get }
    
    var closeBarButton: BarButtonItem { get }

    func setupSubviews()

    func bindViewModel()

    func updateSubviews()
    
    var inset: CGFloat { get }
}
