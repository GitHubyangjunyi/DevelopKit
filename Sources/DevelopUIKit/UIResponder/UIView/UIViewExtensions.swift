//
//  UIViewExtensions.swift
//  DevelopKit
//
//  Created by 杨俊艺 on 2026/6/6.
//

import UIKit
import DevelopFoundation

extension UIView: GDCompatible { }

public extension UIView {
	/// 添加点击事件
	/// - Parameter action: 点击
	func addTapAction(action: (() -> Void)?) {
		tapAction = action
		isUserInteractionEnabled = true
		let selector = #selector(handleTap)
		let recognizer = UITapGestureRecognizer(target: self, action: selector)
		addGestureRecognizer(recognizer)
	}
	
	typealias Action = (() -> Void)
	
	struct Key { nonisolated(unsafe) static var id = "tapAction" }
	
	var tapAction: Action? {
		get {
			return objc_getAssociatedObject(self, &Key.id) as? Action
		}
		set {
			guard let value = newValue else { return }
			let policy = objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN
			objc_setAssociatedObject(self, &Key.id, value, policy)
		}
	}
	
	@objc func handleTap(sender: UITapGestureRecognizer) {
		tapAction?()
	}
}

// MARK: -- 使用UIColor初始化UIView
public extension UIView {
	convenience init(color: UIColor?) {
		self.init(frame: .zero)
		backgroundColor = color
	}
}

// MARK: -- 设置backgroundView
extension GD where Base: UIView {
	private typealias Associated = UIView.Associated
	
	/// 使用命名空间,避免和UICollectionView,UITableView的属性名冲突
	var backgroundView: UIView? {
		get { getAssociatedObject(base, &Associated.backgroundViewKey) as? UIView }
		nonmutating set {
			backgroundView?.removeFromSuperview()
			setAssociatedObject(base, &Associated.backgroundViewKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		}
	}
}

public extension UIView {
	
	enum Associated {
		nonisolated(unsafe) static var shadowViewKey = UUID()
		nonisolated(unsafe) static var backgroundViewKey = UUID()
		nonisolated(unsafe) static var mournFilterViewKey = UUID()
	}
	
	/// 根据中心点计算目标Frame
	/// - Parameters:
	///   - targetCenter: 目标中心点
	///   - size: 目标Size | 如果为空则使用frame.size
	/// - Returns: 目标Frame
	func targetFrame(targetCenter: CGPoint, size: CGSize? = nil) -> CGRect {
		let targetSize = size ?? frame.size
		let targetWidth = targetSize.width
		let targetHeight = targetSize.height
		let x = targetCenter.x - targetWidth/2.0
		let y = targetCenter.y - targetHeight/2.0
		return CGRect(x: x, y: y, width: targetWidth, height: targetHeight)
	}
	
	/// 清空所有的约束
	func removeAllConstraints() {
		removeConstraints(constraints)
	}
	
	/// 翻转
	/// - Parameter degree: 翻转读数: 一周为360°
	func rotate(_ degree: Int) {
		let angle = (CGFloat.pi / 180.0) * degree.cgFloat
		transform = CGAffineTransform(rotationAngle: angle)
	}
	
