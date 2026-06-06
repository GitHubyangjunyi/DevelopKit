//
//  UILabelExtensions.swift
//  DevelopKit
//
//  Created by 杨俊艺 on 2026/6/6.
//

import UIKit
import DevelopFoundation

extension GD where Base: UILabel {
	/// 设置Label的行间距和字间距
	///
	/// - Parameters:
	///   - lineSpace: 行间距
	///   - wordSpace: 字间距
	public func changeLabelRowSpace(lineSpace: CGFloat, wordSpace: CGFloat) {
		guard let content = base.text else { return }
		let attributedString : NSMutableAttributedString = NSMutableAttributedString(string: content)
		let paragraphStyle : NSMutableParagraphStyle = NSMutableParagraphStyle()
		paragraphStyle.lineSpacing = lineSpace
		attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, (content.count)))
		attributedString.addAttribute(NSAttributedString.Key.kern, value: wordSpace, range: NSMakeRange(0, (content.count)))
		base.attributedText = attributedString
		base.sizeToFit()
	}
	
	/// 指定Label显示的字的个数
	///
	/// - Parameter number: 个数
	public func specifiesTheNumberOfWordsToDisplay(number: Int) {
		guard let content = base.text else {return}
		let attributedString : NSMutableAttributedString = NSMutableAttributedString(string: content)
		if content.count < number {return}
		attributedString.deleteCharacters(in: NSMakeRange(number, content.count - number))
		base.attributedText = attributedString
		base.sizeToFit()
	}
}

public extension UILabel {
	
	@discardableResult
	public func withText(_ text: String) -> UILabel {
		self.text = text
		return self
	}
	
	@discardableResult
	public func withTextColor(_ textColor: UIColor) -> UILabel {
		self.textColor = textColor
		return self
	}
	
	@discardableResult
	public func withFont(_ font: UIFont) -> UILabel {
		self.font = font
		return self
	}
	
	@discardableResult
	public func withBackgroundColor(_ color: UIColor) -> UILabel {
		self.backgroundColor = color
		return self
	}
	
	@discardableResult
	public func withTextAligment(_ aligment: NSTextAlignment) -> UILabel {
		self.textAlignment = aligment
		return self
	}
	
	@discardableResult
	public func withNumberOfLines(_ lines: Int) -> UILabel {
		self.numberOfLines = lines
		return self
	}
	
	@discardableResult
	public func withHidden(_ isHide: Bool) -> UILabel {
		self.isHidden = isHide
		return self
	}
	
	@discardableResult
	public func withCornerRadius(_ radius: CGFloat) -> UILabel {
		self.layer.cornerRadius = radius
		self.layer.masksToBounds = true
		return self
	}
}
