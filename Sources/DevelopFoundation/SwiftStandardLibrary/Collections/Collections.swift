//
//  Collections.swift
//  DevelopKit
//
//  Created by 杨俊艺 on 2026/6/3.
//

import Foundation

public extension Collection {
	var isNotEmpty: Bool {
		!isEmpty
	}
	
	/// 如果集合不为空，则返回集合本身，否则返回 nil
	var filledOrNil: Self? {
		isEmpty ? nil : self
	}
}
