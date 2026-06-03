//
//  CollectionsTests.swift
//  DevelopKit
//
//  Created by 杨俊艺 on 2026/6/3.
//

@testable import DevelopFoundation
import Testing

struct CollectionsTests {
	@Test func test() {
		#expect([].isNotEmpty == false)
		#expect([1, 2, 3].isNotEmpty)
	}
}
