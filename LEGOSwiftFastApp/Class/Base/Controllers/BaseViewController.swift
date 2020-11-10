//
//  BaseViewController.swift
//  LEGOSwiftFastApp
//
//  Created by 马陈爽 on 2020/10/28.
//

import UIKit

protocol AbstractViewController: NSObjectProtocol {
    
    var animationController: BaseAnimationController? { get }
    var interactionController: BaseInteractionController? { get }
}

class BaseViewController: UIViewController {
    
    private weak var abstractVC: AbstractViewController?
    
    private var hiddenNavigationBar: Bool = false
    
    // MARK: - Life Cycle
    
    init() {
        super.init(nibName: nil, bundle: nil)
        if let controller = self as? AbstractViewController {
            self.abstractVC = controller
        } else {
            assert(false, "Must implement FAAbstractViewController Protocol")
        }
        
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        if let controller = self as? AbstractViewController {
            self.abstractVC = controller
        } else {
            assert(false, "Must implement FAAbstractViewController Protocol")
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        if let controller = self as? AbstractViewController {
            self.abstractVC = controller
        } else {
            assert(false, "Must implement FAAbstractViewController Protocol")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.transitioningDelegate = self
        // Do any additional setup after loading the view.
    }
    
    deinit {
        
    }
}

extension BaseViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let animationController = self.abstractVC?.animationController else { return nil }
        animationController.reverse = false
        return animationController
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let animationController = self.abstractVC?.animationController else { return nil }
        animationController.reverse = true
        return animationController
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let interactionController = self.abstractVC?.interactionController, interactionController.interactionInProgress else { return nil }
        return interactionController
    }
}

extension AbstractViewController {
    
    var animationController: BaseAnimationController? { nil }
    var interactionController: BaseInteractionController? { nil }
}

