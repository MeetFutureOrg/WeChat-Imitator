//
//  CellNode.swift
//  WeChat
//
//  Created by Sun on 2021/12/25.
//  Copyright © 2021 TheBoring. All rights reserved.
//

import AsyncDisplayKit
import RxSwift
import RxCocoa
import RxOptional

class CellNode: ASCellNode {
    
    private lazy var iconNode = {
        return ASNetworkImageNode()
    }()
    private let titleNode = ASTextNode()
    private let describtionNode = ASTextNode()
    private lazy var disclosureNode: ASImageNode = {
        let disclosure = ASImageNode()
        return disclosure
    }()
    private lazy var separatorLineNode: ASDisplayNode = {
        let separator = ASDisplayNode()
        separator.backgroundColor = Colors.separator
        return separator
    }()
    private lazy var badgeNode = {
        return BadgeNode()
    }()
    
    var selectionColor: UIColor? {
        didSet {
            isSelected = isSelected
        }
    }

    override init() {
        super.init()
        
        automaticallyManagesSubnodes = true
    }
    
    override func didLoad() {
        super.didLoad()
        
        backgroundColor = Colors.white
    }
    
    func bind(to viewModel: CellViewModel) {
        
        DispatchQueue.main.async {
            viewModel.title.asDriver().drive(self.titleNode.rx.attributedText).disposed(by: self.rx.disposeBag)
            viewModel.describtion.asDriver().drive(self.describtionNode.rx.attributedText).disposed(by: self.rx.disposeBag)
            
            viewModel.image.asDriver().filterNil()
                .drive(self.iconNode.rx.image).disposed(by: self.rx.disposeBag)

            viewModel.imageURLString.map { $0?.url }.asDriver(onErrorJustReturn: nil).filterNil()
                .drive(self.iconNode.rx.url).disposed(by: self.rx.disposeBag)

            viewModel.badge.asDriver().drive(self.badgeNode.rx.count).disposed(by: self.rx.disposeBag)
            viewModel.badge.map { $0 == nil }.asDriver(onErrorJustReturn: true).drive(self.badgeNode.rx.isHidden).disposed(by: self.rx.disposeBag)

            viewModel.badgeColor.asDriver().drive(self.badgeNode.rx.tintColor).disposed(by: self.rx.disposeBag)

            viewModel.hidesDisclosure.asDriver().drive(self.disclosureNode.rx.isHidden).disposed(by: self.rx.disposeBag)
            
            viewModel.isLast.asDriver().drive(self.separatorLineNode.rx.isHidden).disposed(by: self.rx.disposeBag)
        }
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        disclosureNode.style.preferredSize = CGSize(width: 12, height: 24)
        titleNode.style.spacingBefore = 16
        disclosureNode.style.spacingAfter = 16
        
        let spacer = ASLayoutSpec()
        spacer.style.flexGrow = 1.0
        
        let stack = ASStackLayoutSpec.horizontal()
        stack.alignItems = .center
        stack.children = [titleNode, spacer, disclosureNode]
        stack.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 56)
        
        separatorLineNode.style.preferredSize = CGSize(width: constrainedSize.max.width - 16, height: Configuration.Dimensions.separatorHeight)
        separatorLineNode.style.layoutPosition = CGPoint(x: 16, y: 56 - Configuration.Dimensions.separatorHeight)
        
        return ASAbsoluteLayoutSpec(children: [stack, separatorLineNode])
    }
    
    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? selectionColor : .clear
        }
    }
}

extension Reactive where Base: CellNode {

    var selectionColor: Binder<UIColor?> {
        return Binder(self.base) { node, attr in
            node.selectionColor = attr
        }
    }
}
