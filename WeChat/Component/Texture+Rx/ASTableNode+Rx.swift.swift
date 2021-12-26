//
//  ASTableNode+Rx.swift.swift
//  WeChat
//
//  Created by Sun on 2021/12/26.
//  Copyright © 2021 TheBoring. All rights reserved.
//

import AsyncDisplayKit
import RxSwift
import RxCocoa

// swiftlint:disable file_length
// Items
extension Reactive where Base: ASTableNode {
    
    /**
     Binds sequences of elements to table node rows.
     
     - parameter source: Observable sequence of items.
     - parameter cellFactory: Transform between sequence elements and nodes.
     - returns: Disposable object that can be used to unbind.
     
     Example:
     
     let items = Observable.just([
     "First Item",
     "Second Item",
     "Third Item"
     ])
     
     items.bind(to: tableNode.rx.items) { (indexPath, row, element) in
        return {
            let cellNode = CellNode()
            cellNode.text = NSArributeString(String: element)
            return cellNode
        }
     }
     .disposed(by: disposeBag)
     
     */
    func items<Sequence: Swift.Sequence, Source: ObservableType>
    (_ source: Source)
    -> (_ nodeFactory: @escaping (ASTableNode, IndexPath, Sequence.Element) -> ASCellNodeBlock)
    -> Disposable
    where Source.Element == Sequence {
        return { nodeFactory in
            let dataSource = RxTableNodeReactiveArrayDataSourceSequenceWrapper<Sequence>(nodeFactory: nodeFactory)
            return self.items(dataSource: dataSource)(source)
        }
    }
    
    /**
     Binds sequences of elements to table node rows.
     
     - parameter cellIdentifier: Identifier used to dequeue cells.
     - parameter source: Observable sequence of items.
     - parameter configureCell: Transform between sequence elements and node cells.
     - parameter cellType: Type of table node cell.
     - returns: Disposable object that can be used to unbind.
     
     Example:
     
     let items = Observable.just([
     "First Item",
     "Second Item",
     "Third Item"
     ])
     
     items
     .bind(to: tableNode.rx.items(nodeType: ASCellNode.self)) { (row, element, node) in
        return {
            let cellNode = CellNode()
            cellNode.text = NSArributeString(String: element)
            return cellNode
        }
     }
     .disposed(by: disposeBag)
     */
    func items<Sequence: Swift.Sequence, Node: ASCellNode, Source: ObservableType>
    (nodeType: Node.Type = Node.self)
    -> (_ source: Source)
    -> (_ configureCellNode: @escaping (IndexPath, Sequence.Element) -> ASCellNodeBlock)
    -> Disposable
    where Source.Element == Sequence {
        return { source in
            return { configureCellNode in
                let dataSource = RxTableNodeReactiveArrayDataSourceSequenceWrapper<Sequence> { _, indexPath, item in
                    return configureCellNode(indexPath, item)
                }
                return self.items(dataSource: dataSource)(source)
            }
        }
    }
    
    /**
     Binds sequences of elements to table node rows using a custom reactive data used to perform the transformation.
     This method will retain the data source for as long as the subscription isn't disposed (result `Disposable`
     being disposed).
     In case `source` observable sequence terminates successfully, the data source will present latest element
     until the subscription isn't disposed.
     
     - parameter dataSource: Data source used to transform elements to node cells.
     - parameter source: Observable sequence of items.
     - returns: Disposable object that can be used to unbind.
     */
    func items<
        DataSource: RxTableNodeDataSourceType & ASTableDataSource,
        Source: ObservableType>
    (dataSource: DataSource)
    -> (_ source: Source)
    -> Disposable
    where DataSource.Element == Source.Element {
        return { source in
            // This is called for sideeffects only, and to make sure delegate proxy is in place when
            // data source is being bound.
            // This is needed because theoretically the data source subscription itself might
            // call `self.rx.delegate`. If that happens, it might cause weird side effects since
            // setting data source will set delegate, and ASTableNode might get into a weird state.
            // Therefore it's better to set delegate proxy first, just to be sure.
            _ = self.delegate
            // Strong reference is needed because data source is in use until result subscription is disposed
            return source.subscribeProxyDataSource(ofObject: self.base, dataSource: dataSource as ASTableDataSource, retainDataSource: true) { [weak tableNode = self.base] (_: RxTableNodeDataSourceProxy, event) -> Void in
                guard let tableNode = tableNode else {
                    return
                }
                dataSource.tableNode(tableNode, observedEvent: event)
            }
        }
    }
    
}

