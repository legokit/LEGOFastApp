//
//  VerticalSwipeInteractionController.swift
//  LEGOSwiftFastApp
//
//  Created by 马陈爽 on 2020/11/7.
//

import UIKit

var VerticalSwipeGestureKey = "FAVerticalSwipeGestureKey"

class VerticalSwipeInteractionController: BaseInteractionController {
    
    private var operation: InteractionOperation = .pop
    private var viewController: UIViewController?
    private var shouldCompleteTransition: Bool = false
    
    private func prepareGestureRecognizer(in view: UIView) {
        if let recognizer = objc_getAssociatedObject(view, &VerticalSwipeGestureKey) as? UIPanGestureRecognizer {
            view.removeGestureRecognizer(recognizer)
        }
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(handlerGesture(_:)))
        view.addGestureRecognizer(recognizer)
        objc_setAssociatedObject(view, &VerticalSwipeGestureKey, recognizer, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    @objc private func handlerGesture(_ recongizer: UIPanGestureRecognizer) {
        let translation = recongizer.translation(in: recongizer.view?.superview)
        switch recongizer.state {
        case .began:
            let topToBottomSwipe: Bool = translation.y > 0;
            if self.operation == .pop {
                if topToBottomSwipe {
                    self.interactionInProgress = true
                    self.viewController?.navigationController?.popViewController(animated: true);
                }
            }
            else {
                self.interactionInProgress = true
                viewController?.dismiss(animated: true, completion: nil)
            }
        case .changed:
            if self.interactionInProgress {
                var fraction = abs(Float(translation.y) / 200)
                fraction = fminf(fmaxf(fraction, 0.0), 1.0)
                self.shouldCompleteTransition = (fraction > 0.5)
                if fraction >= 1.0 { fraction = 0.99 }
                self.update(CGFloat(fraction))
            }
        case .ended, .cancelled:
            if self.interactionInProgress {
                self.interactionInProgress = false
                if !self.shouldCompleteTransition || recongizer.state == .cancelled {
                    self.cancel()
                } else {
                    self.finish()
                }
            }
        default:
            break
        }
    }

}
    
extension VerticalSwipeInteractionController: AbstractInteraction {
    func wireToViewController(_ vc: UIViewController, forOperation: InteractionOperation) {
        guard !(forOperation == .tab) else {
            assert(false, "unsupport")
            return
        }
        self.operation = forOperation
        self.viewController = vc
        self.prepareGestureRecognizer(in: vc.view)
    }
    
    
}
