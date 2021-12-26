//
//  ChatSessionsManager.swift
//  WeChat
//
//  Created by Sun on 2021/12/26.
//  Copyright © 2021 TheBoring. All rights reserved.
//

import RxSwift
import RxCocoa

class ChatSessionsManager {
    
    static let `default` = ChatSessionsManager()
    
    func fetchSessions(_ keyword: String = "") -> Observable<[ChatSession]> {
        return Single.create { [weak self] single in
            guard let self = self else {
                return Disposables.create { }
            }
            single(.success(self.sessions()))
            return Disposables.create { }
        }.asObservable()
    }
    
    func sessions() -> [ChatSession] {
        
        var mockData: MockData?
        
        do {
            let url = Bundle.main.url(forResource: "mock_data", withExtension: "json")
            guard let url = url else {
                return []
            }
            let data = try Data(contentsOf: url)
            mockData = try JSONDecoder().decode(MockData.self, from: data)
        } catch let error {
            debugPrint(error)
        }
        
        var randomMessage: String? {
            mockData?.messages.randomElement()
        }
        
        return mockData!.users.map { user in
            var session = ChatSession(id: user.identifier, name: user.name)
            session.content = randomMessage
            session.avatarImageURL = user.avatar
            if user.identifier == "20001" {
                session.unreadCount = 5
            }
            if user.identifier == "20002" {
                session.unreadCount = 2
                session.isShowUnreadMark = true
                session.muted = true
            }
            return session
        }
    }
}
