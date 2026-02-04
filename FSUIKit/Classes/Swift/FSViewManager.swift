// FSViewManagerS.swift
// Translated from FSViewManager.h/m

import UIKit

public let FS_LineThickness: CGFloat = 0.5

@objcMembers
open class FSViewManager: UIView {
    
    public static func view(withFrame frame: CGRect, backColor color: UIColor?) -> UIView {
        let view = UIView(frame: frame)
        if let c = color {
            view.backgroundColor = c
        }
        return view
    }
    
    public static func imageView(withFrame frame: CGRect, imageName: String?) -> UIImageView {
        let imageView = UIImageView(frame: frame)
        if let name = imageName, let image = UIImage(named: name) {
            imageView.image = image
        }
        imageView.contentMode = .scaleAspectFit
        return imageView
    }
    
    public static func separateView(withFrame frame: CGRect) -> UIView {
        let view = UIView(frame: frame)
        let rgb: CGFloat = 230 / 255.0
        view.backgroundColor = UIColor(red: rgb, green: rgb, blue: rgb, alpha: 1)
        return view
    }
    
    public static func bbi(withTitle title: String, target: Any?, action selector: Selector) -> UIBarButtonItem {
        return UIBarButtonItem(title: title, style: .plain, target: target, action: selector)
    }
    
