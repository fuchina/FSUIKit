//
//  FSTextViewController.swift
//  FSBaseController
//
//  Translated from Objective-C
//

import UIKit

@objc open class FSTextViewController: FSBaseController, FSNavigationControllerPopDelegate {
    
    @objc public var text: String?
    @objc public var completion: ((FSTextViewController, String?) -> Void)?
    
    private var textView: UITextView!
    private var canPop: Bool = false
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setupNotifications()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupNotifications()
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardActionInPropertyBase(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardActionInPropertyBase(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    open override func componentWillMount() {
        super.componentWillMount()
        textDesignViews()
    }
    
    @objc private func doneAction() {
        completion?(self, textView.text)
    }
    
    private func textDesignViews() {
        title = "请输入"
        
        let bbi = UIBarButtonItem(title: "确认", style: .plain, target: self, action: #selector(doneAction))
        navigationItem.rightBarButtonItem = bbi
        
        textView = UITextView(frame: CGRect(x: 0, y: view.safeAreaInsets.top, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 300))
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
    
    @objc private func keyboardActionInPropertyBase(_ notification: Notification) {
        guard let info = notification.userInfo,
              let value = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardSize = value.cgRectValue.size
        textView.frame.size.height = UIScreen.main.bounds.height - keyboardSize.height
    }
    
    // MARK: - FSNavigationControllerPopDelegate
    
    @objc public func navigationShouldPopOnBackButton() -> Bool {
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
