//
//  FailureViewController.swift
//  MaskOn
//
//  Created by Dinesh on 2/9/21.
//

import UIKit

class FailureViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "failureToHome", sender: nil)
    }
    
    
}