	/// 计算自动布局下的尺寸
	/// - Parameters:
	///   - maxSize: 限制最大尺寸
	///   - stretchAxis: 拉伸的轴向
	/// - Returns: 需要的最小尺寸
	func preferredSize(maxSize: CGSize? = nil, stretchAxis: NSLayoutConstraint.Axis = .vertical) -> CGSize {
		var systemLayoutSize = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
		if let maxSize {
			switch stretchAxis {
			case .horizontal:
				if systemLayoutSize.height > maxSize.height {
					systemLayoutSize = systemLayoutSizeFitting(maxSize, withHorizontalFittingPriority: .fittingSizeLevel, verticalFittingPriority: .required)
				}
			case .vertical:
				if systemLayoutSize.width > maxSize.width {
					systemLayoutSize = systemLayoutSizeFitting(maxSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
				}
			@unknown default:
				break
			}
		}
		return systemLayoutSize
	}
	
	func relativeFrameTo(_ target: UIView) -> CGRect? {
		superview?.convert(frame, to: target)
	}
	
	func tagged(_ tag: Int) -> Self {
		self.tag = tag
		return self
	}
	
	/// 添加背景色
	/// - Parameter backgroundColor: 背景颜色
	func add(backgroundColor: UIColor) {
		let background = UIView(frame: bounds)
		background.backgroundColor = backgroundColor
		add(backgroundView: background)
	}
	
	/// 添加圆角背景子视图
	/// - Parameters:
	///   - cornerRadius: 圆角
	///   - insets: 缩进
	///   - maskedCorners: 圆角位置
	///   - backgroundColor: 圆角背景色
	func add(cornerRadius: CGFloat, insets: UIEdgeInsets = .zero, maskedCorners: CACornerMask = .allCorners, backgroundColor: UIColor, borderWidth: CGFloat? = nil, borderColor: UIColor? = nil) {
		let bgView = UIView(color: backgroundColor)
		bgView.layer.maskedCorners = maskedCorners
		bgView.layer.cornerRadius = cornerRadius
		if let borderWidth, borderWidth > 0 {
			bgView.layer.borderWidth = borderWidth
			bgView.layer.borderColor = borderColor?.cgColor
		}
		add(backgroundView: bgView, insets: insets)
	}
	
	/// 添加覆盖层
	/// - Parameter overlay: 顶层子视图
	func add(overlay: UIView) {
		add(backgroundView: overlay)
		bringSubviewToFront(overlay)
	}
	
	/// 添加背景子视图
	/// - Parameters:
	///   - backgroundView: 背景子视图
	///   - insets: 缩进边距
	///   - configure: 其他设置
	func add(backgroundView: UIView, insets: UIEdgeInsets = .zero, configure: ((UIView) -> Void)? = nil) {
		/// 按Bounds缩进
		let frame = bounds.inset(by: insets)
		/// 其他配置
		if let configure {
			configure(backgroundView)
		}
		/// 添加背景图
		add(backgroundView: backgroundView, frame: frame)
	}
	
	/// 添加背景子视图
	/// - Parameters:
	///   - backgroundView: 背景子视图
	///   - frame: 背景图位置
	func add(backgroundView: UIView, frame: CGRect) {
		backgroundView.frame = frame
		backgroundView.autoresizingMask = .autoResize
		insertSubview(backgroundView, at: 0)
		gd.backgroundView = backgroundView
	}
	
	func snapshotScreen(scrollView: UIScrollView) -> UIImage?{
		if UIScreen.main.responds(to: #selector(getter: UIScreen.scale)) {
			UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, false, UIScreen.main.scale)
		} else {
			UIGraphicsBeginImageContext(scrollView.contentSize)
		}
		
		let savedContentOffset = scrollView.contentOffset
		let savedFrame = scrollView.frame
		let contentSize = scrollView.contentSize
		let oldBounds = scrollView.layer.bounds
		
		scrollView.layer.bounds = CGRect(x: oldBounds.origin.x, y: oldBounds.origin.y, width: contentSize.width, height: contentSize.height)
		//偏移量归零
		scrollView.contentOffset = CGPoint.zero
		//frame变为contentSize
		scrollView.frame = CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height)
		
		//截图
		if let context = UIGraphicsGetCurrentContext() {
			scrollView.layer.render(in: context)
		}
		scrollView.layer.bounds = oldBounds
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		//还原frame 和 偏移量
		scrollView.contentOffset = savedContentOffset
		scrollView.frame = savedFrame
		return image
	}
	
	private func getTableViewScreenshot(tableView: UITableView,whereView: UIView) -> UIImage? {
		// 创建一个scrollView
		let scrollView = UIScrollView()
		// 设置颜色
		scrollView.backgroundColor = UIColor.white
		// 设置位置
		scrollView.frame = whereView.bounds
		// 设置滚动位置
		scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: tableView.contentSize.height)
		// 将tableView加载到视图中
		scrollView.addSubview(tableView)
		// 设置位置
		let constraints = [
			tableView.topAnchor.constraint(equalTo: scrollView.topAnchor),
			tableView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
			tableView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
			tableView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
			tableView.heightAnchor.constraint(equalToConstant: tableView.contentSize.height)
		]
		NSLayoutConstraint.activate(constraints)
		/// 添加到指定视图
		whereView.addSubview(scrollView)
		/// 截图
		let image = snapshotScreen(scrollView: scrollView)
		/// 移除scrollView
		scrollView.removeFromSuperview()
		return image
	}
	
	var snapshotImage: UIImage? {
		switch self {
		case let unwrapped where unwrapped is UITableView:
			let tableView = unwrapped as! UITableView
			return getTableViewScreenshot(tableView: tableView, whereView: superview!)
		default:
			// 参数①：截屏区域  参数②：是否透明  参数③：清晰度
			UIGraphicsBeginImageContextWithOptions(frame.size, true, UIScreen.main.scale)
			layer.render(in: UIGraphicsGetCurrentContext()!)
			let image = UIGraphicsGetImageFromCurrentImageContext()
			
			UIGraphicsEndImageContext()
			return image
		}
	}
	
	@available(iOS 11.0, *)
	var bottomSafeAreaPadding: Double {
		guard let superview else { return 0 }
		return superview.bounds.height - frame.maxY - superview.safeAreaInsets.bottom
	}
}

