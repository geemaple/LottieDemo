//
//  AnimationExplorerViewController.swift
//  Lottie_swift
//
//  Created by jixiangfeng on 2021/6/10.
//

import UIKit
import Lottie

class AnimationExplorerViewController: UIViewController {
    
    let animationPlayerView = AnimationView()
    let stackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
        self.setupLayouts()
    }
    
    func setupViews() -> Void {
        self.view.backgroundColor = UIColor.white
        
        let animation = Animation.named("LottieLogo1")
        self.animationPlayerView.contentMode = .scaleAspectFill
        self.animationPlayerView.animation = animation
        self.animationPlayerView.layer.borderWidth = 1
        self.animationPlayerView.layer.borderColor = UIColor.red.cgColor
        self.view.addSubview(self.animationPlayerView)
        
        self.debugPerspective()
        self.animationPlayerView.play()
    }
    
    func debugPerspective() -> Void {
        let rotationGesture = UIPanGestureRecognizer(target: self, action: #selector(AnimationExplorerViewController.handleGeature(gesture:)))
        self.view.addGestureRecognizer(rotationGesture)
        
        var perspective = CATransform3DIdentity;
        perspective.m34 = -1.0/10000;
        self.animationPlayerView.layer.sublayerTransform = perspective;
        self.helper(layer: self.animationPlayerView.layer, zIndex: 1000)
    }
    
    func helper(layer: CALayer, zIndex: CGFloat) -> Void {
        let count = layer.sublayers?.count ?? 0
        for i in 0..<count {
            let layer = (layer.sublayers?[i])! as CALayer
            layer.zPosition = zIndex + CGFloat(i)
            self.helper(layer: layer, zIndex: zIndex + 1000)
            layer.borderWidth = 1
            layer.borderColor = UIColor.red.cgColor
            print("layer \(layer.zPosition) + \(layer.self) + \(layer.bounds)")
        }
    }
    
    func setupLayouts() -> Void {
        self.animationPlayerView.translatesAutoresizingMaskIntoConstraints = false
        self.animationPlayerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.animationPlayerView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.animationPlayerView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.animationPlayerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    @objc func handleGeature(gesture: UIPanGestureRecognizer) -> Void {
        let translation = gesture.translation(in: gesture.view).x
        self.animationPlayerView.layer.transform = CATransform3DMakeRotation(translation / CGFloat.pi / 2 , 0, 1, 0)
    }
}
