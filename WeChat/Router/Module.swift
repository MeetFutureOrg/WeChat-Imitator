//
//  Module.swift
//  Router
//
//  Created by Sun on 2021/12/15.
//  Copyright © 2021 TheBoring. All rights reserved.
//

import Foundation

enum Module: String, CaseIterable {
    case ChatSession
    case ChatRoom
    case Contacts
    case Discover
    case Me
    case Account
    case Model
    case Context
    case Component
    case Utilities
    case Networking
    case Common
    case Database
    case Emoticon
    case Router
    case Logger
    case Search
    case Resource
}

extension Module {

    var hasPiece: Bool {
        switch self {
        case  .ChatSession: return true
        case  .ChatRoom: return true
        case  .Contacts: return true
        case  .Discover: return true
        case  .Me: return true
        case  .Account: return true
        case  .Search: return true

        case  .Model: return false
        case  .Context: return false
        case  .Component: return false
        case  .Utilities: return false
        case  .Networking: return false
        case  .Common: return false
        case  .Database: return false
        case  .Emoticon: return false
        case  .Router: return false
        case  .Logger: return false
        case  .Resource: return false
        }
    }
}

extension Router {

    static var ChatSession: ChatSessionPiece? {
        return Router.resolve(ChatSessionPiece.self)
    }

    static var ChatRoom: ChatRoomPiece? {
        return Router.resolve(ChatRoomPiece.self)
    }

    static var Contacts: ContactsPiece? {
        return Router.resolve(ContactsPiece.self)
    }

    static var Discover: DiscoverPiece? {
        return Router.resolve(DiscoverPiece.self)
    }

    static var Me: MePiece? {
        return Router.resolve(MePiece.self)
    }

    static var Account: AccountPiece? {
        return Router.resolve(AccountPiece.self)
    }

    static var Search: SearchPiece? {
        return Router.resolve(SearchPiece.self)
    }
}
