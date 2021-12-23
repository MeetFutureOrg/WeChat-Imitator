//
//  ChatSessionViewController.swift
//  ChatSession
//
//  Created by Sun on 2021/12/15.
//  Copyright © 2021 TheBoring. All rights reserved.
//

import AsyncDisplayKit
import SwifterSwift

public class ChatSessionViewController: ViewController {

    let tableNode = ASTableNode(style: .insetGrouped)
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        tableNode.delegate = self
        tableNode.dataSource = self
        node.addSubnode(tableNode)
        tableNode.backgroundColor = Color(hex: 0xFAFAFA)
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableNode.frame = view.bounds
    }
}

extension ChatSessionViewController: ASTableDataSource {
    public func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 3
    }
    
    public func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    public func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return {
            let cell = CellNode()
            return cell
        }
    }
}

extension ChatSessionViewController: ASTableDelegate {
    public func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        navigationController?.pushViewController(ChatRoomViewController(), animated: true)
    }
}

class CellNode: ASCellNode {
    
    let titleNode = ASTextNode()
    let subtitleNode = ASTextNode()
    
    let orderNode = ASTextNode()
    
    override init() {
        super.init()
        
        backgroundColor = .white
        addSubnode(titleNode)
        addSubnode(subtitleNode)
        addSubnode(orderNode)
    }
    
    override func didLoad() {
        super.didLoad()
        titleNode.attributedText = NSAttributedString(string: "聊天室", attributes: [.foregroundColor: UIColor.black])
        subtitleNode.attributedText = NSAttributedString(string: "副标题", attributes: [.foregroundColor: UIColor.darkGray])
        orderNode.attributedText = NSAttributedString(string: "\(indexPath?.section ?? 0)/\(indexPath?.row ?? 0)", attributes: [.foregroundColor: UIColor.black])
    }
    
    override func didEnterHierarchy() {
        super.didEnterHierarchy()
    }
    
    override func didEnterPreloadState() {
        super.didEnterPreloadState()
    }
    
    override func didEnterVisibleState() {
        super.didEnterVisibleState()
    }
    
    override func didExitVisibleState() {
        super.didExitVisibleState()
    }
    
    // MARK: - layout
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let title = ASStackLayoutSpec(direction: .vertical, spacing: 6, justifyContent: .center, alignItems: .start, children: [titleNode, subtitleNode])
        
        let order = ASCenterLayoutSpec(horizontalPosition: .end, verticalPosition: .center, sizingOption: .minimumSize, child: orderNode)
        
        let content = ASStackLayoutSpec(direction: .horizontal, spacing: 0, justifyContent: .spaceBetween, alignItems: .start, children: [title, order])
        
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12), child: content)
    }
}
