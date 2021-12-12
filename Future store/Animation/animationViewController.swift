//
//  animationViewController.swift
//  Future store
//
//  Created by Mohammed Abdullah on 08/05/1443 AH.
//

import UIKit

class animationViewController: UIViewController {

    @IBOutlet weak var imageViewAnimation: UIImageView!
    @IBOutlet weak var lableAnimation: UILabel!
    @IBOutlet weak var loginAnimation: UIButton!
    @IBOutlet weak var signUpAnimation: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        ImegViewAnimation()
        
        lableAnimation.center.x = -view.frame.width
        let uiAanimationLabal = UIViewPropertyAnimator(duration: 2, curve: .easeIn, animations: {
            self.lableAnimation.center.x = 0
        })
        uiAanimationLabal.startAnimation()
        loginAnimation.transform = loginAnimation.transform.scaledBy(x: 0.5, y: 0.5)
        self.signUpAnimation.transform = self.signUpAnimation.transform.scaledBy(x: 0.5, y: 0.5)
        let uiAnimationText = UIViewPropertyAnimator(duration: 2, curve: .easeIn, animations: {
            self.loginAnimation.transform = self.loginAnimation.transform.scaledBy(x: 2, y: 2)
            self.signUpAnimation.transform = self.signUpAnimation.transform.scaledBy(x: 2, y: 2)
            
        })
        uiAnimationText.startAnimation()
    }

    func ImegViewAnimation(){
        
        
        imageViewAnimation.transform = imageViewAnimation.transform.scaledBy(x: 2, y: 2)
        imageViewAnimation.alpha = 0
        
        
        
        UIView.animate(withDuration: 2, delay: 0, options: [.curveEaseOut], animations: {
            
            self.imageViewAnimation.alpha = 1
            self.imageViewAnimation.transform.tx = 0
            self.imageViewAnimation.transform = self.imageViewAnimation.transform.scaledBy(x: 0.5, y: 0.5)
            
            
            
        })
        
    }
}

