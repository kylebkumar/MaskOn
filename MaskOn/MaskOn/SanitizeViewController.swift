//
//  SanitizeViewController.swift
//  MaskOn
//
//  Created by Dinesh on 2/9/21.
//

import UIKit

class SanitizeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func sanitizeToScanButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "sanitizeToScan", sender: nil)
    }
    
    
}
