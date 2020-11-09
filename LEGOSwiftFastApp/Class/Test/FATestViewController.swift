//
//  TestNavigationViewController.swift
//  LEGOSwiftFastApp
//
//  Created by 马陈爽 on 2020/11/5.
//

import Foundation
import UIKit

class FATestViewController: BaseViewController {
    
    private var verticalSwipController: BaseInteractionController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        button.center = self.view.center
        button.backgroundColor = .yellow
        self.view.addSubview(button)
        button.addTarget(self, action: #selector(buttonClick(_:)), for: .touchUpInside)
        self.verticalSwipController = VerticalSwipeInteractionController()
        log.debug(#function)
    }
    
    @objc private func buttonClick(_ sender: UIButton) {
//        let vc = FATestViewController()
//        let transition = CATransition()
//        transition.type = .push
//        transition.subtype = .fromBottom
//        self.navigationController?.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.popViewController(animated: true)
        //self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension FATestViewController: AbstractViewController {
    var interactionController: BaseInteractionController? {
        return self.verticalSwipController
    }
}
