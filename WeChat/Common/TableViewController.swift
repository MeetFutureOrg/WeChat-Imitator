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
    
    // ViewControllerType implements start
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
    
    func setupSubnodes() {
        navigationItem.backBarButtonItem = backBarButton
        node.view.separatorStyle = .none
        updateSubnodes()
    }
    
    func updateSubnodes() {}
    
    func bindViewModel() {
        viewModel?.headerLoading.asObservable().bind(to: isHeaderLoading).disposed(by: rx.disposeBag)
        viewModel?.footerLoading.asObservable().bind(to: isFooterLoading).disposed(by: rx.disposeBag)
    }
    
    var inset: CGFloat {
        return Configuration.Dimensions.inset
    }
    // ViewControllerType implements end
    
    let headerRefreshTrigger = PublishSubject<Void>()
    let footerRefreshTrigger = PublishSubject<Void>()

    let isHeaderLoading = BehaviorRelay(value: false)
    let isFooterLoading = BehaviorRelay(value: false)
    
    var viewModel: ViewModel?
    var navigator: Navigator
    
    var clearsSelectionOnViewWillAppear = true

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
        setupSubnodes()
        bindViewModel()

        closeBarButton.rx.tap.asObservable().subscribe(onNext: { [weak self] () in
            self?.navigator.dismiss(sender: self)
        }).disposed(by: rx.disposeBag)

        NotificationCenter.default
            .rx.notification(UIDevice.orientationDidChangeNotification).mapToVoid()
            .bind(to: orientationEvent).disposed(by: rx.disposeBag)

        orientationEvent.subscribe { [weak self] _ in
            self?.orientationChanged()
        }.disposed(by: rx.disposeBag)

        NotificationCenter.default
            .rx.notification(UIApplication.didBecomeActiveNotification)
            .subscribe { [weak self] _ in
                self?.didBecomeActive()
            }.disposed(by: rx.disposeBag)

        NotificationCenter.default
            .rx.notification(UIAccessibility.reduceMotionStatusDidChangeNotification)
            .subscribe(onNext: { _ in
                debugPrint("Motion Status changed")
            }).disposed(by: rx.disposeBag)

        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleOneFingerSwipe(swipeRecognizer:)))
        swipeGesture.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(swipeGesture)

        let twoSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleTwoFingerSwipe(swipeRecognizer:)))
        twoSwipeGesture.numberOfTouchesRequired = 2
        self.view.addGestureRecognizer(twoSwipeGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if automaticallyAdjustsLeftBarButtonItem {
            adjustLeftBarButtonItem()
        }
        if clearsSelectionOnViewWillAppear {
            deselectSelectedRow()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateSubnodes()
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            motionShakeEvent.onNext(())
        }
    }

    func orientationChanged() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.updateSubnodes()
        }
    }

    func didBecomeActive() {
        self.updateSubnodes()
    }
    
    func adjustLeftBarButtonItem() {
        if self.navigationController?.viewControllers.count ?? 0 > 1 { // Pushed
            self.navigationItem.leftBarButtonItem = nil
        } else if self.presentingViewController != nil { // presented
            self.navigationItem.leftBarButtonItem = closeBarButton
        }
    }
    
    func deselectSelectedRow() {
        if let selectedIndexPaths = node.indexPathsForSelectedRows {
            selectedIndexPaths.forEach { indexPath in
                node.view.deselectRow(at: indexPath, animated: false)
            }
        }
    }
    
    @objc
    func closeAction(sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension TableViewController {

    @objc
    func handleOneFingerSwipe(swipeRecognizer: UISwipeGestureRecognizer) {
        if swipeRecognizer.state == .recognized {
            // Do somethings
        }
    }

    @objc
    func handleTwoFingerSwipe(swipeRecognizer: UISwipeGestureRecognizer) {
        if swipeRecognizer.state == .recognized {
            // Do somethings
        }
    }
}

extension TableViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {}
}

extension TableViewController: ASTableDataSource {}

extension TableViewController: ASTableDelegate {}