    public static func bbi(withSystemType type: UIBarButtonItem.SystemItem, target: Any?, action selector: Selector) -> UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: type, target: target, action: selector)
    }
    
    public static func segmentedControl(withTitles titles: [String], target: Any?, action selector: Selector) -> UISegmentedControl {
        let control = UISegmentedControl(items: titles)
        control.addTarget(target, action: selector, for: .valueChanged)
        return control
    }
    
    public static func button(withFrame frame: CGRect, title: String?, titleColor color: UIColor?, backColor: UIColor?, font: UIFont?, tag: Int, target: Any?, selector: Selector?) -> UIButton {
        let button = UIButton(type: .system)
        button.frame = frame
        if let t = title {
            button.setTitle(t, for: .normal)
        }
        button.setTitleColor(color ?? .white, for: .normal)
        if let bc = backColor {
            button.backgroundColor = bc
        }
        if let t = target, let s = selector {
            button.addTarget(t, action: s, for: .touchUpInside)
        }
        if let f = font {
            button.titleLabel?.font = f
        }
        button.tag = tag
        button.layer.cornerRadius = 3
        return button
    }
    
    public static func submitButton(withTop top: CGFloat, tag: Int, target: Any?, selector: Selector) -> UIButton {
        let color = UIColor(red: 18/255.0, green: 152/255.0, blue: 233/255.0, alpha: 1)
        let button = self.button(withFrame: CGRect(x: 20, y: top, width: UIScreen.main.bounds.width - 40, height: 44), title: "提交", titleColor: .white, backColor: color, font: nil, tag: tag, target: target, selector: selector)
        button.layer.cornerRadius = 3
        return button
    }
    
    public static func barButtonItem(withCustomButton button: UIButton) -> UIBarButtonItem {
        return UIBarButtonItem(customView: button)
    }
    
    public static func barButtonItem(withTitle title: String, target: Any?, selector: Selector, tintColor: UIColor?) -> UIBarButtonItem {
        let bbi = UIBarButtonItem(title: title, style: .plain, target: target, action: selector)
        if let tc = tintColor {
            bbi.tintColor = tc
        }
        return bbi
    }
    
    public static func tableView(withFrame frame: CGRect, delegate: (UITableViewDelegate & UITableViewDataSource)?, style: UITableView.Style, footerView: UIView?) -> UITableView {
        let tableView = UITableView(frame: frame, style: style)
        tableView.delegate = delegate
        tableView.dataSource = delegate
        if let fv = footerView {
            tableView.tableFooterView = fv
        }
        return tableView
    }
    
    @available(iOS 6.0, *)
    public static func label(withFrame frame: CGRect, text: String?, textColor: UIColor?, backColor: UIColor?, font: UIFont?, textAlignment: NSTextAlignment) -> UILabel {
        let label = UILabel(frame: frame)
        label.text = text
        if let tc = textColor {
            label.textColor = tc
        }
        if let bc = backColor {
            label.backgroundColor = bc
        }
        if let f = font {
            label.font = f
        }
        label.textAlignment = textAlignment
        return label
    }
    
    public static func suojinLabel(withSpace space: CGFloat, frame rect: CGRect, textColor: UIColor?, text: String?) -> UILabel {
        let label = UILabel(frame: rect)
        
        let attributedString = NSMutableAttributedString(string: text ?? "")
        if let tc = textColor {
            attributedString.addAttribute(.foregroundColor, value: tc, range: NSRange(location: 0, length: attributedString.length))
        }
        
        let style = NSMutableParagraphStyle()
        style.firstLineHeadIndent = space
        attributedString.addAttribute(.paragraphStyle, value: style, range: NSRange(location: 0, length: attributedString.length))
        label.attributedText = attributedString
        return label
    }
    
    @available(iOS 6.0, *)
    public static func tapLabel(withFrame frame: CGRect, text: String?, textColor: UIColor?, backColor: UIColor?, font: UIFont?, textAlignment: NSTextAlignment, block: FSTapLabelBlockS?) -> FSTapLabel {
        let label = FSTapLabel(frame: frame)
        label.text = text
        if let tc = textColor {
            label.textColor = tc
        }
        if let bc = backColor {
            label.backgroundColor = bc
        }
        if let f = font {
            label.font = f
        }
        label.block = block
        label.textAlignment = textAlignment
        return label
    }
    
    public static func tapCell(withText text: String?, textColor: UIColor?, font: UIFont?, detailText: String?, detailColor: UIColor?, detailFont: UIFont?, block: TapCellBlock?) -> FSTapCell {
        return tapCell(withText: text, textColor: textColor, font: font, detailText: detailText, detailColor: detailColor, detailFont: detailFont, frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44), block: block)
    }
    
    public static func tapCell(withText text: String?, textColor: UIColor?, font: UIFont?, detailText: String?, detailColor: UIColor?, detailFont: UIFont?, frame: CGRect, block: TapCellBlock?) -> FSTapCell {
        let cell = FSTapCell(frame: frame)
        if let t = text {
            cell.textLabel.text = t
        }
        if let tc = textColor {
            cell.textLabel.textColor = tc
        }
        if let f = font {
            cell.textLabel.font = f
        }
        if let dt = detailText {
            cell.detailTextLabel.text = dt
        }
        if let dc = detailColor {
            cell.detailTextLabel.textColor = dc
        }
        if let df = detailFont {
            cell.detailTextLabel.font = df
        }
        cell.click = block
        return cell
    }
    
    public static func textField(withFrame frame: CGRect, placeholder holder: String?, textColor: UIColor?, backColor: UIColor?) -> UITextField {
        let textField = UITextField(frame: frame)
        textField.placeholder = holder
        if let tc = textColor {
            textField.textColor = tc
        }
        if let bc = backColor {
            textField.backgroundColor = bc
        }
        textField.autocorrectionType = .no
        textField.clearButtonMode = .whileEditing
        textField.autocapitalizationType = .none
        return textField
    }
    
    public static func textField(withFrame frame: CGRect, placeholder holder: String?, textColor: UIColor?, onlyChars only: Bool) -> UITextField {
        let textField = UITextField(frame: frame)
        textField.placeholder = holder
        if let tc = textColor {
            textField.textColor = tc
        }
        textField.autocorrectionType = .no
        textField.clearButtonMode = .whileEditing
        textField.autocapitalizationType = .none
        if only {
            textField.keyboardType = .asciiCapable
        }
        return textField
    }
}
