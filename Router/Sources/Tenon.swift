//
//  Tenon.swift
//  WeChat
//
//  Created by Sun on 2021/12/14.
//  Copyright © 2021 TheBoring. All rights reserved.
//

import UIKit

public protocol Piece {
    func rootViewController() -> UIViewController?
}

public protocol TenonModule {
    init()
}

public struct Tenon {

    /// 组件库
    private static var pieces: [String: Piece] = [:]

    /// 注册组件
    /// - Parameters:
    ///     - piece: 待注册的组件实例
    ///     - pieceType: 待注册的协议类型
    public static func settle<T>(_ piece: T, _ pieceType: T.Type) {

        if piece is Piece {
            self.pieces[String(describing: pieceType)] = piece as? Piece
        }
    }

    /// 注册组件
    /// - Parameters:
    ///     - piece: 待注册的组件实例
    ///     - pieceType: 待注册的协议名称
    public static func settle(_ piece: Piece, _ pieceName: String) {

        self.pieces[pieceName] = piece
    }
    
    /// 通过名字获取组件
    ///
    /// - Parameter pieceName: 组件名称
    /// - Returns: 已注册组件
    public static func resolve(_ pieceName: String) -> Piece? {
        return self.pieces[pieceName]
    }

    /// 获取组件
    /// - Parameters:
    ///     - url: 待获取的组件协议类型
    /// - returns: 组件实例
    public static func resolve<T>(_ pieceType: T.Type) -> T? {

        if let piece = self.pieces[String(describing: pieceType)] as? T,
            piece is Piece {
            return piece
        }

        return nil
    }

    internal static func removeAllPieces() {

        self.pieces = [:]
    }
}

extension Piece {

    public func rootViewController() -> UIViewController? {
        return nil
    }
}