// MARK: -- Array
public extension Array where Element: UIView {
	
	/// 将UIView的数组包装的StackView里
	/// - Returns: The stack view wrapping the given view array as arranged subviews.
	func embedInStackView(
		axis: NSLayoutConstraint.Axis = .vertical,
		distribution: UIStackView.Distribution = .fill,
		alignment: UIStackView.Alignment = .leading,
		spacing: CGFloat = 0)
	-> UIStackView {
		let stackView = UIStackView(arrangedSubviews: self)
		stackView.axis = axis
		stackView.distribution = distribution
		stackView.alignment = alignment
		stackView.spacing = spacing
		return stackView
	}
}


public extension UIView {
	
	/// 设置宽高比例 | 如果传入的比例为空则移除之前的约束
	/// - Returns: 自己
	@discardableResult func fix(proportion: CGSize?, priority: UILayoutPriority = .required) -> Self {
		
		/// 移除已经存在的约束
		let existedConstraints = constraints.filter { constraint in
			guard constraint.relation == .equal else { return false }
			guard constraint.firstAttribute == .width else { return false }
			guard constraint.secondAttribute == .height else { return false }
			return true
		}
		NSLayoutConstraint.deactivate(existedConstraints)
		
		if let proportion {
			/// 开启约束
			translatesAutoresizingMaskIntoConstraints = false
			/// 宽高比例
			let multiplier = proportion.width / proportion.height
			/// 激活约束
			let constraint = widthAnchor.constraint(equalTo: heightAnchor, multiplier: multiplier)
			constraint.priority = priority
			constraint.isActive = true
		}
		return self
	}
	
	/// 固定尺寸
	/// - Returns: 自己
	@discardableResult func fix(size: CGSize) -> Self {
		fix(width: size.width, height: size.height)
	}
	
	/// 固定宽高
	/// - Returns: 自己
	@discardableResult func fix(width: CGFloat? = nil, height: CGFloat? = nil) -> Self {
		fix(widthConstraint: width?.constraint, heightConstraint: height?.constraint)
	}
	
	@discardableResult func fix(widthConstraint: UILayoutConstraint? = nil, heightConstraint: UILayoutConstraint? = nil) -> Self {
		
		func deactivateWidthConstraintsIfNeeded() {
			let existedConstraints = constraints.filter { constraint in
				guard constraint.relation == .equal else { return false }
				guard constraint.firstAttribute == .width else { return false }
				guard constraint.secondAttribute == .notAnAttribute else { return false }
				return true
			}
			if existedConstraints.isEmpty { return }
			NSLayoutConstraint.deactivate(existedConstraints)
		}
		
		func deactivateHeightConstraintsIfNeeded() {
			let existedConstraints = constraints.filter { constraint in
				guard constraint.relation == .equal else { return false }
				guard constraint.firstAttribute == .height else { return false }
				guard constraint.secondAttribute == .notAnAttribute else { return false }
				return true
			}
			if existedConstraints.isEmpty { return }
			NSLayoutConstraint.deactivate(existedConstraints)
		}
		
		/// 其中一个必须有值
		guard widthConstraint.isValid || heightConstraint.isValid else {
			/// 如果两个参数都无效, 则移除已经存在的约束
			deactivateWidthConstraintsIfNeeded()
			deactivateHeightConstraintsIfNeeded()
			return self
		}
		/// 开始自动布局
		translatesAutoresizingMaskIntoConstraints = false
		/// 约束宽度
		if let widthConstraint {
			/// 移除存在的约束
			deactivateWidthConstraintsIfNeeded()
			/// 激活新的约束
			let constraint = widthAnchor.constraint(equalToConstant: widthConstraint.constant)
			constraint.priority = widthConstraint.priority
			constraint.isActive = true
		}
		/// 约束高度
		if let heightConstraint {
			/// 移除存在的高度约束
			deactivateHeightConstraintsIfNeeded()
			/// 激活新的约束
			let constraint = heightAnchor.constraint(equalToConstant: heightConstraint.constant)
			constraint.priority = heightConstraint.priority
			constraint.isActive = true
		}
		return self
	}
	
	@discardableResult func limit(widthRange: ClosedRange<CGFloat>? = nil, heightRange: ClosedRange<CGFloat>? = nil) -> Self {
		limit(minWidth: widthRange?.lowerBound,
			  maxWidth: widthRange?.upperBound,
			  minHeight: heightRange?.lowerBound,
			  maxHeight: heightRange?.upperBound)
	}
	
