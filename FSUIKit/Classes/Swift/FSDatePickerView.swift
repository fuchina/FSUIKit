// FSDatePickerView.swift
// Translated from FSDatePickerView.h/m

import UIKit

public typealias FSDatePickerBlock = (Date) -> Void

public class FSDatePickerView: UIView {
    
    private var mainView: UIView!
    private var datePicker: UIDatePicker!
    private var _date: Date?
    
    public var block: FSDatePickerBlock?
    public var cancel: (() -> Void)?
    
    public convenience init(frame: CGRect, date: Date?) {
        self.init(frame: frame)
        _date = date
        dpDesignViews()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        dpDesignViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        dpDesignViews()
    }
    
    private func dpDesignViews() {
        let backView = UIView(frame: bounds)
        backView.backgroundColor = .black
        backView.alpha = 0.28
        addSubview(backView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        backView.addGestureRecognizer(tapGesture)
        
        let size = bounds.size
        mainView = UIView(frame: CGRect(x: 0, y: size.height, width: size.width, height: 240 + 34))
        mainView.backgroundColor = .white
        addSubview(mainView)
        
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.frame = CGRect(x: 0, y: 40, width: bounds.width, height: 200)
        datePicker.locale = Locale(identifier: "zh-CN")
        datePicker.minimumDate = Date().addingTimeInterval(-100 * 365 * 24 * 3600)
        datePicker.maximumDate = Date().addingTimeInterval(100 * 365 * 24 * 3600)
        mainView.addSubview(datePicker)
        
        if let date = _date {
            datePicker.date = date
        } else {
            datePicker.date = Date()
        }
        
        let selectView = UIView(frame: CGRect(x: 0, y: 0, width: mainView.bounds.width, height: 40))
        selectView.backgroundColor = UIColor(red: 18/255.0, green: 152/255.0, blue: 233/255.0, alpha: 1.0)
        mainView.addSubview(selectView)
        
        for x in 0..<2 {
            let button = UIButton(type: .system)
            button.frame = CGRect(x: CGFloat(x) * (selectView.bounds.width - 60), y: 0, width: 60, height: 40)
            button.setTitle(x == 1 ? "确认" : "取消", for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            button.tag = x
            button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
            selectView.addSubview(button)
        }
        
        let comp = Self.component(for: Date())
        let title = "今天是\(comp.month ?? 0)月\(comp.day ?? 0)日"
        let timeLabel = UILabel(frame: CGRect(x: 60, y: 0, width: size.width - 120, height: selectView.bounds.height))
        timeLabel.textColor = .white
        timeLabel.font = UIFont.systemFont(ofSize: 14)
        timeLabel.textAlignment = .center
        timeLabel.text = title
        selectView.addSubview(timeLabel)
        
        showAction(true)
    }
    
    @objc private func tapAction() {
        cancel?()
        showAction(false)
    }
    
    @objc private func buttonAction(_ button: UIButton) {
        if button.tag == 1 {
            block?(datePicker.date)
            showAction(false)
        } else {
            tapAction()
        }
    }
    
    private func showAction(_ show: Bool) {
        if show {
            UIView.animate(withDuration: 0.3) {
                self.mainView.frame = CGRect(x: self.mainView.frame.origin.x, y: self.frame.height - 240 - 34, width: self.mainView.bounds.width, height: self.mainView.bounds.height)
            }
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.mainView.frame = CGRect(x: self.mainView.frame.origin.x, y: self.frame.height, width: self.mainView.bounds.width, height: self.mainView.bounds.height)
            }, completion: { _ in
                self.removeFromSuperview()
            })
        }
    }
    
    public static func component(for date: Date) -> DateComponents {
        let calendar = Calendar(identifier: .gregorian)
        return calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .weekOfMonth, .weekday, .weekOfYear], from: date)
    }
}
