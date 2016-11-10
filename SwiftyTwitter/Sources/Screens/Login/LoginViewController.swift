//
//  LoginViewController.swift
//  SwiftyTwitter
//
//  Created by Kirill Khlopko on 10/14/16.
//  Copyright © 2016 Kirill Khlopko. All rights reserved.
//

import UIKit
import AccessProvider

final class LoginViewController: ViewController, LoginViewDelegate, KeyboardListenerDelegate {

    fileprivate weak var contentView: LoginView?
    private let auth = Authentication()
    
    override func loadView() {
        let contentView = LoginView()
        self.contentView = contentView
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView?.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        KeyboardListener.shared.addDelegate(delegate: self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        KeyboardListener.shared.removeDelegate(delegate: self)
    }
    
    // MARK: - KeyboardListenerDelegate
    
    func keyboardListener(_ listener: KeyboardListener, willAnimateWithDuration duration: TimeInterval) {
        contentView?.bottomInset += listener.diff
    }
    
    func keyboardListener(_ listener: KeyboardListener, animateWithDuration duration: TimeInterval) {
        contentView?.layoutIfNeeded()
    }
    
    // MARK: - LoginViewDelegate
    
    func loginView(_ view: LoginView, handleSignIn credentials: (username: String?, password: String?)) {
        guard let username = credentials.username, let password = credentials.password else {
            return
        }
        let credentials = Authentication.Credentials(username: username, password: password)
        auth.perform(with: credentials)
    }
    
    func loginViewHandleSignUp(_ view: LoginView) {
        
    }
}
