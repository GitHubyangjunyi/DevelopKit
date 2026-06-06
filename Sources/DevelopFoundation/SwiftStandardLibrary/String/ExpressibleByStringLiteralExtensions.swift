//
//  ExpressibleByStringLiteralExtensions.swift
//  DevelopKit
//
//  Created by 杨俊艺 on 2026/6/6.
//

import Foundation

public extension ExpressibleByStringLiteral {
	/// 字符串转 Bool
	var bool: Bool {
		switch (self as! String).lowercased() {
		case "true", "t", "yes", "y", "1":
			return true
		case "false", "f", "no", "n", "0":
			return false
		default:
			return false
		}
	}
	
	/// 字符串转 Int
	var int: Int? {
		guard let doubleValue = Double(self as! String) else { return nil }
		return Int(doubleValue)
	}
	
	/// 字符串转 Int64
	var int64: Int64 {
		guard let doubleValue = Double(self as! String) else { return 0 }
		return Int64(doubleValue)
	}
	
	/// 字符串 转 CGFloat
	var cgFloat: CGFloat? {
		if let doubleValue = Double(self as! String) {
			return CGFloat(doubleValue)
		}
		return nil
	}
	
	/// 字符串转 toFloat
	var float: Float {
		if let num = NumberFormatter().number(from: self as! String) {
			return num.floatValue
		}
		return 0.0
	}
	
	/// 字符串转Double
	var double: Double? {
		if let num = NumberFormatter().number(from: self as! String) {
			return num.doubleValue
		}
		return nil
	}
	
	/// 字符串转Dictionary
	var dictionary: [String: Any]? {
		guard let data = (self as! String).data(using: .utf8),
			  let dict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
		else {
			return nil
		}
		return dict
	}
	/// URL中有中文的转码
	var transcoding: String {
		return (self as! String).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
	}
	
	var url: URL? {
		URL(string: self as! String)
	}
}