	@discardableResult func limit(minWidth: CGFloat? = nil, maxWidth: CGFloat? = nil, minHeight: CGFloat? = nil, maxHeight: CGFloat? = nil) -> Self {
		limit(minWidth: minWidth?.constraint,
			  maxWidth: maxWidth?.constraint,
			  minHeight: minHeight?.constraint,
			  maxHeight: maxHeight?.constraint)
	}
	
	@discardableResult func limit(minWidth: UILayoutConstraint? = nil, maxWidth: UILayoutConstraint? = nil, minHeight: UILayoutConstraint? = nil, maxHeight: UILayoutConstraint? = nil) -> Self {
		
		func deactivateMinWidthConstraintIfNeeded() {
			let existedConstraints = constraints.filter { constraint in
				guard constraint.relation == .greaterThanOrEqual else { return false }
				guard constraint.firstAttribute == .width else { return false }
				guard constraint.secondAttribute == .notAnAttribute else { return false }
				return true
			}
			if existedConstraints.isEmpty { return }
			NSLayoutConstraint.deactivate(existedConstraints)
		}
		
		func deactivateMaxWidthConstraintIfNeeded() {
			let existedConstraints = constraints.filter { constraint in
				guard constraint.relation == .lessThanOrEqual else { return false }
				guard constraint.firstAttribute == .width else { return false }
				guard constraint.secondAttribute == .notAnAttribute else { return false }
				return true
			}
			if existedConstraints.isEmpty { return }
			NSLayoutConstraint.deactivate(existedConstraints)
		}
		
		func deactivateMinHeightConstraintIfNeeded() {
			let existedConstraints = constraints.filter { constraint in
				guard constraint.relation == .greaterThanOrEqual else { return false }
				guard constraint.firstAttribute == .height else { return false }
				guard constraint.secondAttribute == .notAnAttribute else { return false }
				return true
			}
			if existedConstraints.isEmpty { return }
			NSLayoutConstraint.deactivate(existedConstraints)
		}
		
		func deactivateMaxHeightConstraintIfNeeded() {
			let existedConstraints = constraints.filter { constraint in
				guard constraint.relation == .lessThanOrEqual else { return false }
				guard constraint.firstAttribute == .height else { return false }
				guard constraint.secondAttribute == .notAnAttribute else { return false }
				return true
			}
			if existedConstraints.isEmpty { return }
			NSLayoutConstraint.deactivate(existedConstraints)
		}
		
		/// 先移除已经存在的约束
		deactivateMinWidthConstraintIfNeeded()
		deactivateMaxWidthConstraintIfNeeded()
		deactivateMinHeightConstraintIfNeeded()
		deactivateMaxHeightConstraintIfNeeded()
		/// 开始约束
		translatesAutoresizingMaskIntoConstraints = false
		/// 最小宽度
		if let minWidth {
			/// 激活新的约束
			let constraint = widthAnchor.constraint(greaterThanOrEqualToConstant: minWidth.constant)
			constraint.priority = minWidth.priority
			constraint.isActive = true
		}
		/// 最大宽度
		if let maxWidth {
			/// 激活新的约束
			let constraint = widthAnchor.constraint(lessThanOrEqualToConstant: maxWidth.constant)
			constraint.priority = maxWidth.priority
			constraint.isActive = true
		}
		/// 最小高度
		if let minHeight {
			/// 激活新的约束
			let constraint = heightAnchor.constraint(greaterThanOrEqualToConstant: minHeight.constant)
			constraint.priority = minHeight.priority
			constraint.isActive = true
		}
		/// 最大高度
		if let maxHeight {
			/// 激活新的约束
			let constraint = heightAnchor.constraint(lessThanOrEqualToConstant: maxHeight.constant)
			constraint.priority = maxHeight.priority
			constraint.isActive = true
		}
		return self
	}
	
	/// 添加子视图(可变参数)
	/// - Parameter subviews: 子视图序列
	func addSubviews(_ subviews: UIView...) {
		addSubviews(subviews)
	}
	
	/// 添加子视图集合
	/// - Parameter subviews: UIView集合
	func addSubviews<T>(_ subviews: T) where T: Sequence, T.Element: UIView {
		subviews.forEach { subview in
			addSubview(subview)
		}
	}
	
	/// 自适应Size | 内部子控件Autolayout
	/// 注意: 在设置UITableView.headerView属性的时候,内部控件的约束优先级最好都配置成非.required
	/// 否则可能报Unable to simultaneously satisfy constraints.警告
	/// 如果headerView继承自普通的UIView,调用此方法之前要保证提前设置好宽度约束等于TableView的宽度,否则会得到错误的布局
	/// 或者调用layoutIfNeeded然后重新赋值UITableView.headerView
	///
	/// 故,最好使用UITableViewHeaderFooterView的子类来设置UITableView的headerView属性,因为其自身就带有宽度等于父视图的约束
	/// 可以省去再次配置宽度约束的步骤
	func fitSizeIfNeeded() {
		let systemLayoutSize = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
		let height = systemLayoutSize.height
		let width = systemLayoutSize.width
		// Comparison necessary to avoid infinite loop
		if height != bounds.height {
			bounds.size.height = height
		}
		if width != bounds.width {
			bounds.size.width = width
		}
	}
	
