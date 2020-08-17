//
//  ViewController.swift
//  Poke3D
//
//  Created by PRABALJIT WALIA     on 02/06/20.
//  Copyright © 2020 PRABALJIT WALIA    . All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        sceneView.autoenablesDefaultLighting = true
        
       
        
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        
        //finding the pokemon cards in our working directory
        if let imageToTrack = ARReferenceImage.referenceImages(inGroupNamed: "Pokemon Cards", bundle: Bundle.main){
            
            configuration.trackingImages = imageToTrack
            
            configuration.maximumNumberOfTrackedImages = 2
        }

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    //trying to use the pokemon cards which we have found now to render them in 3D

    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        if let imageAnchor = anchor as? ARImageAnchor{
            
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.width)
            
            plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0.5)
            
            let planeNode = SCNNode(geometry: plane)
            
            planeNode.eulerAngles.x = -Float.pi/2
            
            node.addChildNode(planeNode)
            
            if imageAnchor.referenceImage.name == "eevee-card"{
                
                
                
                if let pokeScene = SCNScene(named: "art.scnassets/eevee.scn"){
                    
                    if let pokeNode = pokeScene.rootNode.childNodes.first{
                        
                        pokeNode.eulerAngles.x = .pi/2
                        
                        planeNode.addChildNode(pokeNode)
                        
                        
                    }
                    
                }
            }
            if imageAnchor.referenceImage.name == "oddish-card"{
                         
                         
                         
                         if let pokeScene = SCNScene(named: "art.scnassets/oddish.scn"){
                             
                             if let pokeNode = pokeScene.rootNode.childNodes.first{
                                 
                                 pokeNode.eulerAngles.x = .pi/2
                                 
                                 planeNode.addChildNode(pokeNode)
                                 
                                 
                             }
                             
                         }
                     }
            
        }
        return node
    }
}
