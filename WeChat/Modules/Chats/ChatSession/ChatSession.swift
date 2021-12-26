//
//  ChatSession.swift
//  WeChat
//
//  Created by Sun on 2021/12/26.
//  Copyright © 2021 TheBoring. All rights reserved.
//

import ObjectMapper
import WCDBSwift

struct ChatSession: Mappable {

    var id: String?
    
    var name: String?
    
    var avatarImageName: String?
    
    var avatarImageURL: URL?
    
    var content: String?
    
    var unreadCount: Int = 0
    
    var isShowUnreadMark = false
    
    var stickOnTop: Bool = false
    
    var muted: Bool = false
    
    var isShowDrafts: Bool {
        return drafts != nil
    }
    
    var drafts: String?

    var forceNotify: Bool = false
    
    var chatBackground: String?
    
    init(id: String? = nil, name: String? = nil) {
        self.id = id
        self.name = name
    }

    init?(map: Map) {}
    init() {}

    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
    }
}

extension ChatSession {
    
    func attributedStringForTitle() -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 15.5),
            .foregroundColor: Colors.black
        ]
        return NSAttributedString(string: name ?? "", attributes: attributes)
    }
    
    func attributedStringForSubtitle() -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor(hexString: "9B9B9B") ?? UIColor.darkGray
        ]
        return NSAttributedString(string: content ?? "", attributes: attributes)
    }
    
    func attributedStringForDrafts() -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor(hexString: "9B9B9B") ?? UIColor.lightGray
        ]
        return NSAttributedString(string: drafts ?? "", attributes: attributes)
    }
    
    func attributedStringForTime() -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 11),
            .foregroundColor: Colors.DEFAUTL_TABLE_INTROL_COLOR ?? UIColor.lightGray
        ]
        return NSAttributedString(string: "12:40", attributes: attributes)
    }
}
