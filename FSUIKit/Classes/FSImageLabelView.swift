//
//  FSImageLabelView.swift
//  FSUIKit
//
//  Created by Dongdong Fu on 2026/1/31.
//

import Foundation

@objc
public class FSImageLabelView: FSViewS {
    
    public var          imageView                   :  UIImageView?                  =  nil
    public var          label                       :  UILabel?                      =  nil

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.imageLabelDesignViews()
    }
    
    @MainActor required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func imageLabelDesignViews() {
        
        imageView = UIImageView()
        imageView?.translatesAutoresizingMaskIntoConstraints = false
        imageView?.contentMode = .scaleAspectFill
        self.addSubview(imageView!)
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[imageView(35)]", metrics: nil, views: ["imageView": imageView!]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[imageView(35)]", metrics: nil, views: ["imageView": imageView!]))
        self.addConstraint(NSLayoutConstraint(item: imageView!, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: imageView!, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: -10))

        label = UILabel()
        label?.translatesAutoresizingMaskIntoConstraints = false
        label?.font = UIFont.systemFont(ofSize: 13)
        label?.textAlignment = .center
        self.addSubview(label!)
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[label]-0-|", metrics: nil, views: ["label": label!]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[label(30)]", metrics: nil, views: ["label": label!]))
        self.addConstraint(NSLayoutConstraint(item: label!, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0))
    }
    
    @objc public static func imageLabel(_ frame: CGRect, imageName: String, text: String) -> FSImageLabelView {
        
//        print("FSLog fr = ", frame)
        
        let view = FSImageLabelView(frame: frame)
        view.label?.text = text

        let image = UIImage(named: imageName)
        view.imageView?.image = image
        return view
    }
}
