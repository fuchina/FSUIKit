//
//  FSTextViewController.swift
//  FSBaseController
//
//  Translated from Objective-C
//

import UIKit

open class FSTextViewController: FSBaseController {
    
    public var text: String?
    public var completion: ((FSTextViewController, String?) -> Void)?
    
    private var textView: UITextView!
    private var canPop: Bool = false
    private var keyboardObservers: [NSObjectProtocol] = []
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setupNotifications()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupNotifications()
    }
    
    private func setupNotifications() {
        let center = NotificationCenter.default
        keyboardObservers = [
            center.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { [weak self] in
                self?.keyboardActionInPropertyBase($0)
            },
            center.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { [weak self] in
                self?.keyboardActionInPropertyBase($0)
            }
        ]
    }
    
    deinit {
        keyboardObservers.forEach { NotificationCenter.default.removeObserver($0) }
        keyboardObservers.removeAll()
        
    }
    
    open override func componentWillMount() {
        super.componentWillMount()
        textDesignViews()
    }
    
    private func doneAction() {
        completion?(self, textView.text)
    }
    
    private func textDesignViews() {
        title = "请输入"
        
        let bbi = UIBarButtonItem(title: "确认", primaryAction: UIAction { [weak self] _ in
            guard let self else { return }
            self.doneAction()
        })
        navigationItem.rightBarButtonItem = bbi
        
        textView = UITextView(frame: CGRect(x: 0, y: view.safeAreaInsets.top, width: view.bounds.width, height: view.bounds.height - 300))
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.backgroundColor = .clear
        view.addSubview(textView)
        
        if let text = text {
            textView.text = text
        }
        
        textView.becomeFirstResponder()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.canPop = true
        }
    }
    
    private func keyboardActionInPropertyBase(_ notification: Notification) {
        guard let info = notification.userInfo,
              let value = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardSize = value.cgRectValue.size
        textView.frame.size.height = view.bounds.height - keyboardSize.height
    }
    
    // MARK: - FSNavigationControllerPopDelegate
    
    public func navigationShouldPopOnBackButton() -> Bool {
        if canPop {
            return true
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
            return false
        }
    }
}
