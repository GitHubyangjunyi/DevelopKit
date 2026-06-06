//
//  UIResponderViewController.swift
//  DevelopKit
//
//  Created by 杨俊艺 on 2026/6/6.
//

import UIKit

public extension UIResponder {
	/// 获取Parent控制器
	/// - Parameter type: 控制器类型
	/// - Returns: 匹配的控制器
	func parentController<Controller: UIViewController>(_ type: Controller.Type) -> Controller? {
		var nextResponder = next
		while let controller = nextResponder {
			if let valid = controller as? Controller {
				return valid
			}
			nextResponder = controller.next
		}
		return nextResponder as? Controller
	}
	
	/// 查找符合特定协议类型的 UIViewController
	/// - Parameter ofType: 协议类型
	/// - Returns: 匹配的控制器
	func findViewController<T>(ofType protocolType: T.Type) -> T? {
		var responder: UIResponder? = self
		while let current = responder {
			if let vc = current as? UIViewController, let target = vc as? T {
				return target
			}
			responder = current.next
		}
		return nil
	}
}