extension ObservableType {
    
    func subscribeProxyDataSource<DelegateProxy: DelegateProxyType>(ofObject object: DelegateProxy.ParentObject, dataSource: DelegateProxy.Delegate, retainDataSource: Bool, binding: @escaping (DelegateProxy, Event<Element>) -> Void)
    -> Disposable where DelegateProxy.ParentObject: ASDisplayNode, DelegateProxy.Delegate: AnyObject {
        let proxy = DelegateProxy.proxy(for: object)
        let unregisterDelegate = DelegateProxy.installForwardDelegate(dataSource, retainDelegate: retainDataSource, onProxyForObject: object)
        // this is needed to flush any delayed old state (https://github.com/RxSwiftCommunity/RxDataSources/pull/75)
        object.layoutIfNeeded()
        
        let subscription = self.asObservable()
            .observe(on: MainScheduler())
            .catch { error in
                ASDKBindingError(error)
                return Observable.empty()
            }
        // source can never end, otherwise it would release the subscriber, and deallocate the data source
            .concat(Observable.never())
            .take(until: object.rx.deallocated)
            .subscribe { [weak object] (event: Event<Element>) in
                
                if let object = object {
                    assert(proxy === DelegateProxy.currentDelegate(for: object), "Proxy changed from the time it was first set.\nOriginal: \(proxy)\nExisting: \(String(describing: DelegateProxy.currentDelegate(for: object)))")
                }
                
                binding(proxy, event)
                
                switch event {
                case .error(let error):
                    ASDKBindingError(error)
                    unregisterDelegate.dispose()
                case .completed:
                    unregisterDelegate.dispose()
                default:
                    break
                }
            }
        
        return Disposables.create { [weak object] in
            subscription.dispose()
            object?.layoutIfNeeded()
            unregisterDelegate.dispose()
        }
    }
}

extension Reactive where Base: ASTableNode {
    /**
    Reactive wrapper for `dataSource`.

    For more information take a look at `DelegateProxyType` protocol documentation.
    */
    var dataSource: DelegateProxy<ASTableNode, ASTableDataSource> {
        return RxTableNodeDataSourceProxy.proxy(for: base)
    }

    /**
    Installs data source as forwarding delegate on `rx.dataSource`.
    Data source won't be retained.

    It enables using normal delegate mechanism with reactive delegate mechanism.

    - parameter dataSource: Data source object.
    - returns: Disposable object that can be used to unbind the data source.
    */
    func setDataSource(_ dataSource: ASTableDataSource)
        -> Disposable {
        return RxTableNodeDataSourceProxy.installForwardDelegate(dataSource, retainDelegate: false, onProxyForObject: self.base)
    }

    // events

