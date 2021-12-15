//
//  Module.swift
//  Router
//
//  Created by Sun on 2021/12/15.
//  Copyright © 2021 TheBoring. All rights reserved.
//

import Foundation

public enum Module: String, CaseIterable {
    case ChatSession
    case ChatRoom
    case Contact
    case Discovery
    case Profile
    case Account
    case Model
    case Context
    case Components
    case Utilities
    case Network
    case Common
    case Database
    case Emoticon
    case Router
    case Logger
    case Search
}

extension Module {

    public var hasPiece: Bool {
        switch self {
        case  .ChatSession: return true
        case  .ChatRoom: return true
        case  .Contact: return true
        case  .Discovery: return true
        case  .Profile: return true
        case  .Account: return true
        case  .Search: return true

        case  .Model: return false
        case  .Context: return false
        case  .Components: return false
        case  .Utilities: return false
        case  .Network: return false
        case  .Common: return false
        case  .Database: return false
        case  .Emoticon: return false
        case  .Router: return false
        case  .Logger: return false
        }
    }
}

extension Router {
    
    public static var ChatSession: ChatSessionPiece? {
        return Router.resolve(ChatSessionPiece.self)
    }

    public static var ChatRoom: ChatRoomPiece? {
        return Router.resolve(ChatRoomPiece.self)
    }

    public static var Contact: ContactPiece? {
        return Router.resolve(ContactPiece.self)
    }

    public static var Discovery: DiscoveryPiece? {
        return Router.resolve(DiscoveryPiece.self)
    }

    public static var Profile: ProfilePiece? {
        return Router.resolve(ProfilePiece.self)
    }

    public static var Account: AccountPiece? {
        return Router.resolve(AccountPiece.self)
    }

    public static var Search: SearchPiece? {
        return Router.resolve(SearchPiece.self)
    }
}
