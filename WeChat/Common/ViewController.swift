//
//  ViewController.swift
//  WeChat
//
//  Created by Sun on 2021/12/14.
//  Copyright © 2021 TheBoring. All rights reserved.
//

import AsyncDisplayKit

open class ViewController: ASDKViewController<ASDisplayNode> {

    override public init() {
        super.init(node: ASDisplayNode())
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
