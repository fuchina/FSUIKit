//
//  FSImageLabelView.swift
//  FSUIKit
//
//  Created by Dongdong Fu on 2026/1/31.
//

import Foundation

public class FSImageLabelViewS: FSViewS {
    
    var                 imageView                   :  UIImageView?                  =  nil
    var                 label                       :  UILabel?                      =  nil

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
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[_imageView(35)]", metrics: nil, views: ["imageView": imageView!]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[_imageView(35)]", metrics: nil, views: ["imageView": imageView!]))
        self.addConstraint(NSLayoutConstraint(item: imageView!, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: imageView!, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: -10))

        label = UILabel()
        label?.translatesAutoresizingMaskIntoConstraints = false
        label?.font = UIFont.systemFont(ofSize: 13)
        label?.textAlignment = .center
        self.addSubview(label!)
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[_label]-0-|", metrics: nil, views: ["label": label!]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[_label(30)]", metrics: nil, views: ["label": label!]))
        self.addConstraint(NSLayoutConstraint(item: label!, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0))
    }
    
    public static func imageLabel(_ frame: CGRect, imageName: String, text: String) -> FSImageLabelViewS {
        
        let view = FSImageLabelViewS(frame: frame)
        view.label?.text = text

        let image = UIImage(named: imageName)
        view.imageView?.image = image
        return view
    }
}
