//
//  RxAsyncDisplayKit.swift
//  WeChat
//
//  Created by Sun on 2021/12/26.
//  Copyright © 2021 TheBoring. All rights reserved.
//

import RxSwift
import RxCocoa
import AsyncDisplayKit

typealias WillDisplayNodeEvent = (ASCellNode)
typealias DidEndDisplayingNodeEvent = (ASCellNode)

/// Swift does not implement abstract methods. This method is used as a runtime check to ensure that methods which intended to be abstract (i.e., they should be implemented in subclasses) are not called directly on the superclass.
func ASDKRxAbstractMethod(message: String = "Abstract method", file: StaticString = #file, line: UInt = #line) -> Swift.Never {
    ASDKRxFatalError(message, file: file, line: line)
}

func ASDKRxFatalError(_ lastMessage: @autoclosure () -> String, file: StaticString = #file, line: UInt = #line) -> Swift.Never {
    // The temptation to comment this line is great, but please don't, it's for your own good. The choice is yours.
    fatalError(lastMessage(), file: file, line: line)
}

func ASDKBindingError(_ error: Swift.Error) {
    let error = "Binding error: \(error)"
#if DEBUG
    ASDKRxFatalError(error)
#else
    print(error)
#endif
}

func ASDKCastOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T {
    guard let returnValue = object as? T else {
        throw RxCocoaError.castingError(object: object, targetType: resultType)
    }

    return returnValue
}

func ASDKCastOptionalOrThrow<T>(_ resultType: T.Type, _ object: AnyObject) throws -> T? {
    if NSNull().isEqual(object) {
        return nil
    }

    guard let returnValue = object as? T else {
        throw RxCocoaError.castingError(object: object, targetType: resultType)
    }

    return returnValue
}

func ASDKCastOrFatalError<T>(_ value: AnyObject!, message: String) -> T {
    let maybeResult: T? = value as? T
    guard let result = maybeResult else {
        ASDKRxFatalError(message)
    }
    
    return result
}

func ASDKCastOrFatalError<T>(_ value: Any!) -> T {
    let maybeResult: T? = value as? T
    guard let result = maybeResult else {
        ASDKRxFatalError("Failure converting from \(String(describing: value)) to \(T.self)")
    }
    
    return result
}
