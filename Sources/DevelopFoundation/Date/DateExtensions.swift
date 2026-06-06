//
//  DateExtensions.swift
//  DevelopKit
//
//  Created by 杨俊艺 on 2026/6/6.
//

import Foundation

public extension Date {
	/// 获取当前 秒级 时间戳 - 10 位
	static var secondStamp: String {
		let timeInterval: TimeInterval = Date().timeIntervalSince1970
		return "\(Int(timeInterval))"
	}
	
	/// 获取当前 毫秒级 时间戳 - 13 位
	static var milliStamp: String {
		let timeInterval: TimeInterval = Date().timeIntervalSince1970
		let millisecond = CLongLong(round(timeInterval*1_000))
		return "\(millisecond)"
	}
	
	/// 获取当前 微秒级 时间戳 - 16 位
	static var microsecondTimestamp: Int64 {
		return Int64(Date().timeIntervalSince1970 * 1_000_000)
	}
}

public extension Date {
	/// 获取当前的时间 Date
	static var now: Date {
		return Date()
	}
	
	/// 从 Date 获取年份
	var year: Int {
		return Calendar.current.component(Calendar.Component.year, from: self)
	}
	
	/// 从 Date 获取年份
	var month: Int {
		return Calendar.current.component(Calendar.Component.month, from: self)
	}
	
	/// 从 Date 获取 日
	var day: Int {
		return Calendar.current.component(.day, from: self)
	}
	
	/// 从 Date 获取 日
	var hour: Int {
		return Calendar.current.component(.hour, from: self)
	}
	
	/// 从 Date 获取 分钟
	var minute: Int {
		return Calendar.current.component(.minute, from: self)
	}
	
	/// 从 Date 获取 秒
	var second: Int {
		return Calendar.current.component(.second, from: self)
	}
	
	/// 从 Date 获取 毫秒
	var nanosecond: Int {
		return Calendar.current.component(.nanosecond, from: self)
	}
	
	/// 从日期获取 星期
	var weekday: String {
		gd_formatter.dateFormat = "EEEE"
		return gd_formatter.string(from: self)
	}
}

public enum TimeBarType {
	// 默认格式，如 9秒：09，66秒：01：06，
	case normal
	case second
	case minute
	case hour
	case day
	case hmss
	
	public var format: String {
		switch self {
		case .normal:
			return "yyyy-MM-dd HH:mm:ss.SSS"
		case .second:
			return "yyyy-MM-dd HH:mm:ss"
		case .minute:
			return "yyyy-MM-dd HH:mm"
		case .hour:
			return "yyyy-MM-dd HH"
		case .day:
			return "yyyy-MM-dd"
		case .hmss:
			return "HH:mm:ss.SSS"
		}
	}
}

public extension Date {
	
	/// 从当前时间获取时间字符串
	/// - Parameter formatType: 时间字符串类型
	/// - Returns: 转换后的时间
	static func timeString(for formatType: TimeBarType = .normal) -> String {
		gd_formatter.dateFormat = formatType.format
		return gd_formatter.string(from: now)
	}
	
	/// 时间戳(支持10位和13位)按照对应的格式 转化为 对应时间的字符串 如：1603849053 按照 "yyyy-MM-dd HH:mm:ss" 转化后为：2020-10-28 09:37:33
	/// - Parameters:
	///   - timestamp: 时间戳
	///   - format: 格式
	/// - Returns: 对应时间的字符串
	static func timestampToTimeString(timestamp: String, formatType: TimeBarType = .normal) -> String {
		let date = timestampToFormatterDate(timestamp: timestamp)
		gd_formatter.dateFormat = formatType.format
		return gd_formatter.string(from: date)
	}
	
	/// 时间戳(支持 10 位 和 13 位) 转 Date
	/// - Parameter timestamp: 时间戳
	/// - Returns: 返回 Date
	static func timestampToFormatterDate(timestamp: String) -> Date {
		guard timestamp.count == 10 ||  timestamp.count == 13 else {
#if DEBUG
			fatalError("时间戳位数不是 10 也不是 13")
#else
			return Date()
#endif
		}
		guard let timestampInt = timestamp.int else {
#if DEBUG
			fatalError("时间戳位有问题")
#else
			return Date()
#endif
		}
		let timestampValue = timestamp.count == 10 ? timestampInt : timestampInt / 1000
		let date = Date(timeIntervalSince1970: TimeInterval(timestampValue))
		return date
	}
	
