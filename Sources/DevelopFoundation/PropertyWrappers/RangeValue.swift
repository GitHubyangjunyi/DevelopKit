//
//  RangeValue.swift
//  DevelopKit
//
//  Created by 杨俊艺 on 2026/6/4.
//

import Foundation

@propertyWrapper
public struct RangeValue<T: Comparable> {
	
	private var number: T
	private let range: ClosedRange<T>
	
	public var wrappedValue: T {
		get { number }
		set {
			if newValue > range.upperBound {
				number = range.upperBound
			} else if newValue < range.lowerBound {
				number = range.lowerBound
			} else {
				number = newValue
			}
		}
	}
	
	public init(wrappedValue: T, range: ClosedRange<T>) {
		self.number = wrappedValue
		self.range = range
	}
}
