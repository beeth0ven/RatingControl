//
//  RatingControl.swift
//  RatingControl
//
//  Created by luojie on 16/3/22.
//  Copyright © 2016年 LuoJie. All rights reserved.
//

import UIKit
@IBDesignable

class RatingControl: UIControl {
    
    @IBInspectable
    var value: CGFloat = 5 {
        didSet {
            if oldValue != value {
                valueDidChange()
            }
        }
    }
    

    @IBInspectable
    var emptyImage: UIImage!
    
    @IBInspectable
    var fullImage: UIImage!
    
    private var emptyImageContentView: UIView!
    private var fullImageContentView: UIView!
    
    private var emptyImageView: UIImageView!
    private var fullImageView: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        loadViewIfNeeded()
    }
    
    private func loadViewIfNeeded() {
        if emptyImageContentView == nil {
            validatePropeties()
            
            emptyImageContentView = UIView(frame: bounds)
            addSubview(emptyImageContentView)
            
            fullImageContentView = UIView(frame: bounds)
            addSubview(fullImageContentView)
            
            for index in 0..<5 {
                
                let size = CGSize(width: imageViewWidth, height: bounds.height),
                center = CGPoint(x: (CGFloat(index) + 0.5) * cellWidth, y: bounds.height/2),
                
                imageView = UIImageView(frame: CGRect(center: center, size: size))
                imageView.contentMode = .ScaleToFill
                imageView.image = emptyImage
                emptyImageContentView.addSubview(imageView)
                
                let fullImageView = UIImageView(frame:imageView.frame)
                fullImageView.contentMode = .ScaleToFill
                fullImageView.image = fullImage
                fullImageContentView.addSubview(fullImageView)
            }
            
            upateMaskView()
        }
    }
    
    private func validatePropeties() {
        guard emptyImage != nil
            && fullImage != nil else {
                fatalError("image is not set!")
        }
        
        guard bounds.width >= imageViewWidth * 5 else {
            fatalError("Bound's width is less than mini width!")
        }
        
    }
    
    private var imageAspectRatio: CGFloat {
        return emptyImage.size.aspectRatio
    }
    
    private var cellWidth: CGFloat {
        return bounds.width / 5
    }
    
    private var imageViewOffset: CGFloat {
        let imageViewWidth = emptyImageContentView.subviews.first!.bounds.width
        return (cellWidth - imageViewWidth) / 2
    }
    
    private var imageViewWidth: CGFloat {
        return bounds.height * imageAspectRatio
    }
    
    private func valueDidChange() {
        sendActionsForControlEvents(.ValueChanged)
        upateMaskView()
    }
    
    private func upateMaskView() {
        guard fullImageContentView != nil else { return }
        let maskLayer = CALayer()
        maskLayer.frame = bounds
        maskLayer.frame.size.width = maskWidth
        maskLayer.backgroundColor = UIColor.blackColor().CGColor
        fullImageContentView.layer.mask = maskLayer
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.locationInView(self)
        maskWidth = location.x
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.locationInView(self)
        maskWidth = location.x
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.locationInView(self)
        maskWidth = location.x
    }
    
    private var maskWidth: CGFloat {
        get {
            let count = Int(value)
            let remain = value % 1
            return cellWidth * CGFloat(count) + imageViewOffset + remain * imageViewWidth
        }
        set {
            let count = Int(newValue / cellWidth)
            var remain = newValue % cellWidth
            remain = (remain - imageViewOffset) / imageViewWidth
            remain = max(0, min(remain, 1))
            var rates = CGFloat(count) + remain
            rates -= rates % 0.5
            value = max(0, min(rates, 5))
        }
    }
}

extension CGRect {
    
    init(center: CGPoint, size: CGSize) {
        self.init(origin: CGPoint.zero, size: size)
        self.center = center
    }
    
    var center: CGPoint {
        get { return CGPoint(x: origin.x + size.width / 2, y: origin.y + size.height / 2) }
        set { origin = CGPoint(x: newValue.x - size.width / 2, y: newValue.y - size.height / 2) }
    }
}

extension CGSize {
    var aspectRatio: CGFloat {
        return width / height
    }
}