	/// 根据本地时区转换
	private static func getNowDateFromatAnDate(_ anyDate: Date?) -> Date? {
		// 设置源日期时区
		let sourceTimeZone = NSTimeZone(abbreviation: "UTC")
		// 或GMT
		// 设置转换后的目标日期时区
		let destinationTimeZone = NSTimeZone.local as NSTimeZone
		// 得到源日期与世界标准时间的偏移量
		var sourceGMTOffset: Int? = nil
		if let aDate = anyDate {
			sourceGMTOffset = sourceTimeZone?.secondsFromGMT(for: aDate)
		}
		// 目标日期与本地时区的偏移量
		var destinationGMTOffset: Int? = nil
		if let aDate = anyDate {
			destinationGMTOffset = destinationTimeZone.secondsFromGMT(for: aDate)
		}
		// 得到时间偏移量的差值
		let interval = TimeInterval((destinationGMTOffset ?? 0) - (sourceGMTOffset ?? 0))
		// 转为现在时间
		var destinationDateNow: Date? = nil
		if let aDate = anyDate {
			destinationDateNow = Date(timeInterval: interval, since: aDate)
		}
		return destinationDateNow
	}
	
	/// 秒转换成播放时间条的格式
	/// - Parameters:
	///   - secounds: 秒数
	///   - type: 格式类型
	/// - Returns: 返回时间条
	static func getFormatPlayTime(seconds: Int, type: TimeBarType = .normal) -> String {
		if seconds <= 0 {
			return "00:00"
		}
		// 秒
		let second = seconds % 60
		if type == .second {
			return String(format: "%02d", seconds)
		}
		// 分钟
		var minute = Int(seconds / 60)
		if type == .minute {
			return String(format: "%02d:%02d", minute, second)
		}
		// 小时
		var hour = 0
		if minute >= 60 {
			hour = Int(minute / 60)
			minute = minute - hour * 60
		}
		if type == .hour {
			return String(format: "%02d:%02d:%02d", hour, minute, second)
		}
		// normal 类型
		if hour > 0 {
			return String(format: "%02d:%02d:%02d", hour, minute, second)
		}
		if minute > 0 {
			return String(format: "%02d:%02d", minute, second)
		}
		return String(format: "%02d", second)
	}
}

public extension Date {
	
	/// 今天的日期
	static var todayDate: Date {
		return Date()
	}
	
	/// 昨天的日期
	static var yesterDayDate: Date? {
		return Calendar.current.date(byAdding: DateComponents(day: -1), to: Date())
	}
	
	/// 明天的日期
	static var tomorrowDate: Date? {
		return Calendar.current.date(byAdding: DateComponents(day: 1), to: Date())
	}
	
	/// 前天的日期
	static var theDayBeforYesterDayDate: Date? {
		return Calendar.current.date(byAdding: DateComponents(day: -2), to: Date())
	}
	
	/// 后天的日期
	static var theDayAfterYesterDayDate: Date? {
		return Calendar.current.date(byAdding: DateComponents(day: 2), to: Date())
	}
	
	/// 是否为今天（只比较日期，不比较时分秒）
	/// - Returns: bool
	var isToday: Bool {
		return Calendar.current.isDate(self, inSameDayAs: Date())
	}
	
	/// 是否为昨天
	var isYesterday: Bool {
		guard let date = Self.yesterDayDate else { return false }
		return Calendar.current.isDate(self, inSameDayAs: date)
	}
	
	/// 是否为前天
	var isTheDayBeforeYesterday: Bool  {
		guard let date = Self.theDayBeforYesterDayDate else {
			return false
		}
		return Calendar.current.isDate(self, inSameDayAs: date)
	}
	
	/// 是否为今年
	var isThisYear: Bool  {
		let calendar = Calendar.current
		let nowCmps = calendar.dateComponents([.year], from: Date())
		let selfCmps = calendar.dateComponents([.year], from: self)
		let result = nowCmps.year == selfCmps.year
		return result
	}
	
	/// 是否为  同一年  同一月 同一天
	/// - Returns: bool
	func isSameDay(date: Date) -> Bool {
		return Calendar.current.isDate(self, inSameDayAs: date)
	}
	
	/// 当前日期是不是润年
	var isLeapYear: Bool {
		let year = self.year
		return ((year % 400 == 0) || ((year % 100 != 0) && (year % 4 == 0)))
	}
	
	/// 日期的加减操作
	/// - Parameter day: 天数变化
	/// - Returns: date
	private func adding(day: Int) -> Date? {
		return Calendar.current.date(byAdding: DateComponents(day:day), to: self)
	}
	
