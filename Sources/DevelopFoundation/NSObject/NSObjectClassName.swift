//
//  NSObjectClassName.swift
//  DevelopKit
//
//  Created by 杨俊艺 on 2026/6/4.
//

import Foundation

#if os(iOS) || os(tvOS)
public extension NSObject {
	var className: String {
		return type(of: self).className
	}
	
	static var className: String {
		let name = String(describing: self)
		return String(name.split(separator: ".").last!)
	}
}

#endif
