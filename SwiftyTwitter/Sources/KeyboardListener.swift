//
//  KeyboardListener.swift
//

import UIKit
import Tools

// MARK: KeyboardListenerDelegate

@objc public protocol KeyboardListenerDelegate: class {
    func keyboardListener(_ listener: KeyboardListener, animateWithDuration duration: TimeInterval)
    func keyboardListener(_ listener: KeyboardListener, willAnimateWithDuration duration: TimeInterval)
}

extension KeyboardListenerDelegate {
    
    func keyboardListener(_ listener: KeyboardListener, animateWithDuration duration: TimeInterval) {
    }
    
    func keyboardListener(_ listener: KeyboardListener, willAnimateWithDuration duration: TimeInterval) {
    }
}

// MARK: - KeyboardListener

public final class KeyboardListener: NSObject {
    
    public static let shared = KeyboardListener()
    
    public var diff: CGFloat {
        return bottomInset - previousInset
    }
    public var animationInProgress: Bool {
        let inProgress = status == .willHide || status == .willShow
        return inProgress
    }
    fileprivate(set) public var status: Status = .hidden {
        didSet {
            if oldValue != status {
                let hiddenOrShown = status == .hidden || status == .shown
                if hiddenOrShown {
                    callObservers(forType: .didChangeVisibleState)
                }
            }
        }
    }
    fileprivate(set) public var previousInset: CGFloat = 0
    fileprivate(set) public var bottomInset: CGFloat = 0 {
        willSet {
            previousInset = bottomInset
        }
    }
    
    fileprivate var currentDuration: TimeInterval = 0
    fileprivate var delegates: [Weak<KeyboardListenerDelegate>] = []
    fileprivate var onceTimeObservers: [OnceTimeObserver: [() -> ()]] = [:]
    
    fileprivate override init() {
        super.init()
        let notifications: [(Selector, Notification.Name)] = [
            (#selector(willChangeFrame), .UIKeyboardWillChangeFrame),
            (#selector(didHide), .UIKeyboardDidHide),
            (#selector(didShow), .UIKeyboardDidShow),
            (#selector(willHide), .UIKeyboardWillHide),
            (#selector(willShow), .UIKeyboardWillShow)
        ]
        for (selector, name) in notifications {
            NotificationCenter.default.addObserver(
                self,
                selector: selector,
                name: name,
                object: nil)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    public func addDelegate(delegate: KeyboardListenerDelegate) {
        delegates = delegates.filter { $0.value != nil }
        if (delegates.filter{ $0.value === delegate }.isEmpty) {
            delegates.append(Weak(delegate))
        }
    }
    
    public func removeDelegate(delegate: KeyboardListenerDelegate) {
        delegates = delegates.filter { $0.value !== delegate }
    }
    
    public func add(onceObserver observer: OnceTimeObserver, closure: @escaping () -> ()) {
        var observers = onceTimeObservers[observer] ?? []
        observers.append(closure)
        onceTimeObservers[observer] = observers
    }
    
    private func keyboardNotificationWillAnimate() {
        delegates.forEach {
            $0.value?.keyboardListener(self, willAnimateWithDuration: self.currentDuration)
        }
    }
    
    private func keyboardNotificationAnimate() {
        delegates.forEach {
            $0.value?.keyboardListener(self, animateWithDuration: self.currentDuration)
        }
    }
    
    private func callObservers(forType type: OnceTimeObserver) {
        let observers = onceTimeObservers.removeValue(forKey: type)
        observers?.forEach { $0() }
    }

    // MARK: - Observers
    
    func willChangeFrame(sender: NSNotification) {
        guard let info = sender.userInfo else { return }
        guard let beginFrame = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else { return }
        guard let endFrame = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        currentDuration = (info[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue  ?? 0
        let yDiff = endFrame.minY - beginFrame.minY
        bottomInset = UIScreen.main.bounds.height - endFrame.minY
        if yDiff != 0 {
            keyboardNotificationWillAnimate()
            UIView.animate(withDuration: currentDuration, animations: keyboardNotificationAnimate)
        }
    }
    
    func didHide(sender: NSNotification) {
        status = .hidden
        if bottomInset != 0 {
            currentDuration = 0
            bottomInset = 0
            keyboardNotificationWillAnimate()
            keyboardNotificationAnimate()
        }
    }
    
    func didShow(sender: NSNotification) {
        status = .shown
    }
    
    func willHide(sender: NSNotification) {
        status = .willHide
    }
    
    func willShow(sender: NSNotification) {
        status = .willShow
    }
    
}

public extension KeyboardListener {
    
    enum OnceTimeObserver {
        case didChangeVisibleState
    }
    
    enum Status {
        case hidden
        case willHide
        case shown
        case willShow
    }
}
