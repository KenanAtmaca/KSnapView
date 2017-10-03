//
//  KSnapView
//
//  Copyright © 2017 Kenan Atmaca. All rights reserved.
//  kenanatmaca.com
//
//

import UIKit

protocol KSnapViewDelegate:class {
    func didChange(index:Int)
    func finished(flag:Bool)
}

class KSnapView {
    
    private var contentViews:[UIView] = []
    private var rootView:UIView!
    private var contentStack:UIStackView!
    private var counter:Int = 0
    private var autoTimer:Timer!
    
    var delegate:KSnapViewDelegate?
    var count:Int = 1
    var duration:Double = 5.0

    init(to: UIViewController) {
        self.rootView = to.view
    }
    
     func setup() {
        
        contentViews = []
        
        for _ in 0..<count {
           
            let contentView = UIView()
            contentView.frame = CGRect(x: 0, y: 0, width: (rootView.frame.width - 30.0) / CGFloat(count), height: 8)
            contentView.backgroundColor = UIColor.white.withAlphaComponent(0.4)
            contentView.layer.cornerRadius = 4
            
            let contentSubLayer = CALayer()
            contentSubLayer.frame = contentView.frame
            contentSubLayer.cornerRadius = 4
            contentSubLayer.backgroundColor = UIColor.white.cgColor
            contentSubLayer.frame.size.width = 0
            contentSubLayer.anchorPoint = CGPoint(x: 0, y: contentView.layer.anchorPoint.y)
            contentView.layer.addSublayer(contentSubLayer)
            
            contentViews.append(contentView)
        }
    
        contentStack = UIStackView(arrangedSubviews: contentViews)
        contentStack.alignment = .fill
        contentStack.distribution = .fillEqually
        contentStack.spacing = 3.0
        contentStack.axis = .horizontal
        rootView.addSubview(contentStack)
    
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.widthAnchor.constraint(equalTo: rootView.widthAnchor, multiplier: 0.93).isActive = true
        contentStack.heightAnchor.constraint(equalToConstant: 8).isActive = true
        contentStack.topAnchor.constraint(equalTo: rootView.topAnchor, constant: 20).isActive = true
        contentStack.centerXAnchor.constraint(equalTo: rootView.centerXAnchor, constant: 0).isActive = true
        
        autoNext()
        autoTimer = Timer.scheduledTimer(timeInterval: duration, target: self, selector: #selector(autoNext), userInfo: nil, repeats: true)
    }
    
    private func setAnimation(index:Int) {
        
        contentViews.forEach { (view) in
            view.layer.sublayers?.forEach({ (layer) in
                layer.removeAllAnimations()
            })
        }
        
        let anim = CABasicAnimation(keyPath: "bounds.size.width")
        anim.duration = duration
        anim.fromValue = 0
        anim.toValue = contentViews[0].frame.width
        anim.isRemovedOnCompletion = false
        anim.fillMode = kCAFillModeForwards
        
        contentViews[index].layer.sublayers?.first?.add(anim, forKey: nil)
    }

    @objc func autoNext() {
        
        if counter < count {
            
            delegate?.finished(flag: false)
            delegate?.didChange(index: counter)
            setAnimation(index: counter)
            
        } else {
            counter = -1
            prevNext()
            delegate?.finished(flag: true)
        }
        
        counter += 1
    }
    
    private func prevNext() {
        
        counter += 1
        autoTimer.invalidate()
      
        if counter != count {
            
            delegate?.finished(flag: false)
            delegate?.didChange(index: counter)
            setAnimation(index: counter)
            autoTimer = Timer.scheduledTimer(timeInterval: duration, target: self, selector: #selector(autoNext), userInfo: nil, repeats: true)
            
        } else {
            delegate?.finished(flag: true)
            counter = -1
        }
    }
  
    func next() {
        
        autoTimer.invalidate()
        
        if counter != count {
            
            delegate?.finished(flag: false)
            delegate?.didChange(index: counter)
            setAnimation(index: counter)
            autoTimer = Timer.scheduledTimer(timeInterval: duration, target: self, selector: #selector(autoNext), userInfo: nil, repeats: true)
            
        } else {
        
            delegate?.finished(flag: true)
            counter = -1
        }
        
         counter += 1
    }
    
    func remove() {
        
        counter = 0
        autoTimer.invalidate()
        contentStack.removeFromSuperview()
        contentViews.removeAll()
    }
    
}//
