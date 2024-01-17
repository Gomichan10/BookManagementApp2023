//
//  MenuViewController.swift
//  ISC BOOK
//
//  Created by Gomi Kouki on 2023/12/14.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var menuView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }
    
    override func viewWillAppear(_ animated: Bool) {
        let menuPos = self.menuView.layer.position
        self.menuView.layer.position.x = -self.menuView.frame.width
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       options: .curveEaseOut,
                       animations: {
            self.menuView.layer.position.x = menuPos.x
        },
                       completion: {
            bool in
        })
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        for touch in touches {
            if touch.view?.tag == 1{
                UIView.animate(withDuration: 0.2,
                               delay: 0,
                               options: .curveEaseIn,
                               animations: {
                    self.menuView.layer.position.x = -self.menuView.frame.width
                },
                               completion: {
                    bool in
                    self.dismiss(animated: true)
                })
            }
        }
    }

}
