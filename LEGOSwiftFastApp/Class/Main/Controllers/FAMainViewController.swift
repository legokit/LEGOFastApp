//
//  MainViewController.swift
//  LEGOSwiftFastApp
//
//  Created by 马陈爽 on 2020/11/2.
//

import UIKit

class FAMainViewController: BaseViewController {
    
    private var bottomUpController: BaseAnimationController?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .green
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        button.center = self.view.center
        button.backgroundColor = .yellow
        self.view.addSubview(button)
        button.addTarget(self, action: #selector(buttonClick(_:)), for: .touchUpInside)
        self.bottomUpController = BottomUpAnimationController()
        log.debug(#function)
        
        log.debug(appDelegate.getLogFileContent())
    }
    
    // MARK: Event Response
    
    @objc private func buttonClick(_ sender: UIButton) {
        let vc = FATestViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension FAMainViewController: AbstractViewController {
    
    var animationController: BaseAnimationController? {
        return self.bottomUpController
    }
    
    
}


