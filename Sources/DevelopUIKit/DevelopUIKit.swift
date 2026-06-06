//
//  DevelopUIKit.swift
//  DevelopKit
//
//  Created by 杨俊艺 on 2026/6/6.
//

import UIKit

extension UIRectCorner: @retroactive CaseIterable {
	public static let allCases: [UIRectCorner] = [
		.topLeft, .topRight, .bottomLeft, .bottomRight
	]
}

public extension CACornerMask {
	public static var topLeft: CACornerMask {
		.layerMinXMinYCorner
	}
	
	public static var topRight: CACornerMask {
		.layerMaxXMinYCorner
	}
	
	public static var bottomLeft: CACornerMask {
		.layerMinXMaxYCorner
	}
	
	public static var bottomRight: CACornerMask {
		.layerMaxXMaxYCorner
	}
	
	public static var allCorners: CACornerMask {
		[
			.layerMinXMinYCorner,
			.layerMaxXMinYCorner,
			.layerMinXMaxYCorner,
			.layerMaxXMaxYCorner
		]
	}
}

extension UIRectCorner {
	/// UIRectCorner 转换成 CACornerMask
	public var caCornerMask: CACornerMask {
		Self.allCases
			.filter(contains)
			.map(\.rawValue)
			.map(CACornerMask.init)
			.reduce(CACornerMask()) { result, item in
				result.union(item)
			}
	}
}
