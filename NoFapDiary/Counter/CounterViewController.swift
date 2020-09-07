//
//  CounterViewController.swift
//  NoFapDiary
//
//  Created by 김상진 on 2020/09/01.
//  Copyright © 2020 kipCalm. All rights reserved.
//

import UIKit
import HGCircularSlider

class CounterViewController: UIViewController {
    
    var shapeLayer: CAShapeLayer!
    var pulseLayer: CAShapeLayer!
    
    let percentageLabel: UILabel = {
        let label = UILabel()
        label.text = "Start"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textColor = .white
        return label
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNotificationObservers()
        
        view.backgroundColor = .backgroundColor
        
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
        
        //pulse Layer
        pulseLayer = createCircleShapeLayer(storkeColor: UIColor.clear.cgColor, fillColor: UIColor.pulsatingFillColor.cgColor, lineWidth: 10)
        view.layer.addSublayer(pulseLayer)
        animatePulseLayer(layer: pulseLayer)
        
        //track Layer
        let trackLayer = createCircleShapeLayer(storkeColor: UIColor.trackStrokeColor.cgColor, fillColor: UIColor.backgroundColor.cgColor, lineWidth: 20)
        view.layer.addSublayer(trackLayer)
        
        //percent Layer
        shapeLayer = createCircleShapeLayer(storkeColor: UIColor.outlineStrokeColor.cgColor, fillColor: UIColor.clear.cgColor, lineWidth: 20)
        shapeLayer.strokeEnd = 0
        shapeLayer.lineCap = .round
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi/2, 0, 0, 1)
        view.layer.addSublayer(shapeLayer)

        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        
        view.addSubview(percentageLabel)
        percentageLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        percentageLabel.center = view.center
    }
    
    private func createCircleShapeLayer(storkeColor: CGColor, fillColor: CGColor, lineWidth: CGFloat) -> CAShapeLayer {
        let layer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
        layer.path = circularPath.cgPath
        layer.strokeColor = storkeColor
        layer.lineWidth = lineWidth
        layer.fillColor = fillColor
        layer.position = view.center
        return layer
    }
    
    @objc private func handleTap() {
//        let basicAnim = CABasicAnimation(keyPath: "strokeEnd")
//        basicAnim.duration = 3
//        basicAnim.fillMode = .forwards
//        basicAnim.isRemovedOnCompletion = false
//
//        shapeLayer.add(basicAnim, forKey: "basicAnim")
        DispatchQueue.main.async {
            //이 strokeEnd를 건드려서 조정 가능
            self.shapeLayer.strokeEnd = 0.5
        }
    }
    
    private func animatePulseLayer(layer: CAShapeLayer) {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        
        animation.toValue = 1.5
        animation.duration = 0.8
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        
        layer.add(animation, forKey: "pulsing")
    }
    
    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc private func handleEnterForeground() {
        animatePulseLayer(layer: pulseLayer)
    }

}
