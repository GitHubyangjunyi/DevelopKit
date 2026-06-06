//
//  DataExtensions.swift
//  DevelopKit
//
//  Created by 杨俊艺 on 2026/6/6.
//

import Foundation

public extension Data {
	/// 编码
	var encodeToData: Data? {
		return base64EncodedData()
	}
	
	/// 解码成 Data
	var decodeToDada: Data? {
		return Data(base64Encoded: self)
	}
	
	/// 转成bytes
	var bytes: [UInt8] {
		return [UInt8](self)
	}
	
	/// Data转16进制的字符串
	/// - Parameter data: data
	/// - Returns: 16进制的字符串
	var hexString: String? {
		let data = self
		let dataBuffer = [UInt8](data)
		let dataLength = data.count
		var hexString = ""
		for i in 0..<dataLength {
			hexString += String(format: "%02lx", dataBuffer[i])
		}
		return hexString
	}
	
	/// 转换为String
	var string: String? {
		return String(data: self, encoding: .utf8)
	}
	
	/// 转换为Dictionary
	var dictionary: Dictionary<String, Any>? {
		do {
			return try JSONSerialization.jsonObject(with: self, options: .mutableContainers) as? Dictionary<String, Any>
		} catch  {
			return nil
		}
	}
	
	/// 转换为方便查看的字符串
	var easilyHexString: String {
		return  "\n原数数据：" + map { String(format: "%02x", $0) }.joined(separator: "") +
		"\n十进制：" + stringWithIndices +
		"\n字节位：" + hexStringWithIndices
	}
	
	//MARK: -- private私有的
	/// 十六进制标记当前位
	private var hexStringWithIndices: String {
		var index = 0
		let hexStrings = map { byte -> String in
			defer { index += 1 }
			return "byte\(index)：\(String(format: "0x%02x", byte))"
		}
		return hexStrings.joined(separator: "|")
	}
	
	/// 十进制
	private var stringWithIndices: String {
		var index = 0
		let hexStrings = map { byte -> String in
			defer { index += 1 }
			return "第\(index)位：\(byte)"
		}
		return hexStrings.joined(separator: "|")
	}
}

public extension Data {
	static func getBytes(from data: Data, range: Range<Data.Index>) -> UInt8 {
		guard range.lowerBound >= 0, range.upperBound <= data.count else { return 0x00 }
		var byte: UInt8 = 0
		data.copyBytes(to: &byte, from: range)
		return byte
	}
	
	static func toInt(highByte: UInt8, lowByte: UInt8) -> Int {
		let highPart = Int(highByte) << 8
		let lowPart = Int(lowByte)
		let combinedValue = highPart | lowPart
		return combinedValue
	}
	/// 转16位有符号整数
	static func toInt16(highByte: UInt8, lowByte: UInt8) -> Int {
		let highPart = Int16(highByte) << 8
		let lowPart = Int16(lowByte)
		let combinedValue = highPart | lowPart
		return Int(combinedValue)
	}
}

public extension Data {
	/// 获取二进制文件的后缀
	var fileExtension: String? {
		guard count >= 8 else { return nil }
		let header = prefix(1).map { $0 }
		switch header {
		case [0x89]: return "png"
		case [0xFF]: return "jpeg"
		case [0x47]: return "gif"
		case [0x25]: return "pdf"  // PDF
		case [0x50]: return "zip"  // ZIP
		default: return nil
		}
	}
}
