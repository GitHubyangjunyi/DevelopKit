//
//  BinaryInteger.swift
//  DevelopKit
//
//  Created by 杨俊艺 on 2026/6/6.
//

import Foundation

public extension BinaryInteger {
	
	// MARK: -- 转为 Bool
	var isZero: Bool {
		self == 0
	}
	
	var isNegative: Bool {
		self < 0
	}
	
	var isPositive: Bool {
		self > 0
	}
	
	var bool: Bool {
		self > 0 ? true : false
	}
	
	// MARK: -- 转为 Int
	/// 索引转换成序号
	var number: Int {
		Swift.min(Int(self) + 1, .max)
	}
	
	/// 转换成索引值
	var index: Int {
		Int(Swift.max(self - 1, 0))
	}
	
	var half: Int {
		Int(self / 2)
	}
	
	var int: Int {
		return Int(self)
	}
	
	var toABS: Int {
		return abs(Int(self))
	}
	
	/// 返回当前值减1后的结果（最小为0）
	var decrementedByOne: Int {
		return Int(max(self - 1, 0))
	}
	
	/// 返回当前值加1后的结果
	var incrementedByOne: Int {
		return Int(self + 1)
	}
	
	// MARK: -- 转为 String
	var string: String {
		String(self)
	}
	
	/// 将整数格式化为0.xxxx格式的字符串
	var fourDigitString: String {
		return String(format: "%04d", Int(self))
	}
	
	/// 格式化为 HH:MM:SS 时间字符串
	var formattedTimeInterval: String {
		let seconds = Int(self)
		let hours = seconds / 3600
		let minutes = (seconds % 3600) / 60
		let secs = (seconds % 3600) % 60
		return String(format: "%02d:%02d:%02d", hours, minutes, secs)
	}
	
	/// 返回十六进制表示（不带 `0x` 前缀）
	var hexString: String {
		return String(format: "%X", Int(self))
	}
	
	// MARK: -- 转为 无符号类型
	
	var uint8: UInt8 {
		UInt8(self)
	}
	
	var int16: Int16 {
		Int16(self)
	}
	
	var uint16: UInt16 {
		UInt16(self)
	}
	
	// MARK: -- 转为其他
	var cgFloat: CGFloat {
		CGFloat(self)
	}
	
	var float: Float {
		Float(self)
	}
	
	var double: Double {
		Double(self)
	}
	
	///  转换高低字节对
	var bytePair: (high: UInt8, low: UInt8) {
		return (high: UInt8((self >> 8) & 0xFF), low: UInt8(self & 0xFF))
	}
}
