//
//  ViewController.swift
//  Lab - Street (Augmented Reality)
//
//  Created by Ayu Filippova on 11/07/2019.
//  Copyright © 2019 Dmitry Filippov. All rights reserved.
//

import ARKit

class ViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let street = loadModel(named: "Street.scnassets/Street.scn")!
        street.position = SCNVector3(-3, 0, -3)
        sceneView.scene.rootNode.addChildNode(street)
        
        let streetByCode = createStreet()
        streetByCode.position = SCNVector3(3, 0.5, -3)
        sceneView.scene.rootNode.addChildNode(streetByCode)
        
        sceneView.autoenablesDefaultLighting = true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    func loadModel(named name: String) -> SCNNode? {
        guard let scene = SCNScene(named: name) else { return nil}
        return scene.rootNode.clone()
    }
    
    
    func createFirTree() -> SCNNode {
        let cylinder = SCNCylinder(radius: 0.06, height: 0.2)
        cylinder.firstMaterial?.diffuse.contents = UIImage(named: "Street.scnassets/woodTexture.jpg")
        let cylinderNode = SCNNode(geometry: cylinder)

        
        let cone = SCNCone(topRadius: 0, bottomRadius: 0.25, height: 0.6)
        cone.firstMaterial?.diffuse.contents = UIImage(named: "Street.scnassets/firTexture.jpg")
        let coneNode = SCNNode(geometry: cone)
        coneNode.position.y = 0.399
        
        cylinderNode.addChildNode(coneNode)
        cylinderNode.eulerAngles.x = .pi / 2

        
        return cylinderNode
    }
    
    
    func createStreet () -> SCNNode {
        let wallTexture = UIImage(named: "Street.scnassets/fahwerkWithWindow.jpg")
        let material = SCNMaterial()
        material.diffuse.contents = wallTexture
        let allMaterials = [material]
        let box = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0)
        box.materials = allMaterials
        
        let house = SCNNode(geometry: box)
        
        let pyramid = SCNPyramid(width: 1.2, height: 0.8, length: 1.2)
        pyramid.firstMaterial?.diffuse.contents = UIImage(named: "Street.scnassets/cerepica.png")
        let pyramidNode = SCNNode(geometry: pyramid)
        pyramidNode.position = SCNVector3(0, 0.5, 0)
        house.addChildNode(pyramidNode)
        
        let grass = SCNPlane(width: 4, height: 3)
        grass.firstMaterial?.diffuse.contents = UIColor.green
        let grassNode = SCNNode(geometry: grass)
        grassNode.eulerAngles.x = .pi * 3/2
        grassNode.position = SCNVector3(0, -0.5, 0.2)
        
        
        house.addChildNode(grassNode)
        
        
        for x in stride(from: -1.5, through: 1.5, by: 1.5) {
            for y in stride(from: -1.0, through: 1.0, by: 1.0) {
                let tree = createFirTree()
                tree.position = SCNVector3(x, y, 0.1)
                grassNode.addChildNode(tree)
            }
        }
        
        
        return house
    }
    

}