	func superview(where predicate: (UIView) -> Bool) -> UIView? {
		superview(UIView.self, where: predicate)
	}
	
	/// 找到符合条件的父视图
	/// - Parameter predicate: 判断父视图是否合规的判决条件
	/// - Returns: 满足条件的父视图
	func superview<SuperView: UIView>(_ type: SuperView.Type, where predicate: (SuperView) -> Bool) -> SuperView? {
		var targetSuperview: SuperView?
		var nextResponder = next
		while let unwrapResponder = nextResponder {
			if let nextSuperview = unwrapResponder as? SuperView {
				if predicate(nextSuperview) {
					targetSuperview = nextSuperview
					break
				}
			}
			nextResponder = unwrapResponder.next
		}
		return targetSuperview
	}
	
	/// 获取父视图
	/// - Parameter type: 父视图类型
	/// - Returns: 有效的父视图
	func superview<SuperView: UIView>(_ type: SuperView.Type) -> SuperView? {
		/// 确保有父视图
		guard let validSuperview = superview else { return nil }
		/// 转换成指定类型的父视图
		guard let matchedSuperview = validSuperview as? SuperView else {
			/// 如果转换失败则查找父视图的parentSuperView
			return validSuperview.superview(SuperView.self)
		}
		return matchedSuperview
	}
	
	/// 硬化 | 不可拉伸 | 不可压缩
	/// - Parameters:
	///   - axis: 设置轴线 | 默认为空(两轴同时硬化)
	///   - intensity: 硬化强度
	/// - Returns: 控件本身
	/// - Tips: 谨慎使用这个方法: 调用这四个方法之后, 会导致UIButtonPlus分类中重写的intrinsicContentSize返回的size失效
	@discardableResult
	func harden(axis: NSLayoutConstraint.Axis? = nil, intensity: UILayoutPriority = .required) -> Self {
		func hardenVertical() {
			setContentCompressionResistancePriority(intensity, for: .vertical)
			setContentHuggingPriority(intensity, for: .vertical)
		}
		func hardenHorizontal() {
			setContentCompressionResistancePriority(intensity, for: .horizontal)
			setContentHuggingPriority(intensity, for: .horizontal)
		}
		guard let axis = axis else {
			hardenVertical()
			hardenHorizontal()
			return self
		}
		switch axis {
		case .horizontal:
			hardenHorizontal()
		case .vertical:
			hardenVertical()
		@unknown default:
			break
		}
		return self
	}
	
	// MARK: - 圆角 + 阴影
	final class _UIShadowView: UIView { }
	var shadowView: _UIShadowView {
		guard let shadow = getAssociatedObject(self, &Associated.shadowViewKey) as? _UIShadowView else {
			let shadow = _UIShadowView(frame: bounds)
			shadow.isUserInteractionEnabled = false
			shadow.backgroundColor = .clear
			shadow.layer.masksToBounds = false
			shadow.layer.shouldRasterize = true
			shadow.layer.rasterizationScale = UIScreen.main.scale
			shadow.autoresizingMask = [
				.flexibleWidth,
				.flexibleHeight
			]
			setAssociatedObject(self, &Associated.shadowViewKey, shadow, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
			return shadow
		}
		return shadow
	}
	
	
	/// 为视图添加圆角和阴影 | 只在frame确定的时候才能调用此方法
	/// - Parameters:
	///   - corners: 圆角效果施加的角
	///   - cornerRadius: 圆角大小
	///   - shadowColor: 阴影颜色: 不为空才添加阴影
	///   - shadowOffsetX: 阴影偏移X
	///   - shadowOffsetY: 阴影偏移Y
	///   - shadowRadius: 阴影大小
	///   - shadowOpacity: 阴影透明度
	///   - shadowExpansion: 阴影扩大值:大于零扩大; 小于零收缩; 0:默认值
	func roundCorners(corners: UIRectCorner = .allCorners,
					  cornerRadius: CGFloat = 0.0,
					  withShadowColor shadowColor: UIColor? = nil,
					  shadowOffset: (x: Double, y: Double) = (0, 0),
					  shadowRadius: CGFloat = 0,
					  shadowOpacity: Float = 0,
					  shadowExpansion: CGFloat = 0) {
		// 圆角
		var bezier = UIBezierPath(
			roundedRect: bounds,
			byRoundingCorners: corners,
			cornerRadii: CGSize(width:cornerRadius, height:cornerRadius)
		)
		if cornerRadius > 0 {
			// 未设置阴影的时候尝试使用iOS 11的API设置圆角
			if #available(iOS 11.0, *), shadowColor == nil {
				// 这个方法在UITableViewCell外部调用时 Section的最后一个Cell不起作用,不清楚为啥
				layer.masksToBounds = true
				layer.cornerRadius = cornerRadius
				layer.maskedCorners = corners.caCornerMask
			} else {
				let shape = CAShapeLayer()
				shape.path = bezier.cgPath
				layer.mask = shape
			}
		} else {
			if #available(iOS 11.0, *), shadowColor == nil {
				// 这个方法在UITableViewCell外部调用时 Section的最后一个Cell不起作用,不清楚为啥
				layer.masksToBounds = false
				layer.cornerRadius = cornerRadius
				layer.maskedCorners = corners.caCornerMask
			} else {
				layer.mask = nil
			}
		}
		