	/// 是否为  同一年  同一月 同一天
	/// - Parameter date: date
	/// - Returns: 返回bool
	private func isSameYeaerMountDay(_ date: Date) -> Bool {
		let com = Calendar.current.dateComponents([.year, .month, .day], from: self)
		let comToday = Calendar.current.dateComponents([.year, .month, .day], from: date)
		return (com.day == comToday.day &&
				com.month == comToday.month &&
				com.year == comToday.year )
	}
	
	/// 是否为本周
	/// - Returns: 是否为本周
	var isThisWeek: Bool {
		let calendar = Calendar.current
		// 当前时间
		let nowComponents = calendar.dateComponents([.weekday, .month, .year], from: Date())
		// self
		let selfComponents = calendar.dateComponents([.weekday,.month,.year], from: self as Date)
		return (selfComponents.year == nowComponents.year) && (selfComponents.month == nowComponents.month) && (selfComponents.weekday == nowComponents.weekday)
	}
}

public extension Date {
	
	/// 取得与当前时间的间隔差
	/// - Returns: 时间差
	func callTimeAfterNow() -> String {
		let timeInterval = Date().timeIntervalSince(self)
		if timeInterval < 0 {
			return "刚刚"
		}
		let interval = fabs(timeInterval)
		let i60 = interval / 60
		let i3600 = interval / 3600
		let i86400 = interval / 86400
		let i2592000 = interval / 2592000
		let i31104000 = interval / 31104000
		
		var time:String!
		if i3600 < 1 {
			let s = NSNumber(value: i60 as Double).intValue
			if s == 0 {
				time = "刚刚"
			} else {
				time = "\(s)分钟前"
			}
		} else if i86400 < 1 {
			let s = NSNumber(value: i3600 as Double).intValue
			time = "\(s)小时前"
		} else if i2592000 < 1 {
			let s = NSNumber(value: i86400 as Double).intValue
			time = "\(s)天前"
		} else if i31104000 < 1 {
			let s = NSNumber(value: i2592000 as Double).intValue
			time = "\(s)个月前"
		} else {
			let s = NSNumber(value: i31104000 as Double).intValue
			time = "\(s)年前"
		}
		return time
	}
	
	/// 获取两个日期之间的数据
	/// - Parameters:
	///   - date: 对比的日期
	///   - unit: 对比的类型
	/// - Returns: 两个日期之间的数据
	func componentCompare(from date: Date, unit: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute]) -> DateComponents {
		let calendar = Calendar.current
		let component = calendar.dateComponents(unit, from: date, to: self)
		return component
	}
	
	/// 获取两个日期之间的天数
	/// - Parameter date: 对比的日期
	/// - Returns: 两个日期之间的天数
	func numberOfDays(from date: Date) -> Int? {
		return componentCompare(from: date, unit: [.day]).day
	}
	
	/// 获取两个日期之间的小时
	/// - Parameter date: 对比的日期
	/// - Returns: 两个日期之间的小时
	func numberOfHours(from date: Date) -> Int? {
		return componentCompare(from: date, unit: [.hour]).hour
	}
	
	/// 获取两个日期之间的分钟
	/// - Parameter date: 对比的日期
	/// - Returns: 两个日期之间的分钟
	func numberOfMinutes(from date: Date) -> Int? {
		return componentCompare(from: date, unit: [.minute]).minute
	}
	
	/// 获取两个日期之间的秒数
	/// - Parameter date: 对比的日期
	/// - Returns: 两个日期之间的秒数
	func numberOfSeconds(from date: Date) -> Int? {
		return componentCompare(from: date, unit: [.second]).second
	}
}

public extension Date {
	
	/// 字符串转Date
	/// - Parameters:
	///   - dateString: 字符串
	///   - formatType: 时间格式
	/// - Returns: date
	static func stringToDate(_ dateString: String, formatType: TimeBarType = .normal) -> Date? {
		gd_formatter.dateFormat = formatType.format
		guard let date = gd_formatter.date(from: dateString) else { return nil }
		return date
	}
}

/// 时间戳的类型
public enum TimestampType: Int {
	/// 秒
	case second
	/// 毫秒
	case millisecond
}



/// DateFormatter创建实例很耗时，如果多次创建 DateFormatter 实例，它可能会减慢app 响应速度，甚至更快地耗尽手机电池的电量。
fileprivate let gd_formatter = DateFormatter()

// MARK: - 一、基本扩展
public extension DateFormatter {
	/// 格式化快捷方式
	/// - Parameter format: 格式
	convenience init(format: String) {
		self.init()
		dateFormat = format
	}
}
