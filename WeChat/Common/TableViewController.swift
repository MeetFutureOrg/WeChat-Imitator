//
//  TableViewController.swift
//  WeChat
//
//  Created by Sun on 2021/12/25.
//  Copyright © 2021 TheBoring. All rights reserved.
//

import AsyncDisplayKit
import RxSwift
import RxCocoa

class TableViewController: ASDKViewController<ASTableNode>, ViewControllerType {
    var isLoading: BehaviorRelay<Bool> = .init(value: false)
    
    var error: PublishSubject<NetworkError> = PublishSubject()
    
    var automaticallyAdjustsLeftBarButtonItem: Bool = true
    
    var navigationTitle: String = ""
    
    var languageChanged: BehaviorRelay<Void> = BehaviorRelay(value: ())
    
    var orientationEvent: PublishSubject<Void> = PublishSubject()
    
    var motionShakeEvent: PublishSubject<Void> = PublishSubject()
    
    lazy var searchBar: SearchBar = {
        let view = SearchBar()
        return view
    }()
    
    lazy var backBarButton: BarButtonItem = {
        let view = BarButtonItem(image: UIImage.svgImage(named: "icons_filled_back", fillColor: Colors.black),
                                 style: .plain,
                                 target: self,
                                 action: nil)
        view.title = ""
        return view
    }()

    lazy var closeBarButton: BarButtonItem = {
        let view = BarButtonItem(image: UIImage.svgImage(named: "icons_filled_close", fillColor: Colors.black),
                                 style: .plain,
                                 target: self,
                                 action: nil)
        return view
    }()
    
    func setupSubviews() {}
    
    func bindViewModel() {
        viewModel?.headerLoading.asObservable().bind(to: isHeaderLoading).disposed(by: rx.disposeBag)
        viewModel?.footerLoading.asObservable().bind(to: isFooterLoading).disposed(by: rx.disposeBag)
    }
    
    func updateSubviews() {}
    
    var inset: CGFloat = Configuration.Dimensions.inset
    
    let headerRefreshTrigger = PublishSubject<Void>()
    let footerRefreshTrigger = PublishSubject<Void>()

    let isHeaderLoading = BehaviorRelay(value: false)
    let isFooterLoading = BehaviorRelay(value: false)
    
    var viewModel: ViewModel?
    var navigator: Navigator
    
    var clearsSelectionOnViewWillAppear = true
    
    lazy var tableView: ASTableView = {
        let view = node.view
        view.rx.setDelegate(self).disposed(by: rx.disposeBag)
        return view
    }()

    init(viewModel: ViewModel?, navigator: Navigator, style: UITableView.Style = .plain) {
        self.viewModel = viewModel
        self.navigator = navigator
        super.init(node: ASTableNode(style: style))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if clearsSelectionOnViewWillAppear {
            deselectSelectedRow()
        }
    }
    
    
    func deselectSelectedRow() {
        if let selectedIndexPaths = node.indexPathsForSelectedRows {
            selectedIndexPaths.forEach({ (indexPath) in
                tableView.deselectRow(at: indexPath, animated: false)
            })
        }
    }
}


extension TableViewController: UIScrollViewDelegate {
    
}