		// 阴影
		if let shadowColor = shadowColor {
			// 调整阴影View的frame
			shadowView.frame = frame
			// 设置阴影属性
			shadowView.layer.shadowColor = shadowColor.cgColor
			shadowView.layer.shadowOffset = CGSize(width: shadowOffset.x, height: shadowOffset.y)
			shadowView.layer.shadowRadius = shadowRadius
			shadowView.layer.shadowOpacity = shadowOpacity
			// 设置阴影形状
			if shadowExpansion != 0 {
				let insets = UIEdgeInsets(
					top: -shadowExpansion,
					left: -shadowExpansion,
					bottom: -shadowExpansion,
					right: -shadowExpansion
				)
				bezier = UIBezierPath(
					roundedRect: bounds.inset(by: insets),
					byRoundingCorners: corners,
					cornerRadii: CGSize(width:cornerRadius, height:cornerRadius)
				)
			}
			shadowView.layer.shadowPath = bezier.cgPath
			if let superView = superview {
				superView.insertSubview(shadowView, belowSubview: self)
			}
		}
	}
}

// MARK: - 其他
public extension UIView.AutoresizingMask {
	
	/// 自动根据初始的frame调整尺寸
	static var autoResize: UIView.AutoresizingMask {
		[.flexibleWidth, .flexibleHeight]
	}
}


/// 隐藏键盘
func dismissKeyboard() {
	/// to: 指定参数为nil, 此方法会将Action发送给当前的第一响应者, 从而达到隐藏键盘的效果
	UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
}

func getAssociatedObject<T>(_ object: Any, _ key: inout T) -> Any? {
	objc_getAssociatedObject(object, &key)
}

func setAssociatedObject<T>(_ object: Any, _ key: inout T, _ value: Any?, _ policy: objc_AssociationPolicy) {
	objc_setAssociatedObject(object, &key, value, policy)
}

public extension GD where Base: UIView {
	
	/// 裁剪圆角
	/// - Parameters:
	///   - direction: 裁剪的上下左右的边角设置
	///   - cornerRadius: 圆弧数值
	func clipRectCorner(direction: UIRectCorner, cornerRadius: CGFloat) {
		let cornerSize = CGSize(width:cornerRadius, height:cornerRadius)
		let maskPath = UIBezierPath(roundedRect: base.bounds, byRoundingCorners: direction, cornerRadii: cornerSize)
		let maskLayer = CAShapeLayer()
		maskLayer.frame = base.bounds
		maskLayer.path = maskPath.cgPath
		base.layer.addSublayer(maskLayer)
		base.layer.mask = maskLayer
	}
	
	/// 移除所有子View，可选择性忽略指定tag的子View
	/// - Parameter tag: 需要忽略的子View的tag（传nil则移除所有）
	func removeAllSubviews(ignore tag: Int? = nil) {
		base.subviews
			.filter { $0.tag != tag }  // 过滤掉需要忽略的View
			.forEach { $0.removeFromSuperview() }
	}
	
	/// 添加渐变色
	/// - Parameters:
	///   - frame: color layer of frame
	///   - view: add color layer to superView
	///   - colors: array colors
	///   - locations: ranage 0 - 1   count == colors.count
	///   - statrPoint: statr
	///   - endPoint: end
	func setBackgroundColors(_ frame: CGRect, at view: UIView, _ colors: [UIColor], _ locations: [NSNumber], _ statrPoint: CGPoint, _ endPoint: CGPoint){
		let gradientLayer = CAGradientLayer()
		gradientLayer.frame = frame
		view.layer.addSublayer(gradientLayer)
		gradientLayer.colors = colors
		gradientLayer.locations = locations
		gradientLayer.startPoint = statrPoint
		gradientLayer.endPoint = endPoint
	}
	
