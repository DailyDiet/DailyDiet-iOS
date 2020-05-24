//
//  InteractionPanToClose.swift
//  KeyboardHandle
//
//  Created by ali on 4/15/20.
//  Copyright © 2020 ali. All rights reserved.
//


import UIKit

class InteractionPanToClose: UIPercentDrivenInteractiveTransition {
    
    @IBOutlet var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var viewController: UIViewController!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var dialogView: UIView!
    
    var panGestureRecognizer: UIPanGestureRecognizer!
    var tapGestureRecognizer: UITapGestureRecognizer!

    func rotateDialogOut() {
        let rotationAngle = CGFloat(Int(arc4random_uniform(60)) - 30) * CGFloat.pi / 180.0
        
        let rotationTransform = CGAffineTransform(rotationAngle: rotationAngle)
        let translationTransform = CGAffineTransform(translationX: 0, y: 300)
        
        dialogView.alpha = 0
        dialogView.transform = rotationTransform.concatenating(translationTransform)
    }
    
    func animateDialogeAppear() {
        rotateDialogOut()
        
        let animator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 0.9) {
            self.dialogView.alpha = 1
            self.dialogView.transform = .identity
        }
        animator.startAnimation()

    }
    
    func animateDialogeDisappear() {
        
        UIView.animate(withDuration: 0.5, animations: {
              self.rotateDialogOut()
          }) { (finished) in
              self.viewController.dismiss(animated: true, completion: nil)
          }

    }
    
    func setGestureRecognizer() {
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handle))
        panGestureRecognizer.delegate = self
        scrollView.addGestureRecognizer(panGestureRecognizer)
        
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(animateDialogeDisappearAndDismiss))
        scrollView.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer.delegate = self
    }
    
    @objc func animateDialogeDisappearAndDismiss(_ gesture: UITapGestureRecognizer){
        UIView.animate(withDuration: 0.5, animations: {
            self.rotateDialogOut()
        }) { (finished) in
            self.viewController.dismiss(animated: true, completion: nil)
        }
    }
    
    
    @objc func handle(_ gesture: UIPanGestureRecognizer) {
        guard scrollView.contentOffset.y < 1 else { return }
        
        
        let threshold: CGFloat  = 100.0
        let translation = gesture.translation(in: viewController.view)
        switch gesture.state {
        case .changed:
            let percentCompleted = translation.y / 2000
            update(percentCompleted)
        case .ended:
            if translation.y > threshold {
                finish()
            } else {
                cancel()
            }
        default:
            break
        }
    }
    
    override func update(_ percentComplete: CGFloat) {
        visualEffectView.alpha = 1 - percentComplete
        
        let translation = panGestureRecognizer.translation(in: viewController.view)
        
        let translationY = CGAffineTransform(translationX: 0, y: translation.y)
        let scale = CGAffineTransform(scaleX: 1 - percentComplete , y: 1 - percentComplete)
        
        let origin = panGestureRecognizer.location(in: viewController.view)
        let frameWidth = viewController.view.frame.width
        let originX = origin.x / frameWidth
        let degree = 150 - originX * 300
        let rotationAngle = percentComplete * degree * CGFloat.pi / 180.0
        let rotation = CGAffineTransform(rotationAngle: rotationAngle)
        
        let transform  = translationY.concatenating(scale).concatenating(rotation)
        
        dialogView.transform = transform
    }
    
    override func cancel() {
        let animator = UIViewPropertyAnimator(duration: 0.6, dampingRatio: 0.6) {
            self.visualEffectView.alpha = 1
            self.dialogView.transform = .identity
        }
        
        animator.startAnimation()
    }
    
    override func finish() {
        
        let animator = UIViewPropertyAnimator(duration: 0.9, dampingRatio: 0.9) {
            self.visualEffectView.effect = nil
            self.dialogView.frame.origin.y += 200
            self.viewController.dismiss(animated: true, completion: nil)
            
        }
        
        animator.startAnimation()
    }
    
}


extension InteractionPanToClose: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if gestureRecognizer == tapGestureRecognizer && touch.view!.isDescendant(of: dialogView){
            return false
        }
        
        return true
    }
}


