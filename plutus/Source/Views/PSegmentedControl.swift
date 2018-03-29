//
//  PSegmentedControl.swift
//  plutus
//
//  Created by Eddie Long on 27/03/2018.
//  Copyright © 2018 eddielong. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class PSegmentedControl: UIControl {
    private var labels = [UILabel]()
    var thumbView = UIView()
    
    @IBInspectable var items : [String] = [] {
        didSet {
            setupLabels()
        }
    }
    
    @IBInspectable var item0 : String = "" {
        didSet {
            setItem(at: 0, value: item0)
        }
    }
    
    @IBInspectable var item1 : String = "" {
        didSet {
            setItem(at: 1, value: item1)
        }
    }
    
    @IBInspectable var item2 : String = "" {
        didSet {
            setItem(at: 2, value: item2)
        }
    }
    
    @IBInspectable var item3 : String = "" {
        didSet {
            setItem(at: 3, value: item3)
        }
    }
    
    @IBInspectable var item4 : String = "" {
        didSet {
            setItem(at: 4, value: item4)
        }
    }
    
    @IBInspectable var item5 : String = "" {
        didSet {
            setItem(at: 5, value: item5)
        }
    }
    
    private func setItem(at: Int, value: String) {
        if (items.count > at + 1) {
            items[at] = value
        } else {
            var newArray = [String](repeating: "", count: at + 1)
            var index = 0
            for item in items {
                newArray[index] = item
                index = index + 1
            }
            newArray[at] = value
            items = newArray
        }
    }
    
    @IBInspectable var selectedLabelColor : UIColor = UIColor.black {
        didSet {
            setSelectedColors()
        }
    }
    
    @IBInspectable var unselectedLabelColor : UIColor = UIColor.white {
        didSet {
            setSelectedColors()
        }
    }
    
    @IBInspectable var thumbColor : UIColor = UIColor.white {
        didSet {
            setSelectedColors()
        }
    }
    
    @IBInspectable var borderColor : UIColor = UIColor.white {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var font : UIFont! = UIFont.systemFont(ofSize: 8) {
        didSet {
            setFont()
        }
    }
    
    var selectedIndex : Int = 0 {
        didSet {
            displayNewSelectedIndex()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let labelWidth = self.bounds.width / CGFloat(labels.count)
        let labelHeight = self.bounds.height
        for index in 0...labels.count - 1 {
            let label = labels[index]
            let xPosition = CGFloat(index) * labelWidth
            label.frame = CGRect.init(x: xPosition, y: 0, width: labelWidth, height: labelHeight)
            
        }
        
        var selectFrame = self.bounds
        let newWidth = selectFrame.width / CGFloat(items.count)
        selectFrame.size.width = newWidth
        thumbView.frame = selectFrame
        thumbView.backgroundColor = thumbColor
        thumbView.layer.cornerRadius = thumbView.frame.height / 2
        
        displayNewSelectedIndex()
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        var calculatedIndex = -1
        var index = 0
        for item in labels {
            if item.frame.contains(location) {
                calculatedIndex = index
                break
            }
            index = index + 1
        }
        
        if (calculatedIndex != -1) {
            selectedIndex = calculatedIndex
            sendActions(for: .valueChanged)
        }
        
        return false
    }
    
    func setupView() {
        layer.cornerRadius = self.frame.height / 2
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 2
        
        backgroundColor = UIColor.clear
        
        setupLabels()
        addIndividualItemConstraints(items: labels, mainView: self, padding: 0)
        
        insertSubview(thumbView, at: 0)
    }
    
    func setupLabels() {
        for label in labels {
            label.removeFromSuperview()
        }
        labels.removeAll(keepingCapacity: true)
        
        var index = 0
        for item in items {
            let label = UILabel(frame: CGRect.zero)
            label.text = item
            label.textAlignment = .center
            label.textColor = UIColor.green
            label.font = font
            label.textColor = index == 1 ? selectedLabelColor : unselectedLabelColor
            label.translatesAutoresizingMaskIntoConstraints = false
            labels.append(label)
            self.addSubview(label)
            index = index + 1
        }
    }
    
    func displayNewSelectedIndex() {
        for item in labels {
            item.textColor = unselectedLabelColor
        }
        
        var label = labels[selectedIndex]
        label.textColor = selectedLabelColor
        
        UIView.animate(withDuration: 0.5) {
            self.thumbView.frame = label.frame
        }
    }
    
    func setSelectedColors(){
        for item in labels {
            item.textColor = unselectedLabelColor
        }
        
        if labels.count > 0 {
            labels[0].textColor = selectedLabelColor
        }
        
        thumbView.backgroundColor = thumbColor
    }
    
    func addIndividualItemConstraints(items: [UIView], mainView: UIView, padding: CGFloat) {
        
        let constraints = mainView.constraints
        
        var index = 0
        for button in items {
            
            var topConstraint = NSLayoutConstraint(item: button, attribute: .top, relatedBy: .equal, toItem: mainView, attribute: .top, multiplier: 1.0, constant: 0)
            
            var bottomConstraint = NSLayoutConstraint(item: button, attribute: .bottom, relatedBy: .equal, toItem: mainView, attribute: .bottom, multiplier: 1.0, constant: 0)
            
            var rightConstraint : NSLayoutConstraint!
            
            if index == items.count - 1 {
                
                rightConstraint = NSLayoutConstraint(item: button, attribute: .right, relatedBy: .equal, toItem: mainView, attribute: .right, multiplier: 1.0, constant: -padding)
                
            }else{
                
                let nextButton = items[index+1]
                rightConstraint = NSLayoutConstraint(item: button, attribute: .right, relatedBy: .equal, toItem: nextButton, attribute: .left, multiplier: 1.0, constant: -padding)
            }
            
            
            var leftConstraint : NSLayoutConstraint!
            
            if index == 0 {
                
                leftConstraint = NSLayoutConstraint(item: button, attribute: .left, relatedBy: .equal, toItem: mainView, attribute: .left, multiplier: 1.0, constant: padding)
                
            }else{
                
                let prevButton = items[index-1]
                leftConstraint = NSLayoutConstraint(item: button, attribute: .left, relatedBy: .equal, toItem: prevButton, attribute: .right, multiplier: 1.0, constant: padding)
                
                let firstItem = items[0]
                
                var widthConstraint = NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: firstItem, attribute: .width, multiplier: 1.0  , constant: 0)
                
                mainView.addConstraint(widthConstraint)
            }
            
            mainView.addConstraints([topConstraint, bottomConstraint, rightConstraint, leftConstraint])
            index = index + 1
        }
    }
    
    func setFont(){
        for item in labels {
            item.font = font
        }
    }
}