	/// 添加虚线边框
	/// - Parameters:
	///   - width: 虚线的宽度
	///   - length: 虚线长度
	///   - space: 虚线间距
	///   - cornerRadius: view圆角
	///   - color: 虚线颜色
	func drawBoardDottedLine(width: CGFloat,
							 length: CGFloat,
							 space: CGFloat,
							 cornerRadius: CGFloat,
							 color: UIColor){
		base.layer.cornerRadius = cornerRadius
		let borderLayer =  CAShapeLayer()
		borderLayer.bounds = base.bounds
		
		borderLayer.position = CGPoint(x: base.bounds.midX, y: base.bounds.midY);
		borderLayer.path = UIBezierPath(roundedRect: borderLayer.bounds, cornerRadius: cornerRadius).cgPath
		borderLayer.lineWidth = width / UIScreen.main.scale
		
		//虚线边框---小边框的长度
		borderLayer.lineDashPattern = [length,space]  as [NSNumber]? //前边是虚线的长度，后边是虚线之间空隙的长度
		borderLayer.lineDashPhase = 0.1
		//实线边框
		
		borderLayer.fillColor = UIColor.clear.cgColor
		borderLayer.strokeColor = color.cgColor
		base.layer.addSublayer(borderLayer)
	}
	
	/// 获取特定位置的颜色
	/// - parameter at: 位置
	/// - returns: 颜色
	func pickColor(at position: CGPoint) -> UIColor? {
		
		// 用来存放目标像素值
		var pixel = [UInt8](repeatElement(0, count: 4))
		// 颜色空间为 RGB，这决定了输出颜色的编码是 RGB 还是其他（比如 YUV）
		let colorSpace = CGColorSpaceCreateDeviceRGB()
		// 设置位图颜色分布为 RGBA
		let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue
		guard let context = CGContext(data: &pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo) else {
			return nil
		}
		// 设置 context 原点偏移为目标位置所有坐标
		context.translateBy(x: -position.x, y: -position.y)
		// 将图像渲染到 context 中
		base.layer.render(in: context)
		
		return UIColor(red: CGFloat(pixel[0]) / 255.0,
					   green: CGFloat(pixel[1]) / 255.0,
					   blue: CGFloat(pixel[2]) / 255.0,
					   alpha: CGFloat(pixel[3]) / 255.0)
	}
	
	
	/// 获取多个点的颜色值
	/// - Parameter positions: 点的位置
	/// - Returns: 颜色
	func blendColors(at positions: [CGPoint]) -> UIColor? {
		// 计算平均颜色的初始值
		var totalRed: CGFloat = 0.0
		var totalGreen: CGFloat = 0.0
		var totalBlue: CGFloat = 0.0
		
		// 颜色空间为 RGB，这决定了输出颜色的编码是 RGB 还是其他（比如 YUV）
		let colorSpace = CGColorSpaceCreateDeviceRGB()
		// 设置位图颜色分布为 RGBA
		let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue
		
		var removeCount: Int = 0
		// 遍历每个位置
		for position in positions {
			// 用于存放当前位置的像素值
			var pixel = [UInt8](repeatElement(0, count: 4))
			
			guard let context = CGContext(data: &pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo) else {
				return nil
			}
			
			// 设置 context 原点偏移为当前位置的坐标
			context.translateBy(x: -position.x, y: -position.y)
			
			// 将图像渲染到 context 中
			base.layer.render(in: context)
			
			// 将当前位置的像素值累加到总值上
			if pixel[0] != 0 && pixel[1] != 0 && pixel[2] != 0 {
				totalRed += CGFloat(pixel[0])
				totalGreen += CGFloat(pixel[1])
				totalBlue += CGFloat(pixel[2])
			} else {
				removeCount += 1
			}
		}
		
		// 计算平均颜色的分量值
		let count = CGFloat(positions.count - removeCount)
		let averageRed = totalRed / count
		let averageGreen = totalGreen / count
		let averageBlue = totalBlue / count
		
		// 创建并返回新的颜色
		return UIColor(red: averageRed / 255.0,
					   green: averageGreen / 255.0,
					   blue: averageBlue / 255.0,
					   alpha: 1.0)
	}
	
	/**
	 *  将图层旋转radian弧度
	 *
	 *  @param radian 旋转的弧度
	 */
	func rotate(by radian: CGFloat) {
		var transform = base.layer.affineTransform()
		transform = transform.rotated(by: radian)
		base.layer.setAffineTransform(transform)
	}
}

//MARK: -- 方便加载 nib 文件
public extension UIView {
	
