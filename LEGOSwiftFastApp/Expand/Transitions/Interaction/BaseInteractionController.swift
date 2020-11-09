//
//  BaseInteractionController.swift
//  LEGOSwiftFastApp
//
//  Created by 马陈爽 on 2020/11/6.
//

import Foundation
import UIKit

enum InteractionOperation {
    case pop
    case dismiss
    case tab
}

protocol AbstractInteraction: NSObjectProtocol {
    func wireToViewController(_ vc: UIViewController, forOperation: InteractionOperation)
}

class BaseInteractionController: UIPercentDrivenInteractiveTransition {
    
    private weak var controller: AbstractInteraction?
    
    var interactionInProgress: Bool
    
    override init() {
        self.interactionInProgress = false
        super.init()
        if let controller = self as? AbstractInteraction {
            self.controller = controller
        } else {
            assert(false, "Must implement AbstractInteraction Protocol")
        }
    }
    
    func wireTo(viewController vc: UIViewController, forOperation option: InteractionOperation) {
        guard let controller = self.controller else { return }
        controller.wireToViewController(vc, forOperation: option)
    }
}
