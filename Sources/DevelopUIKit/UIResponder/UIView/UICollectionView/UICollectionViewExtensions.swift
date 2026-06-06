//
//  UICollectionViewExtensions.swift
//  DevelopKit
//
//  Created by 杨俊艺 on 2026/6/6.
//

import UIKit
import DevelopFoundation

public extension GD where Base: UICollectionView {
	func setDelegateAndDataSource(_ delegage: UICollectionViewDelegate, _ dataSource: UICollectionViewDataSource) {
		base.delegate = delegage
		base.dataSource = dataSource
	}
	
	func registerCell<T: UICollectionViewCell>(_ type: T.Type) {
		let identifier = String(describing: type.self)
		base.register(type, forCellWithReuseIdentifier: identifier)
	}
	
	func registerXibCell<T: UICollectionViewCell>(_ type: T.Type) {
		let identifier = String(describing: type.self)
		base.register(UINib(nibName: "\(type)", bundle: nil), forCellWithReuseIdentifier: identifier)
	}
	
	func dequeueReusableCell<T: UICollectionViewCell>(_ type: T.Type, for indexPath: IndexPath) -> T {
		let identifier = String(describing: type.self)
		guard let cell = base.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? T else {
			fatalError("\(type.self) was not registered")
		}
		return cell
	}
}

public extension UICollectionViewCell {
	/// 注册cell
	/// - Parameter collectionView: collectionView description
	static func registerTo(_ collectionView: UICollectionView) {
		collectionView.register(self, forCellWithReuseIdentifier: className)
	}
	
	/// xib注册cell
	/// - Parameter collectionView: collectionView description
	static func registerXibTo(_  collectionView: UICollectionView) {
		collectionView.register(UINib(nibName: "\(Self.self)", bundle: nil), forCellWithReuseIdentifier: className)
	}
	
	static func dequeueReusableCell(from collectionView: UICollectionView, indexPath: IndexPath) -> Self {
		collectionView.dequeueReusableCell(withReuseIdentifier: className, for: indexPath) as! Self
	}
}
