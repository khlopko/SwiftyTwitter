//
//  LoginView.swift
//  SwiftyTwitter
//
//  Created by Kirill Khlopko on 10/14/16.
//  Copyright © 2016 Kirill Khlopko. All rights reserved.
//

import UIKit
import Tools

protocol LoginViewDelegate: class {
    
    func loginView(_ view: LoginView, handleSignIn credentials: (username: String?, password: String?))
    func loginViewHandleSignUp(_ view: LoginView)
}

final class LoginView: UIView, UITextFieldDelegate {

    weak var delegate: LoginViewDelegate?
    var bottomInset: CGFloat = 0 {
        didSet { setNeedsLayout() }
    }
    
    fileprivate let headerLabel = UILabel() ->> LoginView.initialize(headerLabel:)
    fileprivate let username = UITextField() ->> LoginView.initialize(username:)
    fileprivate let password = UITextField() ->> LoginView.initialize(password:)
    fileprivate let done = UIButton() ->> LoginView.initialize(done:)
    
    fileprivate var inputs: [UITextField] {
        return [username, password]
    }
    fileprivate var editIndex = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .orange
        inputs.forEach { $0.delegate = self }
        let all: [UIView] = [headerLabel, username, password, done]
        all.forEach(addSubview)
        done.addTarget(self, action: #selector(handle(done:)), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        headerLabel.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 84)
        let vertical: [UIView] = [done, password, username]
        var yShift: CGFloat = bottomInset
        for view in vertical {
            view.frame = CGRect(
                x: 0, y: bounds.height - yShift - Constant.itemHeight,
                width: bounds.width, height: Constant.itemHeight)
            yShift += Constant.itemHeight
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === inputs.last {
            handle(done: done)
        } else if let index = inputs.index(where: { $0 === textField }) {
            inputs[index + 1].becomeFirstResponder()
        }
        return true
    }
    
    func handle(done: UIButton) {
        endEditing(true)
        let credentials = (username.text, password.text)
        delegate?.loginView(self, handleSignIn: credentials)
    }
    
    private struct Constant {
        static let itemHeight: CGFloat = 54
    }
    
    private static func initialize(headerLabel: UILabel) {
        headerLabel.textAlignment = .center
        headerLabel.text = "Sign In"
    }
    
    private static func initialize(username: UITextField) {
        username.placeholder = "Username or e-mail"
        username.keyboardType = .emailAddress
        username.returnKeyType = .next
        username.autocorrectionType = .no
        
        username.text = "khlopko"
    }
    
    private static func initialize(password: UITextField) {
        password.isSecureTextEntry = true
        password.placeholder = "Password"
        password.keyboardType = .default
        password.returnKeyType = .done
        
        password.text = "sD91weMa"
    }
    
    private static func initialize(done: UIButton) {
        done.setTitle("Done", for: .normal)
        done.backgroundColor = UIColor(red: 0.4, green: 0.34, blue: 0.7, alpha: 0.75)
    }
}
