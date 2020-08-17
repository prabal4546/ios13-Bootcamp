//
//  ViewController.swift
//  SeaFood
//
//  Created by PRABALJIT WALIA     on 27/05/20.
//  Copyright © 2020 PRABALJIT WALIA    . All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            imageView.image = userPickedImage
            guard let ciimage = CIImage(image: userPickedImage) else{
                fatalError("could not convert to ciimage")
            }
            detectImage(image: ciimage)
            
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    func detectImage(image: CIImage){
        
        guard let model = try? VNCoreMLModel(for:Inceptionv3().model) else{
            fatalError("loading coreML model failed")
        }
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else{
                fatalError("model failed to process image")
            }
            print(results)
        }
        let handler = VNImageRequestHandler(ciImage: image)
        do{
            try handler.perform([request])
        }catch{
            print(error)
            
        }
    }
    
    

    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
    
}

