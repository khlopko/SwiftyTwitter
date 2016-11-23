//
//  NotificationContainer.swift
//
//  Created by Kirill Khlopko on 9/20/16.
//  Copyright © 2016 GoChat Inc. All rights reserved.
//

import UIKit
import Tools

public final class NotificationContainer {
	
	private var parentWindow: NotificationWindow?
	private var notificationView: UIView?
	private var windowLevel = UIWindowLevelStatusBar + 1
	
	private static let instance = NotificationContainer()
	
	private init() {
	}
	
	public static func show(with notificationView: UIView) {
		instance.add(view: notificationView)
	}
	
	public static func hide(after duration: Double = 0) {
		guard let currentView = instance.notificationView else {
			return
		}
		Run.after(duration) {
			if !(instance.notificationView === currentView) {
				return
			}
			instance.hideAnimation {
				instance.parentWindow?.resignKey()
				instance.parentWindow = nil
				instance.notificationView = nil
			}
		}
	}
	
	private func add(view notificationView: UIView) {
		if self.notificationView != nil {
			return
		}
		self.notificationView = notificationView
		let parentWindow = createWindow()
		parentWindow.isHidden = false
		parentWindow.addSubview(notificationView)
		parentWindow.isUserInteractionEnabled = true
		self.parentWindow = parentWindow
		show()
	}
	
	private func createWindow() -> NotificationWindow {
		let frame = CGRect(
			x: 0, y: -(notificationView?.frame.height ?? 0),
			width: notificationView?.frame.width ?? 0, height: notificationView?.frame.maxY ?? 0)
		let window = NotificationWindow(frame: frame)
		window.windowLevel = windowLevel
		return window
	}
	
	private func show() {
		UIView.animate(withDuration: 0.3, animations: { self.parentWindow?.frame.origin.y = 0 })
	}
	
	private func hideAnimation(completion: @escaping () -> ()) {
		UIView.animate(
			withDuration: 0.3,
			animations: { self.parentWindow?.frame.origin.y -= (self.notificationView?.frame.height ?? 0) },
			completion: { _ in completion() })
	}
}

// MARK: - NotificationWindow

public final class NotificationWindow: UIWindow {
	
	public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
		let view = super.hitTest(point, with: event)
		if subviews.count != 1 {
			return view
		}
		let resultView = subviews.first?.frame.contains(point) == true ? view : nil
		return resultView
	}
}
