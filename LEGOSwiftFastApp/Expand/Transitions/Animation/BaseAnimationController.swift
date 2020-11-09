//
//  BaseAnimationController.swift
//  LEGOSwiftFastApp
//
//  Created by 马陈爽 on 2020/11/6.
//

import Foundation
import UIKit

protocol AbstractAnimation: NSObjectProtocol {
    func animateTransition(transitionContext: UIViewControllerContextTransitioning, fromVC: UIViewController, toVC: UIViewController, fromView: UIView, toView: UIView)
}

class BaseAnimationController: NSObject {
    
    private weak var controller: AbstractAnimation?
    
    var reverse: Bool
    var duration: TimeInterval
    
    override init() {
        self.reverse = false
        self.duration = 0.3
        super.init()
        if let controller = self as? AbstractAnimation {
            self.controller = controller
        } else {
            assert(false, "Must implement FAAbstractAnimation Protocol")
        }
    }
}

extension BaseAnimationController: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from) else { return }
        guard let toVC = transitionContext.viewController(forKey: .to) else { return }
        guard let fromView = fromVC.view else { return }
        guard let toView = toVC.view else { return }
        guard let controller = self.controller else { return }
        controller.animateTransition(transitionContext: transitionContext, fromVC: fromVC, toVC: toVC, fromView: fromView, toView: toView)
    }
}
