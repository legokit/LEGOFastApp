//
//  FABottomUpAnimationController.swift
//  LEGOSwiftFastApp
//
//  Created by 马陈爽 on 2020/11/7.
//

import UIKit

class BottomUpAnimationController: BaseAnimationController {

}

extension BottomUpAnimationController: AbstractAnimation {
    func animateTransition(transitionContext: UIViewControllerContextTransitioning, fromVC: UIViewController, toVC: UIViewController, fromView: UIView, toView: UIView) {
        self.duration = 0.3
        let containerView = transitionContext.containerView
        let maxY = containerView.frame.height
        let middleMaxY = maxY / 2.0
        containerView.addSubview(toView)
        toView.frame = CGRect(x: 0, y: self.reverse ? -middleMaxY : maxY, width: fromView.frame.width, height: fromView.frame.height)
        self.reverse ? containerView.sendSubviewToBack(toView) : containerView.bringSubviewToFront(toView);
        
        let duration = self.transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration) {
            fromView.frame = CGRect(x: 0, y: !self.reverse ? -middleMaxY : maxY, width: fromView.frame.width, height: fromView.frame.height)
            toView.frame = CGRect(x: toView.frame.origin.x, y: 0, width: toView.frame.width, height: toView.frame.height)
        } completion: { (finished) in
            guard !transitionContext.transitionWasCancelled else {
                toView.frame = CGRect(x: 0, y: toView.frame.origin.y, width: toView.frame.width, height: toView.frame.height)
                fromView.frame = CGRect(x: 0, y: fromView.frame.origin.y, width: fromView.frame.width, height: fromView.frame.height)
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                return
            }
            //fromView.removeFromSuperview()
            fromView.frame = CGRect(x: 0, y: !self.reverse ? -middleMaxY : maxY, width: fromView.frame.width, height: fromView.frame.height)
            toView.frame = CGRect(x: toView.frame.origin.x, y: 0, width: toView.frame.width, height: toView.frame.height)
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }

    }
}
