//
//  CharacterSetExtensions.swift
//  DevelopKit
//
//  Created by 杨俊艺 on 2026/6/6.
//

import Foundation

extension CharacterSet: @retroactive ExpressibleByStringLiteral {
	public typealias StringLiteralType = String
	
	public init(stringLiteral value: StringLiteralType) {
		self.init(charactersIn: value)
	}
}

public extension CharacterSet {
	static func + (lhs: CharacterSet, rhs: CharacterSet) -> CharacterSet {
		lhs.union(rhs)
	}
	
	static func + (lhs: String, rhs: CharacterSet) -> CharacterSet {
		lhs.characterSet.union(rhs)
	}
	
	static func + (lhs: CharacterSet, rhs: String) -> CharacterSet {
		lhs.union(rhs.characterSet)
	}
	
	static func ~= (lhs: Character, rhs: CharacterSet) -> Bool {
		rhs.contains(lhs)
	}
	
	/// 检查字符是否存在于字符集中
	/// - Parameter character: 字符
	/// - Returns: 是否包含
	func contains(_ character: Character) -> Bool {
		character.unicodeScalars.allSatisfy(contains)
	}
	
	/// 十六进制字符集(包含大小写)
	static let hexadecimal = hexadecimalUppercase + hexadecimalLowercase
	
	/// 十六进制字符集(小写)
	static let hexadecimalLowercase = CharacterSet(charactersIn: "0123456789abcdef")
	
	/// 十六进制字符集(大写)
	static let hexadecimalUppercase = CharacterSet(charactersIn: "0123456789ABCDEF")
	
	/// 阿拉伯数字 | 0-9
	static let arabicNumbers = CharacterSet(charactersIn: "0123456789")
	
	/// 点 | 小数点 | 英文句号
	static let dot = CharacterSet(charactersIn: ".")
	
	/// 整数(正整数\0\负整数) | 阿拉伯数字 + 负号("-")
	static let integer = arabicNumbers.union("-")
	
	/// 非负实数(0\正整数\正小数) | 阿拉伯数字 + 小数点
	static let nonNegativeRealNumber = arabicNumbers.union(.dot)
	
	/// 实数 | 阿拉伯数字 + 小数点 + 负号("-")
	static let realNumber = nonNegativeRealNumber.union("-")
	
	/// 英文字母（大小写）+ 阿拉伯数字 + 连字符 "-"
	static let alphanumericWithHyphen = CharacterSet.letters
		.union(.arabicNumbers)
		.union(CharacterSet(charactersIn: "-"))
}
