// FSVanViewS.swift
// Translated from FSVanView.h/m

import UIKit

public enum FSLoadingStatus: Int {
    case `default` = 0   // 无状态
    case loading = 1     // 加载中
    case noData = 2      // 无数据
    case noNet = 3       // 网络失败
}

public enum FSClickModeS: Int {
    case refresh = 0     // 刷新
    case other = 1       // 其他
}

public class FSVanView: UIView {
    
    private var _roundView: FSRoundVanView!
    private var _label: FSLabel?
    
    public var label: FSLabel {
        if _label == nil {
            let size = frame.size
            let lbl = FSLabel(frame: CGRect(x: 15, y: (size.height - 60) / 2, width: size.width - 30, height: 60))
            lbl.font = UIFont.systemFont(ofSize: 14)
            lbl.textColor = UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1.0)
            lbl.textAlignment = .center
            addSubview(lbl)
            _label = lbl
        }
        return _label!
    }
    
    public var status: FSLoadingStatus = .default {
        didSet {
            switch status {
            case .loading:
                _label?.isHidden = true
                _roundView.start()
            case .noData:
                _roundView.stop()
                _roundView.isHidden = true
                _label?.isHidden = false
            default:
                break
            }
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        vanDesignViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        vanDesignViews()
    }
    
    private func vanDesignViews() {
        backgroundColor = .white
        let size = frame.size
        
        let a: CGFloat = 1
        let b: CGFloat = 1
        _roundView = FSRoundVanView(frame: CGRect(x: size.width / 2 - 12, y: size.height / 2 - 12, width: 24, height: 24))
        _roundView.start()
        let grayColor = UIColor(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1.0)
        _roundView.circleArray = [
            ["a": UIColor(red: 18/255.0, green: 152/255.0, blue: 233/255.0, alpha: 1), "b": NSNumber(value: Float(a / (a + b)))],
            ["a": grayColor, "b": NSNumber(value: Float(b / (a + b)))]
        ]
        addSubview(_roundView)
    }
    
    public func dismiss() {
        isHidden = true
        removeFromSuperview()
    }
}

public class FSRoundVanView: UIView {
    
    private var link: CADisplayLink?
    private var count: Int = 0
    
    public var circleArray: [[String: Any]]? {
        didSet {
            setupCircles()
        }
    }
    
    private func setupCircles() {
        guard let circles = circleArray else { return }
        
        var a: Float = 0
        for obj in circles {
            guard let color = obj["a"] as? UIColor,
                  let bValue = obj["b"] as? NSNumber else { continue }
            
            let shapeLayer = CAShapeLayer()
            shapeLayer.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
            shapeLayer.fillColor = UIColor.clear.cgColor
            shapeLayer.lineWidth = 2
            shapeLayer.strokeColor = color.cgColor
            
            let circlePath = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height))
            shapeLayer.path = circlePath.cgPath
            shapeLayer.strokeStart = CGFloat(a)
            shapeLayer.strokeEnd = CGFloat(bValue.floatValue + a)
            a = Float(shapeLayer.strokeEnd)
            layer.addSublayer(shapeLayer)
        }
    }
    
    public func start() {
        if link == nil {
            link = CADisplayLink(target: self, selector: #selector(execAnimation))
            link?.add(to: .main, forMode: .common)
        }
        link?.isPaused = false
    }
    
    public func stop() {
        link?.isPaused = true
    }
    
    @objc private func execAnimation() {
        let shares: CGFloat = 25.0
        let delta = 2 * CGFloat.pi / shares
        transform = CGAffineTransform(rotationAngle: CGFloat(count) * delta)
        count += 1
        if count > Int(shares * 1000) {
            count = 0
            transform = CGAffineTransform(rotationAngle: 0)
        }
    }
}
