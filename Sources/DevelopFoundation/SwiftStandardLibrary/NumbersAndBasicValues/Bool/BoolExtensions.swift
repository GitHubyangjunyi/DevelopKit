//
//  BoolExtensions.swift
//  DevelopKit
//
//  Created by 杨俊艺 on 2026/6/4.
//

import Foundation

public extension Bool {
	
	var string: String {
		return self ? "1" : "0"
	}
	
	var int: Int {
		return self ? 1 : 0
	}
	
	var uint8: UInt8 {
		return self ? 0x01 : 0x00
	}
	
	var isTrue: Bool {
		self == true
	}
	
	var isFalse: Bool {
		self == false
	}
	
	var toggled: Bool {
		!self
	}
}
