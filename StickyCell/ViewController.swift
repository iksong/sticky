//
//  ViewController.swift
//  StickyCell
//
//  Created by IK on 10/11/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func start(_ sender: Any) {
        let vc = StickyViewController()
        present(vc, animated: true, completion: nil)
    }
}

