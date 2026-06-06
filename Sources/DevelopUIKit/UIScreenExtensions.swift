//
//  UIScreenExtensions.swift
//  DevelopKit
//
//  Created by 杨俊艺 on 2026/6/6.
//

import UIKit
import DevelopFoundation

extension UIScreen: GDCompatible {}

// MARK: - 当前屏幕的宽和高，避免和系统的属性冲突，采用命名空间处理
public extension GD where Base: UIScreen {
	/// 获取屏幕的宽度
	static var width: CGFloat {
		return UIScreen.main.bounds.size.width
	}
	
	/// 获取屏幕的高度
	static var height: CGFloat {
		return UIScreen.main.bounds.size.height
	}
}

public extension UIScreen {
	/// 导航栏高度
	static var navBarHeight: CGFloat {
		return 44.0
	}
	
	/// 底部导航栏高度
	static var tabBarHeight: CGFloat {
		return 49.0
	}
	
	/// 截屏或者录屏通知
	/// - Parameter action: 事件
	static func detectScreenShot(_ action: @escaping (DetectScreenType) -> Void) {
		let mainQueue = OperationQueue.main
		NotificationCenter.default.addObserver(forName: UIApplication.userDidTakeScreenshotNotification, object: nil, queue: mainQueue) { _ in
			action(.shot)
		}
		//如果正在捕获此屏幕（例如，录制、空中播放、镜像等），则为真
		if UIScreen.main.isCaptured {
			action(.record)
		}
		//捕获的屏幕状态发生变化时,会发送UIScreenCapturedDidChange通知,监听该通知
		NotificationCenter.default.addObserver(forName: UIScreen.capturedDidChangeNotification, object: nil, queue: mainQueue) { _ in
			action(.record)
		}
	}
}

public extension UIScreen {
	/// 是否横屏
	public static var isLandscape: Bool {
		return UIApplication.shared.windows.first?.windowScene?.interfaceOrientation.isLandscape ?? false
	}
}

public extension UIScreen {
	enum DetectScreenType {
		/// 截屏
		case shot
		/// 录屏
		case record
	}
}
