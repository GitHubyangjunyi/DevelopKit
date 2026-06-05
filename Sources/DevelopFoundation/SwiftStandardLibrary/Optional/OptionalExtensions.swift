//
//  OptionalExtensions.swift
//  DevelopKit
//
//  Created by 杨俊艺 on 2026/6/4.
//

import Foundation

/// 解包相关
public extension Optional {
	
	/// 无效
	var isNone: Bool {
		!isValid
	}
	/// 有效
	var isValid: Bool {
		switch self {
		case .none:
			false
		case .some:
			true
		}
	}
	
	/// 转换为Any类型
	var asAny: Any {
		self as Any
	}
	
	/// 过滤指定条件
	/// - Parameter predicate: 过滤条件
	/// - Returns: 满足指定条件的结果
	func filter(_ predicate: (Wrapped) -> Bool) -> Wrapped? {
		guard let unwrapped = self, predicate(unwrapped) else { return nil }
		return unwrapped
	}
	
	/// 如果不为空则以解包后的值作为入参执行闭包
	/// - Parameter execute: 回调闭包
	/// - Parameter failed: 失败回调 | 因为Optional类型的closure会被推断为@escaping closure, 所以这里不能使用SimpleCallback?类型作为失败的回调
	/// - Returns: Optional<Wrapped>
	@discardableResult
	func unwrap(execute: (Wrapped) throws -> Void, failed: () -> Void = { }) rethrows -> Wrapped? {
		switch self {
		case .none:
			failed()
			return nil
		case .some(let wrapped):
			try execute(wrapped)
			return wrapped
		}
	}
	
	/// 解包Optional类型
	/// - Parameter error: 解包失败时抛出的错误
	/// - Returns: 解包成功后返回Wrapped
	func unwrap(failed error: Error) throws -> Wrapped {
		guard let self else {
			throw error
		}
		return self
	}
	
	/// 返回可选值或 `else` 表达式返回的值
	/// 例如. optional.or(else: Selector)
	func or(else: @autoclosure () -> Wrapped) -> Wrapped {
		return self ?? `else`()
	}
	
	/// 解包
	/// - Parameters:
	///   - defaultValue: 默认值
	///   - transform: 转换闭包
	/// - Returns: 转换后的值
	/// 注: 和上面的unwrap方法作用一样, 但是在将尾随闭包作为转换回调时可以使代码看起来更清晰. 如:
	/// let num: Int? = 0
	/// num.or("") { num in
	///     num.string
	/// }
	func or<T>(_ fallback: @autoclosure () -> T, map transform: (Wrapped) -> T) -> T {
		guard let self else {
			return fallback()
		}
		return transform(self)
	}
	
	/// 解包Optional
	/// - Parameter fallback: 解包失败使用的默认值
	/// - Returns: Wrapped Value
	func or(_ fallback: @autoclosure () -> Wrapped) -> Wrapped {
		self ?? fallback()
	}
	
	func or(_ fallback: @autoclosure () -> Wrapped?) -> Wrapped? {
		self ?? fallback()
	}
	
	mutating func setIfNil(_ value: @autoclosure () -> Wrapped) {
		if self == nil {
			self = value()
		}
	}
}

public extension Optional where Wrapped: Sequence & ExpressibleByArrayLiteral {
	var orEmpty: Wrapped {
		or(.empty)
	}
}
