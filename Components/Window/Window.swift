//
//  Window.swift
//  Components
//
//  Created by Sun on 2021/12/15.
//  Copyright © 2021 TheBoring. All rights reserved.
//

import UIKit
import RxSwift

extension Notification.Name {
    public struct Window {
        public static let touchTrackingUpdated = Notification.Name(rawValue: "com.wechat.notification.name.window.touchTrackingUpdated")
    }
}

open
class Window: UIWindow {

    private let maxTouchesNumber = 3
    private var showTouches: Bool = UserDefaults.standard.bool(forKey: Notification.Name.Window.touchTrackingUpdated.rawValue)
    private var touchViews: [UIImageView] = []
    
    #if DEBUG
    public var motionShakeHandler: (() -> Void)?
    #endif

    public override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)

        self.updateTouchView()
    }

    private func updateTouchView() {

    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    #if DEBUG
    open override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            self.motionShakeHandler?()
        }
    }
    #endif

    open override func sendEvent(_ event: UIEvent) {
        super.sendEvent(event)

        guard showTouches, event.type == .touches, let touches = event.allTouches else {
            return
        }

        let touchesArray =  Array(touches)

        for (index, view) in self.touchViews.enumerated() {

            if index >= touchesArray.count {
                view.isHidden = true
                continue
            }

            let touch = touchesArray[index]

            self.bringSubviewToFront(view)

            switch touch.phase {
            case .cancelled, .ended:
                view.isHidden = true
            default:
                view.isHidden = false
                view.center = touch.location(in: self)

                // force touch
                let maxScale: CGFloat = 2.0
                let minScale: CGFloat = 1.0

                let force = max(minScale, touch.force)
                let scale = (force - minScale) / (touch.maximumPossibleForce - minScale) * (maxScale - minScale) + minScale

                view.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
        }
    }

}
