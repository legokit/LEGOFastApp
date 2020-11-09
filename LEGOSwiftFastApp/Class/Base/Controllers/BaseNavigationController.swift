//
//  BaseNavigationController.swift
//  LEGOSwiftFastApp
//
//  Created by 马陈爽 on 2020/11/2.
//

import UIKit
import LEGONavigationController_Swift


class BaseNavigationController: LEGONavigationController {
    private var fromVC: AbstractViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.interactivePopGestureRecognizer?.delegate = self
        self.delegate = self
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        wirePopInteractionController(to: viewController)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    // MARK: - Private Method
    
    private func wirePopInteractionController(to viewController: UIViewController) {
        guard let viewController = viewController as? AbstractViewController else { return }
        guard let interactionController = viewController.interactionController else { return }
        interactionController.wireTo(viewController: viewController as! UIViewController, forOperation: .pop)
    }
}

// MAKR: - UIGestureRecognizerDelegate
extension BaseNavigationController: UIGestureRecognizerDelegate {

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return self.viewControllers.count > 1
    }
}
// MARK: - UINavigationControllerDelegate
extension BaseNavigationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let viewController: AbstractViewController?
        if operation == .pop {
            viewController = toVC as? AbstractViewController
        } else {
            viewController = fromVC as? AbstractViewController
        }
        self.fromVC = fromVC as? AbstractViewController
        guard let animtionController = viewController?.animationController else { return nil }
        animtionController.reverse = operation == .pop
        return animtionController
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let viewController = self.fromVC else { return nil }
        guard let interactionController = viewController.interactionController, interactionController.interactionInProgress else { return nil }
        return interactionController
    }
}
