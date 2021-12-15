//
//  Router.swift
//  WeChat
//
//  Created by Sun on 2021/12/15.
//  Copyright © 2021 TheBoring. All rights reserved.
//

import Foundation

public protocol Routable: TenonModule {
    func delayInit()
}

extension Routable {
    public func delayInit() {}
}

public struct Router {

    public static var test: Piece? {
        print("router test")
        return nil
    }
    
    static private(set) var routerDispatcher: RouterDispatcherProtocol?

    public static func resolve<T>(_ pieceType: T.Type) -> T? {

        return Tenon.resolve(pieceType)
    }

    /// 自动发现组件
    public static func initialize() {

        for module in Module.allCases.reversed() {

            let tonen = "\(module.rawValue).\(module.rawValue)Tenon"
            let piece = "\(module.rawValue)Piece"

            if let cls = NSClassFromString(tonen) as? TenonModule.Type {

                let instance = cls.init()

                if module.hasPiece, let p = instance as? Piece {
                    Tenon.settle(p, piece)
                }
            }
        }
    }

    public static func delayInitialize() {

        for module in Module.allCases.reversed() {
            let piece = "\(module.rawValue)Piece"

            if let p = Tenon.resolve(piece) as? Routable {
                p.delayInit()
            }
        }
    }
    
    public static func registerDispatcher(_ routerDispatcher: RouterDispatcherProtocol?) {
        self.routerDispatcher = routerDispatcher
    }
}
