//
//  ChatSession.swift
//  Model
//
//  Created by Sun on 2021/12/15.
//  Copyright © 2021 TheBoring. All rights reserved.
//

import Foundation

public struct ChatSession {

    var sessionID: String

    var name: String

    var avatar: URL?

    var content: String?

    var unreadCount: Int = 0

    var showUnreadDot = false

    var stickTop: Bool = false

    var muted: Bool = false

    var showDrafts: Bool {
        return draft != nil
    }

    var draft: String?

    var forceNotify: Bool = false

    var chatBackground: String?

    public init(sessionID: String, name: String) {
        self.sessionID = sessionID
        self.name = name
    }
}
