//
//  ViewController.swift
//  WhatFlower
//
//  Created by PRABALJIT WALIA     on 28/05/20.
//  Copyright © 2020 PRABALJIT WALIA    . All rights reserved.
//

import UIKit
import CoreML
import Vision
import Alamofire
import SwiftyJSON
import SDWebImage

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    let wikipediaURl = "https://en.wikipedia.org/w/api.php"
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        
        // Do any additional setup after loading the view.
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       
        if let userPickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
        
            guard let convertedciImage = CIImage(image: userPickedImage) else{
                fatalError("cannot convert userPickedImage to CIImage")
        }
            detect(image: convertedciImage)
        imageView.image = userPickedImage
        
        
        }
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    func detect(image: CIImage){
        guard let model = try? VNCoreMLModel(for: FlowerClassifier().model) else{
            
            fatalError("cannot import model")
        }
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let classification = request.results?.first as? VNClassificationObservation else{
                fatalError("could not classify image")
            }
            self.navigationItem.title = classification.identifier.capitalized
            self.requestInfo(flowerName: classification.identifier)
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        do{
            try handler.perform([request])
        }
        catch{
            print(error)
        }
        
    }
    
    func requestInfo(flowerName: String){
        
        let parameters : [String:String] = [
        "format" : "json",
        "action" : "query",
        "prop" : "extracts|pageimages",
        "exintro" : "",
        "explaintext" : "",
        "titles" : flowerName,
        "indexpageids" : "",
        "redirects" : "1",
        "pithumbsize":"500"
        ]

        Alamofire.request(wikipediaURl, method: .get, parameters: parameters).responseJSON { (response) in
            if response.result.isSuccess{
                print("got the wikipedia info")
                print(response)
                let flowerJSON: JSON = JSON(response.result.value!)
                
                let pageid = flowerJSON["query"]["pageids"][0].stringValue
                let flowerDescription = flowerJSON["query"]["pages"][pageid]["extract"]
            }
        }
    }
        
    
    
    
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        present(imagePicker,animated: true,completion: nil)
    }
    

}


