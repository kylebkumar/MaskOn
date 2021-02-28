//
//  CautionViewController.swift
//  MaskOn
//
//  Created by Dinesh on 2/9/21.
//

import UIKit

class CautionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "cautionToHome", sender: nil)
    }
    
    

}
