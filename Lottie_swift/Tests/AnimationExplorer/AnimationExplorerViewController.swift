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
        
        let animation = Animation.named("LottieLogo2")
        self.animationPlayerView.contentMode = .scaleAspectFill
        self.animationPlayerView.animation = animation
        self.animationPlayerView.layer.borderWidth = 1
        self.animationPlayerView.layer.borderColor = UIColor.red.cgColor
        self.view.addSubview(self.animationPlayerView)
    }
    
    func setupLayouts() -> Void {
        self.animationPlayerView.translatesAutoresizingMaskIntoConstraints = false
        self.animationPlayerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.animationPlayerView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.animationPlayerView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
//        self.animationPlayerView.bottomAnchor.constraint(lessThanOrEqualTo: self.stackView.topAnchor).isActive = true
    }
}
