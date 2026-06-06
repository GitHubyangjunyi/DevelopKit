//
//  BidirectionalCollectionExtensions.swift
//  DevelopKit
//
//  Created by 杨俊艺 on 2026/6/6.
//

import Foundation

public extension BidirectionalCollection {
	/// 最后一个合法的Index | 如数组[1, 2, 3].lastIndex == 2 | 空数组 [Int]().lastIndex == -1
	/// 注: 空的Range(例如: 0..<0)不要调用这个方法, 否则会崩溃, 使用maybeLastIndex替换
	var lastIndex: Index {
		index(before: endIndex)
	}
}
