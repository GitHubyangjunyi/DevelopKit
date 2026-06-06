//
//  GDCompatible.swift
//  DevelopKit
//
//  Created by 杨俊艺 on 2026/6/6.
//

import Foundation

public struct GD<Base> {
	public let base: Base
	
	public init(_ base: Base) {
		self.base = base
	}
}

/// 扩展的命名空间
public protocol GDCompatible { }

public extension GDCompatible {
	public static var gd: GD<Self>.Type {
		get { GD<Self>.self }
		set { }
	}
	
	public var gd: GD<Self> {
		get { GD(self) }
		set { }
	}
}
