//
//  DispatchResult.swift
//  Common
//
//  Created by Sun on 2021/12/15.
//  Copyright © 2021 TheBoring. All rights reserved.
//

import RxSwift

public enum DispatchResult {
    case dealt // 内部处理完成, 这种情况除非没有 viewController 返回, 否则用 preprocess 替代
    case recognized(viewController: UIViewController?) // 返回 viewController 给外部处理
    case preprocess(preHandler: (() -> PublishSubject<Bool>), viewController: UIViewController?) // 预处理的方式
    case unrecognized  // 不能识别
    case recognizeExcepted // 识别成功, 但由于参数或者其他问题处理异常
}