	class func fromNib<T: UIView>(_ bundleId: String? = nil) -> T {
		let className: String = self.className
		if bundleId != nil {
			let bundle = Bundle(identifier: bundleId!)
			return UINib.init(nibName: className, bundle: bundle).instantiate(withOwner: self, options: nil).last as! T
		}
		let v: T? = UINib.init(nibName: className, bundle: nil).instantiate(withOwner: self, options: nil).last as? T
		if v != nil {
			return v!
		}
		return T()
	}
}


// MARK: -- 设置圆角、边框、阴影
public extension GD where Base: UIView {
	
	@discardableResult
	func setCornerRadius(_ radius: CGFloat) -> Base {
		base.clipsToBounds = true
		base.layer.cornerRadius = radius
		return base
	}
	
	@discardableResult
	func setBorderColor(_ color: UIColor)-> Base {
		base.layer.borderColor = color.cgColor
		return base
	}
	
	@discardableResult
	func setBorderWidth(_ width: CGFloat)-> Base {
		base.layer.borderWidth = width
		return base
	}
	
	/// 快捷设置圆角、边框宽度、边框颜色
	/// - Parameters:
	///   - cornerRadius: 圆角
	///   - borderWidth: 宽度
	///   - borderColor: 颜色
	func setCornerRadius(cornerRadius: CGFloat, borderWidth: CGFloat, borderColor: UIColor) {
		setCornerRadius(cornerRadius)
		setBorderWidth(borderWidth)
		setBorderColor(borderColor)
	}
}


public extension UIView {
	
	/// 将某个view 转换成图像
	var toImage: UIImage? {
		UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
		layer.render(in: UIGraphicsGetCurrentContext()!)
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return image
	}
	
	var convertFrameToSuperview: CGRect {
		guard let superview else { return .zero }
		return convert(bounds, to: superview)
	}
}

public extension UIView {
	
	/// 指定圆角
	@discardableResult
	func roundedCorner(radius: CGFloat, roundingCorners: UIRectCorner, rect: CGRect) -> CGPath? {
		let maskLayer = CAShapeLayer()
		
		let path = UIBezierPath()
		
		if roundingCorners.contains(.topLeft) {
			path.move(to: CGPoint(x: rect.minX, y: rect.minY + radius))
			path.addArc(withCenter: CGPoint(x: rect.minX + radius, y: rect.minY + radius),
						radius: radius,
						startAngle: CGFloat.pi,
						endAngle: CGFloat.pi * 1.5,
						clockwise: true)
		} else {
			path.move(to: CGPoint(x: rect.minX, y: rect.minY))
		}
		
		if roundingCorners.contains(.topRight) {
			path.addLine(to: CGPoint(x: rect.maxX - radius, y: rect.minY))
			path.addArc(withCenter: CGPoint(x: rect.maxX - radius, y: rect.minY + radius),
						radius: radius,
						startAngle: CGFloat.pi * 1.5,
						endAngle: 0,
						clockwise: true)
		} else {
			path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
		}
		
		if roundingCorners.contains(.bottomRight) {
			path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - radius))
			path.addArc(withCenter: CGPoint(x: rect.maxX - radius, y: rect.maxY - radius),
						radius: radius,
						startAngle: 0,
						endAngle: CGFloat.pi/2,
						clockwise: true)
		} else {
			path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
		}
		
		if roundingCorners.contains(.bottomLeft) {
			path.addLine(to: CGPoint(x: rect.minX + radius, y: rect.maxY))
			path.addArc(withCenter: CGPoint(x: rect.minX + radius, y: rect.maxY - radius),
						radius: radius,
						startAngle: CGFloat.pi/2,
						endAngle: CGFloat.pi,
						clockwise: true)
		} else {
			path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
		}
		
		path.close()
		
		maskLayer.path = path.cgPath
		layer.mask = maskLayer
		layer.masksToBounds = true
		
		return path.cgPath
	}
	
	func addCorner(conrners: UIRectCorner , radius: CGFloat) {
		let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: conrners, cornerRadii: CGSize(width: radius, height: radius))
		let maskLayer = CAShapeLayer()
		maskLayer.frame = self.bounds
		maskLayer.path = maskPath.cgPath
		self.layer.mask = maskLayer
	}
	
	func addCornerAndBorder(corners: UIRectCorner, radius: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
		let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
		
		let maskLayer = CAShapeLayer()
		maskLayer.frame = self.bounds
		maskLayer.path = maskPath.cgPath
		self.layer.mask = maskLayer
		
		let borderLayer = CAShapeLayer()
		borderLayer.path = maskPath.cgPath
		borderLayer.fillColor = UIColor.clear.cgColor
		borderLayer.strokeColor = borderColor.cgColor
		borderLayer.lineWidth = borderWidth
		borderLayer.frame = self.bounds
		self.layer.addSublayer(borderLayer)
	}
}
