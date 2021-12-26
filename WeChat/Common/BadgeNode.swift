//
//  BadgeNode.swift
//  WeChat
//
//  Created by Sun on 2021/12/25.
//  Copyright © 2021 TheBoring. All rights reserved.
//

import AsyncDisplayKit
import RxSwift
import RxCocoa

class BadgeNode: ASDisplayNode {

    private let textNode = ASTextNode()
    
    private var isDisplayMark = false
    
    private var badgeCountNode: ASImageNode = {
        let background = ASImageNode()
        background.image = UIImage.svgImage(named: "ui-resources_badge_count")
        return background
    }()
    
    private var badgeMarkNode: ASImageNode = {
        let dot = ASImageNode()
        dot.image = UIImage.svgImage(named: "ui-resources_badge_dot")
        return dot
    }()
    
    override init() {
        super.init()
        automaticallyManagesSubnodes = true
    }
    
    func update(count: Int?, isDisplayMark: Bool = false) {
        self.isDisplayMark = isDisplayMark
        guard let count = count else { return }
        let attributes: [NSAttributedString.Key: Any] = [
            .font: Configuration.Font.titleFont,
            .foregroundColor: Colors.white
        ]
        textNode.attributedText = NSAttributedString(string: String(count), attributes: attributes)
        setNeedsLayout()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        if isDisplayMark {
            badgeMarkNode.style.preferredSize = CGSize(width: 20, height: 20)
            return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 5, left: 7.5, bottom: 5, right: 0), child: badgeMarkNode)
        } else {
            let center = ASCenterLayoutSpec(centeringOptions: .XY, sizingOptions: .minimumXY, child: textNode)
            let background = ASBackgroundLayoutSpec(child: center, background: badgeCountNode)
            return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 7.5, bottom: 0, right: 0), child: background)
        }
    }
}

extension Reactive where Base: BadgeNode {

    var count: Binder<Int?> {
        return Binder(self.base) { node, attr in
            node.update(count: attr)
        }
    }
    
    func update(count: Int?, isDisplayMark: Bool = false) -> Binder<Int?> {
        return Binder(self.base) { node, attr in
            node.update(count: attr, isDisplayMark: isDisplayMark)
        }
    }
}
