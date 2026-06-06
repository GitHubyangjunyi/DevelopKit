//
//  UIDeviceExtensions.swift
//  DevelopKit
//
//  Created by 杨俊艺 on 2026/6/6.
//

import UIKit

public extension UIDevice {
	
	/// 当前设备的系统版本
	static var currentSystemVersion: String {
		return current.systemVersion
	}
	
	/// 当前系统更新时间
	static var systemUptime: Date {
		let time = ProcessInfo.processInfo.systemUptime
		return Date(timeIntervalSinceNow: 0 - time)
	}
	
	/// 当前设备的类型
	static var deviceType: String {
		return UIDevice.current.model
	}
	
	/// 当前系统的名称
	static var currentSystemName: String {
		return UIDevice.current.systemName
	}
	
	/// 当前设备的名称
	static var currentDeviceName : String {
		get {
			return UIDevice.current.name
		}
	}
	
	/// 当前硬盘的空间
	static var diskSpace: Int64 {
		if let attrs = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory()) {
			if let space: NSNumber = attrs[FileAttributeKey.systemSize] as? NSNumber {
				if space.int64Value > 0 {
					return space.int64Value
				}
			}
		}
		return -1
	}
	
	/// 当前硬盘可用空间
	static var diskSpaceFree: Int64 {
		if let attrs = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory()) {
			if let space: NSNumber = attrs[FileAttributeKey.systemFreeSize] as? NSNumber {
				if space.int64Value > 0 {
					return space.int64Value
				}
			}
		}
		return -1
	}
	
	/// 当前硬盘已经使用的空间
	static var diskSpaceUsed: Int64 {
		let total = self.diskSpace
		let free = self.diskSpaceFree
		guard total > 0 && free > 0 else { return -1 }
		let used = total - free
		guard used > 0 else { return -1 }
		return used
	}
	
	/// 获取总内存大小
	static var memoryTotal: UInt64 {
		return ProcessInfo.processInfo.physicalMemory
	}
	
	/// 当前设备能否打电话
	/// - Returns: 结果
	static func isCanCallTel() -> Bool {
		if let url = URL(string: "tel://") {
			return UIApplication.shared.canOpenURL(url)
		}
		return false
	}
	
	/// 当前App的语言
	static var appLanguage: String {
		return Bundle.main.preferredLocalizations[0]
	}
	
	/// 当前设备语言
	static var deviceLanguage: String? {
		return Locale.preferredLanguages.first
	}
	
	/// 获取最高刷新率
	static var maximumFramesPerSecond: Int {
		return UIScreen.main.maximumFramesPerSecond
	}
	
	/// 获取设备是否是省电模式
	static var isLowPowerMode: Bool {
		return ProcessInfo.processInfo.isLowPowerModeEnabled
	}
	
	/// 获取屏幕亮度比例
	static var brightnessRatio: CGFloat {
		return UIScreen.main.brightness
	}
}
