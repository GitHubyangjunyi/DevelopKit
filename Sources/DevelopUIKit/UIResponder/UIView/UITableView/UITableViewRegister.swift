//
//  UITableViewRegister.swift
//  DevelopKit
//
//  Created by 杨俊艺 on 2026/6/6.
//

import UIKit
import DevelopFoundation

public extension GD where Base: UITableView {
	public func setDelegateAndDataSource(_ delegage: UITableViewDelegate, _ dataSource: UITableViewDataSource) {
		base.delegate = delegage
		base.dataSource = dataSource
	}
	
	public func registerCell<T: UITableViewCell>(_ type: T.Type) {
		let identifier = String(describing: type.self)
		base.register(type, forCellReuseIdentifier: identifier)
	}
	
	public func registerXibCell<T: UITableViewCell>(_ type: T.Type) {
		let identifier = String(describing: type.self)
		base.register(UINib(nibName: "\(type)", bundle: nil), forCellReuseIdentifier: identifier)
	}
	
	public func dequeueReusableCell<T: UITableViewCell>(_ type: T.Type) -> T {
		let identifier = String(describing: type.self)
		guard let cell = base.dequeueReusableCell(withIdentifier: identifier) as? T else {
			fatalError("\(type.self) was not registered")
		}
		return cell
	}
}

public extension UITableViewCell {
	/// 注册cell
	/// - Parameter tableView: tableView
	public static func registerTo(_ tableView: UITableView) {
		tableView.register(self, forCellReuseIdentifier: className)
	}
	
	/// xib注册cell
	/// - Parameter tableView: tableView
	public static func registerXibTo(_ tableView: UITableView) {
		tableView.register(UINib(nibName: "\(Self.self)", bundle: nil), forCellReuseIdentifier: className)
	}
	
	public static func dequeueReusableCell(from tableView: UITableView, indexPath: IndexPath) -> Self {
		tableView.dequeueReusableCell(withIdentifier: className, for: indexPath) as! Self
	}
}

public extension UITableViewHeaderFooterView {
	public static func registerTo(_ tableView: UITableView) {
		tableView.register(self, forHeaderFooterViewReuseIdentifier: className)
	}
	
	public static func dequeueReusableHeaderFooterView(from tableView: UITableView) -> Self? {
		tableView.dequeueReusableHeaderFooterView(withIdentifier: className) as? Self
	}
}
