//
//  Sink.swift
//  DevelopKit
//
//  Created by 杨俊艺 on 2026/6/6.
//

import Foundation
import RxSwift

/// 方法转换
/// - Parameter output: 默认返回值
/// - Returns: A Closure which will return the output by default.
public func sink<In, Out>(_ output: Out) -> (In) -> Out {
	{ _ in output }
}

public func sink<In>(_ simpleCallBack: @escaping () -> Void) -> (In) -> Void {
	{ _ in simpleCallBack() }
}
