//
//  MenuTransitionAnimator.swift
//  SlideDownMenu
//
//  Created by Makan fofana on 5/11/19.
//  Copyright © 2019 MakanFofana. All rights reserved.
//

import Foundation
import UIKit

@objc protocol MenuTransitionManagerDelegate{
    func dismiss()
}


class MenuTranasitionAnimator: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    
    //Delegate for protocol
    var delegate: MenuTransitionManagerDelegate?
    
    let duration = 0.5
    var isPresenting = false
    
    var snapShot: UIView? {
        didSet {
            if let delegate = delegate {
                let tapGestureRecognzer = UITapGestureRecognizer(target: delegate, action: #selector(delegate.dismiss))
                snapShot?.addGestureRecognizer(tapGestureRecognzer)
            }
        }
    }
    
    
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from) else {
            return
        }
        
        guard let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) else {
            return
        }
        
        
        let container = transitionContext.containerView
        let moveDown = CGAffineTransform(translationX: 0, y: container.frame.height - 150)
        let moveUp = CGAffineTransform(translationX: 0, y: -50)
        
        //Adding both views to the container view
        if isPresenting {
            toView.transform = moveUp
            snapShot = fromView.snapshotView(afterScreenUpdates: true)
            container.addSubview(toView)
            container.addSubview(snapShot!)
        }
        
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: [], animations: {
            
            if self.isPresenting {
                self.snapShot?.transform = moveDown
                toView.transform = CGAffineTransform.identity
            } else {
                self.snapShot?.transform = CGAffineTransform.identity
                fromView.transform = moveUp
            }
            
            
        }, completion: { finished  in
            
            transitionContext.completeTransition(true)
            
            if !self.isPresenting {
                self.snapShot?.removeFromSuperview()
            }
        })
        
    }
    
    
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresenting = true
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresenting = true
        return self
    }
    
    
}
