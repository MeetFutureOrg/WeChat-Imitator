//
//  ViewController.swift
//  WeChat
//
//  Created by Sun on 2021/12/14.
//  Copyright © 2021 TheBoring. All rights reserved.
//

import AsyncDisplayKit
import RxSwift
import RxCocoa
import SnapKit

class ViewController: ASDKViewController<ASDisplayNode>, ViewControllerType {
    
    // ViewControllerType implements start
    var viewModel: ViewModel?
    var navigator: Navigator

    init(viewModel: ViewModel?, navigator: Navigator) {
        self.viewModel = viewModel
        self.navigator = navigator
        super.init(node: ASDisplayNode())
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var isLoading = BehaviorRelay(value: false)
    var error = PublishSubject<NetworkError>()

    var automaticallyAdjustsLeftBarButtonItem = true
    
    var navigationTitle = "" {
        didSet {
            navigationItem.title = navigationTitle
        }
    }

    var spaceBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)

    var languageChanged = BehaviorRelay<Void>(value: ())

    var orientationEvent = PublishSubject<Void>()
    var motionShakeEvent = PublishSubject<Void>()

    lazy var searchBar: SearchBar = {
        return SearchBar()
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
        updateSubnodes()
    }
    
    func updateSubnodes() {}

    func bindViewModel() {
        viewModel?.loading.asObservable().bind(to: isLoading).disposed(by: rx.disposeBag)
        viewModel?.parsedError.asObservable().bind(to: error).disposed(by: rx.disposeBag)

        languageChanged.subscribe(onNext: { _ in
            // TODO: - do something
        }).disposed(by: rx.disposeBag)

        isLoading.subscribe(onNext: { _ in
            // TODO: - do something
        }).disposed(by: rx.disposeBag)
    }
    
    var inset: CGFloat {
        return Configuration.Dimensions.inset
    }
    // ViewControllerType implements end

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
        updateSubnodes()
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

    @objc
    func closeAction(sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ViewController {

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