    /**
    Reactive wrapper for `delegate` message `tableNode:didSelectRowAt:`.
    */
    var itemSelected: ControlEvent<IndexPath> {
        let source = self.delegate.methodInvoked(#selector(ASTableDelegate.tableNode(_:didSelectRowAt:)))
            .map { a in
                return try ASDKCastOrThrow(IndexPath.self, a[1])
            }

        return ControlEvent(events: source)
    }

    /**
     Reactive wrapper for `delegate` message `tableNode:didDeselectRowAt:`.
     */
    var itemDeselected: ControlEvent<IndexPath> {
        let source = self.delegate.methodInvoked(#selector(ASTableDelegate.tableNode(_:didDeselectRowAt:)))
            .map { a in
                return try ASDKCastOrThrow(IndexPath.self, a[1])
            }

        return ControlEvent(events: source)
    }

    /**
     Reactive wrapper for `delegate` message `tableView:accessoryButtonTappedForRowWithIndexPath:`.
     */
    var itemAccessoryButtonTapped: ControlEvent<IndexPath> {
        let source: Observable<IndexPath> = self.delegate.methodInvoked(#selector(ASTableDelegate.tableView(_:accessoryButtonTappedForRowWith:)))
            .map { a in
                return try ASDKCastOrThrow(IndexPath.self, a[1])
            }

        return ControlEvent(events: source)
    }

    /**
     Reactive wrapper for `delegate` message `tableView:commit:forRowAt:`.
     */
    public var itemInserted: ControlEvent<IndexPath> {
        let source = self.dataSource.methodInvoked(#selector(ASTableDataSource.tableView(_:commit:forRowAt:)))
            .filter { a in
                return UITableViewCell.EditingStyle(rawValue: (try ASDKCastOrThrow(NSNumber.self, a[1])).intValue) == .insert
            }
            .map { a in
                return (try ASDKCastOrThrow(IndexPath.self, a[2]))
            }
        
        return ControlEvent(events: source)
    }
    
    /**
    Reactive wrapper for `delegate` message `tableView:commit:forRowAt:`.
    */
    public var itemDeleted: ControlEvent<IndexPath> {
        let source = self.dataSource.methodInvoked(#selector(ASTableDataSource.tableView(_:commit:forRowAt:)))
            .filter { a in
                return UITableViewCell.EditingStyle(rawValue: (try ASDKCastOrThrow(NSNumber.self, a[1])).intValue) == .delete
            }
            .map { a in
                return try ASDKCastOrThrow(IndexPath.self, a[2])
            }
        
        return ControlEvent(events: source)
    }
    
    /**
    Reactive wrapper for `delegate` message `tableView:moveRowAt:to:`.
    */
    var itemMoved: ControlEvent<ItemMovedEvent> {
        let source: Observable<ItemMovedEvent> = self.dataSource.methodInvoked(#selector(ASTableDataSource.tableView(_:moveRowAt:to:)))
            .map { a in
                return (try ASDKCastOrThrow(IndexPath.self, a[1]), try ASDKCastOrThrow(IndexPath.self, a[2]))
            }

        return ControlEvent(events: source)
    }

    /**
    Reactive wrapper for `delegate` message `tableNode:willDisplayRowWith:`.
    */
    var willDisplayNode: ControlEvent<WillDisplayNodeEvent> {
        let source: Observable<WillDisplayNodeEvent> = self.delegate.methodInvoked(#selector(ASTableDelegate.tableNode(_:willDisplayRowWith:)))
            .map { a in
                return (try ASDKCastOrThrow(ASCellNode.self, a[1]))
            }

        return ControlEvent(events: source)
    }

    /**
    Reactive wrapper for `delegate` message `tableNode:didEndDisplayingRowWith:`.
    */
    var didEndDisplayingNode: ControlEvent<DidEndDisplayingNodeEvent> {
        let source: Observable<DidEndDisplayingNodeEvent> = self.delegate.methodInvoked(#selector(ASTableDelegate.tableNode(_:didEndDisplayingRowWith:)))
            .map { a in
                return (try ASDKCastOrThrow(ASCellNode.self, a[1]))
            }

        return ControlEvent(events: source)
    }

    /**
    Reactive wrapper for `delegate` message `tableNode:didSelectRowAt:`.

    It can be only used when one of the `rx.itemsWith*` methods is used to bind observable sequence,
    or any other data source conforming to `SectionedViewDataSourceType` protocol.

     ```
        tableNode.rx.modelSelected(MyModel.self)
            .map { ...
     ```
    */
    func modelSelected<T>(_ modelType: T.Type) -> ControlEvent<T> {
        let source: Observable<T> = self.itemSelected.flatMap { [weak node = self.base as ASTableNode] indexPath -> Observable<T> in
            guard let node = node else {
                return Observable.empty()
            }

            return Observable.just(try node.rx.model(at: indexPath))
        }

        return ControlEvent(events: source)
    }

    /**
     Reactive wrapper for `delegate` message `tableNode:didDeselectRowAt:`.

     It can be only used when one of the `rx.itemsWith*` methods is used to bind observable sequence,
     or any other data source conforming to `SectionedViewDataSourceType` protocol.

     ```
        tableNode.rx.modelDeselected(MyModel.self)
            .map { ...
     ```
     */
    func modelDeselected<T>(_ modelType: T.Type) -> ControlEvent<T> {
        let source: Observable<T> = self.itemDeselected.flatMap { [weak node = self.base as ASTableNode] indexPath -> Observable<T> in
            guard let node = node else {
                return Observable.empty()
            }
            
            return Observable.just(try node.rx.model(at: indexPath))
        }
        
        return ControlEvent(events: source)
    }

    /**
     Reactive wrapper for `delegate` message `tableView:commit:forRowAt:`.

     It can be only used when one of the `rx.itemsWith*` methods is used to bind observable sequence,
     or any other data source conforming to `SectionedViewDataSourceType` protocol.

     ```
        tableNode.rx.modelDeleted(MyModel.self)
            .map { ...
     ```
     */
    func modelDeleted<T>(_ modelType: T.Type) -> ControlEvent<T> {
        let source: Observable<T> = self.itemDeleted.flatMap { [weak node = self.base as ASTableNode] indexPath -> Observable<T> in
            guard let node = node else {
                return Observable.empty()
            }

            return Observable.just(try node.rx.model(at: indexPath))
        }

        return ControlEvent(events: source)
    }

    /**
     Synchronous helper method for retrieving a model at indexPath through a reactive data source.
     */
    func model<T>(at indexPath: IndexPath) throws -> T {
        let dataSource: SectionedViewDataSourceType = ASDKCastOrFatalError(self.dataSource.forwardToDelegate(), message: "This method only works in case one of the `rx.items*` methods was used.")

        let element = try dataSource.model(at: indexPath)

        return ASDKCastOrFatalError(element)
    }
}

extension Reactive where Base: ASTableNode {
    
    typealias ASDKEndZoomEvent = (node: ASDisplayNode?, scale: CGFloat)
    typealias ASDKWillEndDraggingEvent = (velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)

    /// Reactive wrapper for `delegate`.
    ///
    /// For more information take a look at `DelegateProxyType` protocol documentation.
    var delegate: DelegateProxy<ASTableNode, ASTableDelegate> {
        return RxTableNodeDelegateProxy.proxy(for: base)
    }
    
    /// Reactive wrapper for `contentOffset`.
    var contentOffset: ControlProperty<CGPoint> {
        let proxy = RxTableNodeDelegateProxy.proxy(for: base)

        let bindingObserver = Binder(self.base) { tableNode, contentOffset in
            tableNode.contentOffset = contentOffset
        }

        return ControlProperty(values: proxy.contentOffsetBehaviorSubject, valueSink: bindingObserver)
    }

    /// Bindable sink for `scrollEnabled` property.
    var isScrollEnabled: Binder<Bool> {
        return Binder(self.base) { tableNode, scrollEnabled in
            tableNode.view.isScrollEnabled = scrollEnabled
        }
    }

    /// Reactive wrapper for delegate method `scrollViewDidScroll`
    var didScroll: ControlEvent<Void> {
        let source = RxTableNodeDelegateProxy.proxy(for: base).contentOffsetPublishSubject
        return ControlEvent(events: source)
    }
    
    /// Reactive wrapper for delegate method `scrollViewWillBeginDecelerating`
    var willBeginDecelerating: ControlEvent<Void> {
        let source = delegate.methodInvoked(#selector(ASTableDelegate.scrollViewWillBeginDecelerating(_:))).map { _ in }
        return ControlEvent(events: source)
    }
    
    /// Reactive wrapper for delegate method `scrollViewDidEndDecelerating`
    var didEndDecelerating: ControlEvent<Void> {
        let source = delegate.methodInvoked(#selector(ASTableDelegate.scrollViewDidEndDecelerating(_:))).map { _ in }
        return ControlEvent(events: source)
    }
    
    /// Reactive wrapper for delegate method `scrollViewWillBeginDragging`
    var willBeginDragging: ControlEvent<Void> {
        let source = delegate.methodInvoked(#selector(ASTableDelegate.scrollViewWillBeginDragging(_:))).map { _ in }
        return ControlEvent(events: source)
    }
    
    /// Reactive wrapper for delegate method `scrollViewWillEndDragging(_:withVelocity:targetContentOffset:)`
    var willEndDragging: ControlEvent<ASDKWillEndDraggingEvent> {
        let source = delegate.methodInvoked(#selector(ASTableDelegate.scrollViewWillEndDragging(_:withVelocity:targetContentOffset:)))
            .map { value -> ASDKWillEndDraggingEvent in
                let velocity = try ASDKCastOrThrow(CGPoint.self, value[1])
                let targetContentOffsetValue = try ASDKCastOrThrow(NSValue.self, value[2])

                guard let rawPointer = targetContentOffsetValue.pointerValue else { throw RxCocoaError.unknown }
                let typedPointer = rawPointer.bindMemory(to: CGPoint.self, capacity: MemoryLayout<CGPoint>.size)

                return (velocity, typedPointer)
            }
        return ControlEvent(events: source)
    }
    
    /// Reactive wrapper for delegate method `scrollViewDidEndDragging(_:willDecelerate:)`
    var didEndDragging: ControlEvent<Bool> {
        let source = delegate.methodInvoked(#selector(ASTableDelegate.scrollViewDidEndDragging(_:willDecelerate:))).map { value -> Bool in
            return try ASDKCastOrThrow(Bool.self, value[1])
        }
        return ControlEvent(events: source)
    }

    /// Reactive wrapper for delegate method `scrollViewDidZoom`
    var didZoom: ControlEvent<Void> {
        let source = delegate.methodInvoked(#selector(ASTableDelegate.scrollViewDidZoom)).map { _ in }
        return ControlEvent(events: source)
    }

    /// Reactive wrapper for delegate method `scrollViewDidScrollToTop`
    var didScrollToTop: ControlEvent<Void> {
        let source = delegate.methodInvoked(#selector(ASTableDelegate.scrollViewDidScrollToTop(_:))).map { _ in }
        return ControlEvent(events: source)
    }
    
    /// Reactive wrapper for delegate method `scrollViewDidEndScrollingAnimation`
    var didEndScrollingAnimation: ControlEvent<Void> {
        let source = delegate.methodInvoked(#selector(ASTableDelegate.scrollViewDidEndScrollingAnimation(_:))).map { _ in }
        return ControlEvent(events: source)
    }
    
    /// Reactive wrapper for delegate method `scrollViewWillBeginZooming(_:with:)`
    var willBeginZooming: ControlEvent<ASDisplayNode?> {
        let source = delegate.methodInvoked(#selector(ASTableDelegate.scrollViewWillBeginZooming(_:with:))).map { value -> ASDisplayNode? in
            return try ASDKCastOptionalOrThrow(ASDisplayNode.self, value[1] as AnyObject)
        }
        return ControlEvent(events: source)
    }
    
    /// Reactive wrapper for delegate method `scrollViewDidEndZooming(_:with:atScale:)`
    var didEndZooming: ControlEvent<ASDKEndZoomEvent> {
        let source = delegate.methodInvoked(#selector(ASTableDelegate.scrollViewDidEndZooming(_:with:atScale:))).map { value -> ASDKEndZoomEvent in
            return (try ASDKCastOptionalOrThrow(ASDisplayNode.self, value[1] as AnyObject), try ASDKCastOrThrow(CGFloat.self, value[2]))
        }
        return ControlEvent(events: source)
    }

    /// Installs delegate as forwarding delegate on `delegate`.
    /// Delegate won't be retained.
    ///
    /// It enables using normal delegate mechanism with reactive delegate mechanism.
    ///
    /// - parameter delegate: Delegate object.
    /// - returns: Disposable object that can be used to unbind the delegate.
    func setDelegate(_ delegate: ASTableDelegate)
        -> Disposable {
        return RxTableNodeDelegateProxy.installForwardDelegate(delegate, retainDelegate: false, onProxyForObject: self.base)
    }
}
