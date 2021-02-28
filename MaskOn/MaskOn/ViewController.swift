//
//  ViewController.swift
//  MaskOn
//
//  Created by Dinesh on 2/9/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func maskButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "startToSanitize", sender: nil)
    }
    
}

