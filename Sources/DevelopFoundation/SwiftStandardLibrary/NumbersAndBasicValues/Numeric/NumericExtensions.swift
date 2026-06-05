//
//  NumericExtensions.swift
//  DevelopKit
//
//  Created by 杨俊艺 on 2026/6/4.
//

import Foundation

// MARK: -- 遵循 Numeric 的类型都可以在这里添加计算扩展
/// 整数类型：Int, Int8, Int16, Int32, Int64
/// 无符号整数：UInt, UInt8, UInt16, UInt32, UInt64
/// 浮点数：Float, Double, CGFloat
public extension Numeric {
	
	/// 当前数据*100
	var x100: Self {
		return self * 100
	}
	
	var xdouble: Self {
		return self * 2
	}
	
	/// 求和
	func sum<T: Numeric>(_ numbers: [T]) -> T {
		return numbers.reduce(.zero, +)
	}
	
	/// 乘法
	func multiply<T: Numeric>(_ a: T, _ b: T) -> T {
		return a * b
	}
}
