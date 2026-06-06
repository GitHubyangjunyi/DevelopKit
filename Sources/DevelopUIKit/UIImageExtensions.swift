//
//  UIImageExtensions.swift
//  DevelopKit
//
//  Created by 杨俊艺 on 2026/6/6.
//

import UIKit
import DevelopFoundation

extension UIImage: GDCompatible { }

public extension GD where Base: UIImage {
	
	/// 设置图片的圆角
	/// - Parameters:
	///   - radius: 圆角大小 (默认:3.0,图片大小)
	///   - corners: 切圆角的方式
	///   - imageSize: 图片的大小
	/// - Returns: 剪切后的图片
	func isRoundCorner(radius: CGFloat = 3, byRoundingCorners corners: UIRectCorner = .allCorners, imageSize: CGSize?) -> UIImage? {
		var drawSize = imageSize ?? base.size
		if drawSize.width <= 0 || drawSize.height <= 0 {
			drawSize = base.size
		}
		// 防止size：(0, 0)崩溃
		if drawSize.width <= 0 || drawSize.height <= 0 {
			drawSize = CGSize(width: 1, height: 1)
		}
		let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: drawSize)
		// 开始图形上下文
		UIGraphicsBeginImageContextWithOptions(drawSize, false, UIScreen.main.scale)
		guard let contentRef: CGContext = UIGraphicsGetCurrentContext() else {
			// 关闭上下文
			UIGraphicsEndImageContext()
			return nil
		}
		// 绘制路线
		contentRef.addPath(UIBezierPath(roundedRect: rect,
										byRoundingCorners: UIRectCorner.allCorners,
										cornerRadii: CGSize(width: radius, height: radius)).cgPath)
		// 裁剪
		contentRef.clip()
		// 将原图片画到图形上下文
		base.draw(in: rect)
		contentRef.drawPath(using: .fillStroke)
		guard let output = UIGraphicsGetImageFromCurrentImageContext() else {
			// 关闭上下文
			UIGraphicsEndImageContext()
			return nil
		}
		// 关闭上下文
		UIGraphicsEndImageContext()
		return output
	}
	
	// MARK: 1.2、设置圆形图片
	/// 设置圆形图片
	/// - Returns: 圆形图片
	func isCircleImage() -> UIImage? {
		return isRoundCorner(radius: (self.base.size.width < self.base.size.height ? self.base.size.width : self.base.size.height) / 2.0, byRoundingCorners: .allCorners, imageSize: self.base.size)
	}
}
