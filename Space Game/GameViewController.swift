//
//  GameViewController.swift
//  Space Game
//
//  Created by Don Espe on 4/2/20.
//  Copyright © 2020 Ducky Planet LLC. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView?
        {
            // Load the SKScene from 'GameScene.sks'
            if let scene =    SKScene(fileNamed: "GameScene") //GameScene(size: view.bounds.size) //(this commented part doesn't work quite right with the mac view...
            {
                scene.size = CGSize(width: 1334, height: 750)
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFit  //.resizeFill
                // Present the scene
                //scene.size = view.bounds.size
                print("anchor point: ", scene.anchorPoint)
                scene.anchorPoint = CGPoint(x: 0.5, y: 0.7)
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {

        return UIInterfaceOrientationMask(rawValue: UIInterfaceOrientationMask.RawValue(Int(UIInterfaceOrientationMask.landscapeRight.rawValue)))

    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
