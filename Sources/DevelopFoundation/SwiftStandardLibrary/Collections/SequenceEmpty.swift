//
//  SequenceEmpty.swift
//  DevelopKit
//
//  Created by 杨俊艺 on 2026/6/4.
//

import Foundation

public extension Sequence where Self: ExpressibleByArrayLiteral {
	/// 空序列
	static var empty: Self {
		[]
	}
}

public extension Sequence where Self: ExpressibleByDictionaryLiteral {
	/// 空字典
	static var empty: Self {
		[:]
	}
}

public extension Sequence where Self: ExpressibleByStringLiteral {
	/// 空字符串
	static var empty: Self {
		""
	}
}
