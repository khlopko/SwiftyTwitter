//
//  FeedView.swift
//  SwiftyTwitter
//
//  Created by Kirill Khlopko on 11/10/16.
//  Copyright © 2016 Kirill Khlopko. All rights reserved.
//

import UIComponents

final class FeedView: UIView {
	
	let tableView = FeedView.makeTableView()
	let indicator = FeedView.makeIndicator()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = .white
		addSubview(tableView)
		tableView.addSubview(indicator)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		tableView.frame = bounds
		indicator.frame = tableView.bounds
	}
	
	private static func makeTableView() -> UITableView {
		let view = UITableView()
		view.separatorColor = .clear
		view.allowsMultipleSelection = false
		view.alwaysBounceHorizontal = false
		view.showsHorizontalScrollIndicator = false
		view.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
		return view
	}
	
	private static func makeIndicator() -> UIActivityIndicatorView {
		let view = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
		view.color = .pictonBlue
		view.hidesWhenStopped = true
		return view
	}
}
