//
//  UILayoutConstraint.swift
//  DevelopKit
//
//  Created by 杨俊艺 on 2026/6/6.
//

import UIKit
import DevelopFoundation

public struct UILayoutConstraint {
	
	public let constant: Double
	public let priority: UILayoutPriority
	
	public init(constant: Double, priority: UILayoutPriority) {
		self.constant = constant
		self.priority = priority
	}
}

public extension CGFloat {
	public var constraint: UILayoutConstraint {
		constraint(priority: .required)
	}
	
	public func constraint(priority: UILayoutPriority) -> UILayoutConstraint {
		UILayoutConstraint(constant: self, priority: priority)
	}
}

public extension Double {
	public var constraint: UILayoutConstraint {
		constraint(priority: .required)
	}
	
	public func constraint(priority: UILayoutPriority) -> UILayoutConstraint {
		UILayoutConstraint(constant: self, priority: priority)
	}
}

public extension Int {
	public var constraint: UILayoutConstraint {
		constraint(priority: .required)
	}
	
	public func constraint(priority: UILayoutPriority) -> UILayoutConstraint {
		UILayoutConstraint(constant: Double(self), priority: priority)
	}
}

extension UILayoutPriority: ExpressibleByFloatLiteral {
	public typealias FloatLiteralType = Float
	
	public init(floatLiteral value: FloatLiteralType) {
		self.init(rawValue: value)
	}
}

extension UILayoutPriority: ExpressibleByIntegerLiteral {
	public typealias IntegerLiteralType = Int
	
	public init(integerLiteral value: IntegerLiteralType) {
		self.init(rawValue: value.float)
	}
}
