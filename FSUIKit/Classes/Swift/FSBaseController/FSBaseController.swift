//
//  FSBaseControllerS.swift
//  FSBaseController
//
//  Created by pwrd on 2026/1/29.
//

import Foundation

import FSKit

open class FSBaseController: UIViewController {
    
    var             _first_alloc_base       :   Bool                    =       false
    
    var             _cellDeselectIndexPath  :   IndexPath?               =       nil
    weak var        _cellDeselectView       :   UITableView?             =       nil
    
    var             _baseStatusBarOrientationNotification  :   Bool      =       false
    
    var             _onceBase_viewWillAppear:   Bool                     =       false
    var             _isVisibling            :   Bool                     =       false

    var             _back_tap_view          :   UIView?                  =       nil
    
    var             _baseComponentAmounted  :   Bool                     =       false
    
    var             _baseLoadingView        :   UIView?                  =        nil
    var             _baseBackView           :   UIView?                  =        nil
    
    var             _after_view_create      :   Bool                     =        false

    deinit {
        #if TARGET_IPHONE_SIMULATOR
        print("\(type(of: self)) dealloc")
        #else
        #endif
        
        let v = "\(type(of: self)) deinit"
        NotificationCenter.default.post(name: NSNotification.Name(FS_BE_DEBUG_NOTIFICATION), object: v)
                
        NotificationCenter.default.removeObserver(self)
    }
    
    open func afterViewCreate() -> Bool {
        if _after_view_create {
            return _after_view_create
        }
        _after_view_create = true
        return false
    }
    
    open func configCellDeselectView(tableView: UITableView, indexPath: IndexPath) {
        _cellDeselectIndexPath = indexPath
        _cellDeselectView = tableView
    }
    
    static var fitIOS15 : Bool = true
    static public func fitIOS15System() {
        FSBaseController.fitIOS15 = true
    }
    
    open func baseAddBarOrientationChangedNotification() {
        _baseStatusBarOrientationNotification = true
    }
    
    override open func viewWillTransition(to size: CGSize, with coordinator: any UIViewControllerTransitionCoordinator) {
        if _baseStatusBarOrientationNotification {
            handleOrientationDidChange()
        }
    }
    
    func handleOrientationDidChange() {
        let ws = FSKit.currentScene()
        guard let ws = ws else {
            return
        }
        
        let fo = ws.effectiveGeometry.interfaceOrientation
        baseHandleChangeStatusBarOrientation(orientation: fo)
    }
    
    open func baseHandleChangeStatusBarOrientation(orientation: UIInterfaceOrientation) {}
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if _onceBase_viewWillAppear == false {
            _onceBase_viewWillAppear = true
            
            // translucent为YES，self.view布局从屏幕顶部(0,0)开始，如果为NO会从导航栏底部开始
            self.navigationController?.navigationBar.isTranslucent = true
        }
        
