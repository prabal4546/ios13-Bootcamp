//
//  ViewController.swift
//  MagicPaper
//
//  Created by PRABALJIT WALIA     on 08/06/20.
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
        
        // Create a new scene
        
        // Set the scene to the view
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        if let trackedImages = ARReferenceImage.referenceImages(inGroupNamed: "NewsPaperImages", bundle: Bundle.main){
        
            configuration.trackingImages = trackedImages
            
            configuration.maximumNumberOfTrackedImages = 1
            
        }

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
    //Anchor is the image it found or recognised
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        let videoNode = SKVideoNode(fileNamed: "harrypotter.mp4")
        
        videoNode.play()
        
        let videoScene = SKScene(size: CGSize(width: 480, height: 360))
        
        videoNode.position = CGPoint(x: videoScene.size.width/2, y: videoScene.size.height/2)
        
        videoNode.yScale = -1.0
        
        videoScene.addChild(videoNode)
        
        let node = SCNNode()
        
        if let imageAnchor = anchor as? ARImageAnchor{
            
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            
            plane.firstMaterial?.diffuse.contents = videoScene
            
            let planeNode = SCNNode(geometry: plane)
            
            node.addChildNode(planeNode)
        }
        return node
    }
}
