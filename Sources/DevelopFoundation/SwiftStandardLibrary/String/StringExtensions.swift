//
//  StringExtensions.swift
//  DevelopKit
//
//  Created by 杨俊艺 on 2026/6/4.
//

import Foundation

public extension String {
	var characterSet: CharacterSet {
		CharacterSet(charactersIn: self)
	}
	
	/// base64 解码
	var base64Decode: String? {
		guard let data = Data(base64Encoded: self) else { return nil }
		return String(data: data, encoding: .utf8)
	}
	
	/// base64 编码
	var base64Encode: String {
		return Data(utf8).base64EncodedString()
	}
	
	static var randomUUID: String {
		UUID().uuidString
	}
}
