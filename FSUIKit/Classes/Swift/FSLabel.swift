// FSLabelS.swift
// Translated from FSLabel.h/m

import UIKit

public class FSLabel: UILabel {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        numberOfLines = 0
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        numberOfLines = 0
    }
    
    public override var text: String? {
        didSet {
            let savedFrame = frame
            sizeToFit()
            frame = CGRect(x: savedFrame.origin.x, y: savedFrame.origin.y, width: savedFrame.width, height: frame.height)
        }
    }
    
    public override var font: UIFont! {
        didSet {
            // Trigger text setter to recalculate size
            let currentText = text
            text = currentText
        }
    }
}