        if (_cellDeselectIndexPath != nil) && (_cellDeselectView != nil) {
            _cellDeselectView!.deselectRow(at: _cellDeselectIndexPath! as IndexPath, animated: true)
            
            _cellDeselectView = nil
            _cellDeselectIndexPath = nil
        }
        
        
        if _first_alloc_base == false {
            _first_alloc_base = true
            
            let v = "\(type(of: self)) viewWillAppear"
            NotificationCenter.default.post(name: NSNotification.Name(FS_BE_DEBUG_NOTIFICATION), object: v)
        }

    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        _isVisibling = true
    }
        
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        _isVisibling = false
        
        if self.isMovingFromParent {
            self.disappearFraomParent()
        }
        
        checkForLeakIfLeaving()
    }
    
    open func disappearFraomParent() {}
    
    /// 内存泄漏自检：页面被 pop / dismiss 离场后，延迟若干秒检查自身是否已释放。
    /// 若仍存活且已脱离视图层级（parent / navigation / present / window 皆无），判定为疑似泄漏，
    /// 投递 FS_BE_LEAK_NOTIFICATION（object=提示文案）。是否弹 toast 由 App 层决定
    /// （基类不能反向依赖 FSJZKit 判 Fudon，否则与 FSJZKit→FSBaseController 形成循环依赖）。
    private func checkForLeakIfLeaving() {
        // 仅在「真正离场」时检查：pop（移出父控制器）或 modal dismiss
        guard isMovingFromParent || isBeingDismissed else { return }
        
        let clsName = "\(type(of: self))"
        weak let weakSelf = self   // 弱引用，检查本身绝不延长其生命周期
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            guard let vc = weakSelf else { return }   // 已正常释放
            // 仍存活但可能是「取消的返回手势 / 切 tab / 重新入栈」等——只要还挂在层级里就不算泄漏
            if vc.parent != nil
                || vc.navigationController != nil
                || vc.presentingViewController != nil
                || vc.isViewLoaded && vc.view.window != nil {
                return
            }
            
            // 存活且已脱离层级 → 疑似泄漏
            let msg = "疑似内存泄漏：\(clsName) 未释放"
            NotificationCenter.default.post(
                name: NSNotification.Name(FS_BE_LEAK_NOTIFICATION),
                object: msg
            )
            print("\(msg)")
            
        }
    }
        
    func fitIOS15() {
        if #available(iOS 15.0, *) {} else {
            return
        }
        
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        self.navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        
        let toolBarAppearance = UIToolbarAppearance()
        toolBarAppearance.backgroundColor = UIColor.white
        self.navigationController?.toolbar.scrollEdgeAppearance = toolBarAppearance
        self.navigationController?.toolbar.standardAppearance = toolBarAppearance
        
        
        let tabBarAppearance = UITabBarAppearance()
        toolBarAppearance.backgroundColor = UIColor.white
        self.tabBarController?.tabBar.scrollEdgeAppearance = tabBarAppearance
        self.tabBarController?.tabBar.standardAppearance = tabBarAppearance
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        if FSBaseController.fitIOS15 {
            fitIOS15()
        }
                
        let rgb = 0.95
        self.view.backgroundColor = UIColor.init(red: rgb, green: rgb, blue: rgb, alpha: 1.0)
                
        _back_tap_view = UIView(frame: self.view.bounds)
        self.view.addSubview(_back_tap_view!)
                
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapActionBase))
        _back_tap_view?.addGestureRecognizer(tap)
    }
    
    @objc open func tapActionBase() {
        self.view.endEditing(true)
    }
    
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if _baseComponentAmounted == false {
            _baseComponentAmounted = true
            
            _isVisibling = true
            
            componentWillMount()
        }
    }
    
    open func componentWillMount() {
        
        #if TARGET_IPHONE_SIMULATOR
        let vcs = self.navigationController?.viewControllers
        if vcs?.count >= 2 {
            let from = vcs?.index(of: vcs?.count - 2)
            print("\n \(type(of: from)) From \n")
        }
        #else
        #endif
        
        if self.navigationController != nil {
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        }
    }
    
    open func baseHandleDatas() {}
    open func baseDesignViews() {}
    
    open lazy var scrollView: FSTapScrollView = {
        
        let scrollView = FSTapScrollView(frame: CGRect(x: 0, y: self.view.safeAreaInsets.top, width: view.bounds.size.width, height: view.bounds.size.height - self.view.safeAreaInsets.top))
        scrollView.contentSize = CGSizeMake(view.bounds.size.width, view.bounds.size.height + 10)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.click = { [weak self] view in
            self?.tapActionBase()
        }

        if _back_tap_view == nil {
            self.view.addSubview(scrollView)
        } else {
            self.view.insertSubview(scrollView, aboveSubview: _back_tap_view!)
        }
        
        if self.navigationController != nil {
            FSKit.fitScrollViewOperate(scrollView, navigationController: self.navigationController)
        }
        
        return scrollView
    }()

    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    open func showWaitView(_ show: Bool) {
        
        if show {
            let blackWidth = 80
            let blackRect = CGRect(x: Int(view.bounds.size.width / 2 - 40.0), y: (Int(view.bounds.size.height) / 2 - 40), width: blackWidth, height: blackWidth)
            
            if _baseLoadingView != nil {
                self.view.bringSubviewToFront(_baseLoadingView!)
                _baseLoadingView!.frame = view.bounds
                _baseBackView?.frame = blackRect
            } else {
                _baseLoadingView = UIView(frame: view.bounds)
                self.view.addSubview(_baseLoadingView!)
                
                _baseBackView = UIView(frame: blackRect)
                _baseBackView?.alpha = 0.7
                _baseBackView?.backgroundColor = UIColor.black
                _baseBackView?.layer.cornerRadius = 6
                _baseLoadingView?.addSubview(_baseBackView!)
                
                let active = UIActivityIndicatorView.init(style: .large)
                active.frame = CGRect(x: 0, y: 0, width: Int(_baseBackView!.frame.size.width), height: Int(_baseBackView!.frame.size.height))
                active.startAnimating()
                _baseBackView?.addSubview(active)
                
            }
            
        } else {
            _baseLoadingView?.removeFromSuperview()
            _baseLoadingView = nil
        }
    }
    
    open lazy var fs_bottomView: UIView = {
        let h = self.view.safeAreaInsets.bottom + 45
        let bottomView = UIView(frame: CGRect(x: 0, y: view.bounds.size.height - h, width: view.bounds.size.width, height: h))
        bottomView.backgroundColor = UIColor.white
        view.addSubview(bottomView)
        return bottomView
    }()
    
}
