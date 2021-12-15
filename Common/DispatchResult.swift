//
//  DispatchResult.swift
//  Common
//
//  Created by Sun on 2021/12/15.
//  Copyright © 2021 TheBoring. All rights reserved.
//

import RxSwift

public enum DispatchResult {
    case dealCompleted // 内部处理完成，这种情况除非没有vc返回，否则不要用，用preDeal替代
    case success(vc: UIViewController?) // 返回 vc 给外部处理
    case preDeal(preHandler: (() -> PublishSubject<Bool>), vc: UIViewController?) //预处理的方式
    case unrecognize  // 不能识别
    case temp // 之后全部换成preDeal的方式
    case recognizeDealExcept // 识别成功，但由于参数或者其他问题处理异常
}
