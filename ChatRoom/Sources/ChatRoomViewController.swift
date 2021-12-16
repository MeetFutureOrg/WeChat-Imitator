//
//  ChatRoomViewController.swift
//  ChatRoom
//
//  Created by Sun on 2021/12/15.
//  Copyright © 2021 TheBoring. All rights reserved.
//

import Common
import SwifterSwift

public class ChatRoomViewController: ViewController {

    override public func viewDidLoad() {
        super.viewDidLoad()
        title = "聊天室"
        node.backgroundColor = .random
        
        hbd_barTintColor = .random
        hbd_barAlpha = .random(in: 0...1.0)
    }
}
