//
//  SetExtensions.swift
//  DevelopKit
//
//  Created by 杨俊艺 on 2026/6/3.
//

import Foundation

public extension Set {
	
	/// 更新Set数据，如果存在则删除，不存在则添加
	/// - Parameter member: 数据
	mutating func toggle(_ member: Element) {
		if contains(member) {
			remove(member)
		} else {
			insert(member)
		}
	}
}
