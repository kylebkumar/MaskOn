//
//  MaskCheckViewController.swift
//  MaskOn
//
//  Created by Dinesh on 2/9/21.
//

import UIKit

class MaskCheckViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func maskCheckToCameraButtonPressed(_ sender: Any) {
        //performSegue(withIdentifier: "maskCheckToCameraSegue", sender: nil)
        
        self.launchCamera()
    }
    
    func launchCamera()
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }else {
            let alert = UIAlertController (title: "Warning", message: "There's no camera.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true) {
            if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                self.predictImage(image: image)
            }
        }
    }
    
    private lazy var module: TorchModule = {
        if let filePath = Bundle.main.path(forResource: "model", ofType: "pt"),
            let module = TorchModule(fileAtPath: filePath) {
            return module
        } else {
            fatalError("Can't find the model file!")
        }
    }()

    private lazy var labels: [String] = {
        if let filePath = Bundle.main.path(forResource: "words", ofType: "txt"),
            let labels = try? String(contentsOfFile: filePath) {
            return labels.components(separatedBy: .newlines)
        } else {
            fatalError("Can't find the text file!")
        }
    }()

    func predictImage(image: UIImage) {
        let resizedImage = image.resized(to: CGSize(width: 224, height: 224))
        guard var pixelBuffer = resizedImage.normalized() else {
            return
        }
        guard let outputs = module.predict(image: UnsafeMutableRawPointer(&pixelBuffer)) else {
            return
        }
        let zippedResults = zip(labels.indices, outputs)
        let sortedResults = zippedResults.sorted { $0.1.floatValue > $1.1.floatValue }.prefix(1)
        var text = ""
        for result in sortedResults {
            text += "\u{2022} \(labels[result.0]) \n\n"
        }
        print(";" + text + ";")
        
        if(text.contains("with_mask")) {
            self.performSegue(withIdentifier: "maskToSuccessSegue", sender: nil)
        }else {
            self.performSegue(withIdentifier: "maskToFailureSegue", sender: nil)
        }
    }
    
}
