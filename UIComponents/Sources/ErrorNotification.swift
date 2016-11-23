//
//  ErrorPopup.swift
//  SwiftyTwitter
//
//  Created by Kirill Khlopko on 11/10/16.
//  Copyright © 2016 Kirill Khlopko. All rights reserved.
//

import UIKit
import Tools

public final class ErrorNotification: UIView {
	
	/// Enables hidding automatically notification. Time can be configured thorought `showTimeInterval` property.
	/// Default is false.
	public static var isAutohideEnabled = false
	
	/// Notification show interval value. Only if `isAutohideEnabled` flag is setted to `true` it will be used.
	/// Default is 0.
	public static var showTimeInterval: TimeInterval = 0
	
	// MARK: Public
	
	public static func show(with error: Error?) {
		if let appError = error as? AppError {
			show(with: appError)
			return
		}
		if let concreteError = error {
			show(with: concreteError.localizedDescription)
			return
		}
		show(with: .undefined)
	}
	
	public static func show(with appError: AppError) {
		show(with: appError.localizedDescription)
	}
	
	private static func show(with text: String) {
		let view = makeView(text: text)
		NotificationContainer.show(with: view)
		if isAutohideEnabled {
			hide(after: showTimeInterval)
		}
	}
	
	public static func hide(after duration: TimeInterval = 0) {
		NotificationContainer.hide(after: duration)
	}
	
	// MARK: Private
	
	private static func makeView(text: String) -> ErrorNotification {
		let view = ErrorNotification()
		view.text = text
		return view
	}
	
	private let label = ErrorNotification.makeLabel()
	
	var text: String? {
		get { return label.text }
		set { label.text = newValue }
	}
	
	private init() {
		let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 46)
		super.init(frame: frame)
		addSubview(label)
		let tap = UITapGestureRecognizer()
		tap.addTarget(self, action: #selector(handle(tap:)))
		label.addGestureRecognizer(tap)
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	public override func layoutSubviews() {
		super.layoutSubviews()
		label.frame = bounds
	}
	
	func handle(tap: UITapGestureRecognizer) {
		NotificationContainer.hide()
	}
	
	private static func makeLabel() -> UILabel {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 14)
		label.backgroundColor = .amaranth
		label.textAlignment = .center
		label.textColor = .white
		label.numberOfLines = 0
		label.lineBreakMode = .byWordWrapping
		label.isUserInteractionEnabled = true
		return label
	}
}
