//
//  UUIDExtensions.swift
//  DevelopKit
//
//  Created by 杨俊艺 on 2026/6/4.
//

import Foundation

public extension UUID {
	
	/// 快捷新增UUID
	static var new: UUID {
		return UUID()
	}
	
	/// 快速获取UUID类型的字符串
	static var string: String {
		return UUID.new.uuidString
	}
}
