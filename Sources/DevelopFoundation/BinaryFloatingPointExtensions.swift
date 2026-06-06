//
//  BinaryFloatingPointExtensions.swift
//  DevelopKit
//
//  Created by 杨俊艺 on 2026/6/6.
//

import Foundation

// MARK: - 所有浮点型的扩展，Float/CGFloat/Double
public extension BinaryFloatingPoint {
	/// 将浮点数转换为 Int 类型 ⚠️：如果当前浮点数不在Int的范围内，那么只能转换为Int的max或者min
	var int: Int {
		// 将 Self 转换为 Double 进行范围检查
		let value = Double(self)
		// 检查值是否在 Int 的可表示范围内
		if value < Double(Int.min) {
			return Int.min // 或者根据需求返回其他值
		} else if value > Double(Int.max) {
			return Int.max // 或者根据需求返回其他值
		} else {
			return Int(self)
		}
	}
	
	/// 向上取整的计算属性
	var ceiling: Self {
		return ceil(self)
	}
	
	/// 向上取整并转换为 Int 类型
	var ceilingInt: Int {
		return Int(ceil(self))
	}
	
	/// 返回当前值的一半
	/// - Returns: 与原类型相同的浮点数
	var half: Self {
		self / 2.0
	}
	/// 将浮点数转换为字符串
	/// 默认保留一位小数
	var string: String {
		return String(format: "%.1f", Double(self))
	}
	
	var float: Float {
		return Float(self)
	}
	
	var cgFloat: CGFloat {
		return CGFloat(self)
	}
	
	var double: Double {
		return Double(self)
	}
	
	var toRounded: Float {
		return Float(self.rounded())
	}
	
	var division100: CGFloat {
		return CGFloat(self/100.0)
	}
	
	/// 返回当前值的绝对值
	var abs: CGFloat {
		return CGFloat(Swift.abs(self))
	}
	
	/// 将浮点数截取到指定小数位数（不进行四舍五入）
	/// - Parameter decimals: 要保留的小数位数
	/// - Returns: 格式化后的字符串
	func truncatedString(decimals: Int = 1) -> String {
		guard decimals >= 0 else { return "\(self)" }
		let multiplier = pow(10, Float(decimals))
		let truncated = Float(Int(Float(self) * multiplier)) / multiplier
		// 如果结果是整数，添加 .0
		if truncated.truncatingRemainder(dividingBy: 1) == 0 {
			return String(format: "%.\(decimals)f", truncated)
		}
		return "\(truncated)"
	}
}
