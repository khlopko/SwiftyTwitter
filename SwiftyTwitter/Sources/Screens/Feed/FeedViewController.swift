//
//  FeedViewController.swift
//  SwiftyTwitter
//
//  Created by Kirill Khlopko on 11/10/16.
//  Copyright © 2016 Kirill Khlopko. All rights reserved.
//

import UIComponents
import Animators
import Feed

final class FeedViewController: ViewController, InteractiveScrollViewControllerProtocol {
	
	fileprivate let feed: Feed
	
	var pan: UIPanGestureRecognizer? {
		return nil
	}
	var mainView: UIView {
		return view
	}
	
	private weak var contentView: FeedView?
	
	init(username: String) {
		feed = Feed(username: username)
		super.init(nibName: nil, bundle: nil)
		modalTransitionStyle = .flipHorizontal
		feed.errorHandler = { [weak self] error in
			self?.contentView?.indicator.stopAnimating()
			ErrorNotification.show(with: error)
		}
		feed.newTweetsHandler = { [weak self] count in
			self?.contentView?.indicator.stopAnimating()
			self?.appendRows(count)
		}
		feed.tryLoadNext()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func loadView() {
		let contentView = FeedView()
		self.contentView = contentView
		view = contentView
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		contentView?.indicator.startAnimating()
		automaticallyAdjustsScrollViewInsets = false
		navigationItem.title = "Feed"
		navigationItem.leftBarButtonItem = UIBarButtonItem(
			image: ImageDrawer.drawBack(color: .white, size: CGSize(width: 44, height: 44)),
			style: .plain, target: self, action: #selector(handle(back:)))
		navigationController?.navigationBar.tintColor = .white
		contentView?.tableView.register(TweetCell.self, forCellReuseIdentifier: "TweetCell")
		contentView?.tableView.dataSource = self
		contentView?.tableView.delegate = self
	}
	
	// MARK: - Actions
	
	func handle(back: UIBarButtonItem) {
		feed.removeCachedUsername()
		dismiss(animated: true, completion: nil)
	}
	
	// MARK: - Private
	
	private func appendRows(_ count: Int) {
		guard let tableView = contentView?.tableView else {
			return
		}
		let section = tableView.numberOfSections - 1
		let lastRow = tableView.numberOfRows(inSection: section)
		let indexPaths = (0..<count).map { IndexPath(row: lastRow + $0, section: section) }
		tableView.beginUpdates()
		tableView.insertRows(at: indexPaths, with: .fade)
		tableView.endUpdates()
	}
}

extension FeedViewController: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
		cell.tweet = feed[indexPath.row]
		return cell
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return feed.count
	}
}

extension FeedViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let viewController = OneTweetViewController(tweet: feed[indexPath.row])
		navigationController?.pushViewController(viewController, animated: true)
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		let tweet = feed[indexPath.row]
		let height = TweetCell.height(with: tweet, width: tableView.frame.width)
		return height
	}
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let current = scrollView.contentOffset.y + scrollView.frame.height
		let leftToBottom = scrollView.contentSize.height - current
		if leftToBottom <= scrollView.frame.height * 3 {
			feed.tryLoadNext()
		}
	}
}
