//
//  HouseScene.swift
//  Space Game
//
//  Created by Don Espe on 4/17/20.
//  Copyright © 2020 Ducky Planet LLC. All rights reserved.
//


import Foundation
import SpriteKit
import GameplayKit

class HouseScene: SKScene
{
    var button: SKNode! = nil
    
    override func didMove(to view: SKView)
    {
    
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first as UITouch?
        let touchLocation = touch?.location(in: self)
        let targetNode = atPoint(touchLocation!)
        
        if targetNode.name == "exitButton" {
            print("exit tapped")
            let gameScene = SpaceScene(fileNamed: "GameScene")!
            gameScene.size = CGSize(width: 1334, height: 750)
            gameScene.scaleMode = .aspectFit
            // spaceScene.planetLeft = planetName
            // spaceScene.planetLeftSize = planetCircumferance
            // spaceScene.planetLeftPosition = playerPosition.x
            //  spaceScene.anchorPoint = scene?.anchorPoint as! CGPoint //CGPoint(x: 0.5, y: 0.7)
            scene?.view?.presentScene(gameScene)
            
            // TODO: Need to add player location when returning and also map? That way it won't 
        }
        
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?)
    {
    }
    override func update(_ currentTime: TimeInterval)
    {
    }
}
