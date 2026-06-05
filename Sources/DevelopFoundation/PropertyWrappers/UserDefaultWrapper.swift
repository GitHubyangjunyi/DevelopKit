//
//  UserDefaultWrapper.swift
//  DevelopKit
//
//  Created by 杨俊艺 on 2026/6/4.
//

import Foundation

@propertyWrapper
public struct UserDefault<T> {
	
	///这里的属性key 和 defaultValue 还有init方法都是实际业务中的业务代码
	let key: String
	let defaultValue: T
	
	/// wrappedValue是@propertyWrapper必须要实现的属性，当操作我们要包裹的属性时其具体set get方法实际上走的都是wrappedValue 的set get 方法
	public var wrappedValue: T {
		get {
			UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
		}
		set {
			UserDefaults.standard.set(newValue, forKey: key)
		}
	}
	
	public init(_ key: String, defaultValue: T) {
		self.key = key
		self.defaultValue = defaultValue
	}
}
