//
//  SpaceScene.swift
//  Space Game
//
//  Created by Don Espe on 4/8/20.
//  Copyright © 2020 Ducky Planet LLC. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class SpaceScene: SKScene
{
    var button: SKNode! = nil
    var player: SKNode! = nil
    
    let degreesToRadians = CGFloat.pi / 180
    let radiansToDegrees = 180 / CGFloat.pi
    
    var pushingUp = false
    var pushingDown = false
    var pushingLeft = false
    var pushingRight = false
    
    var counter = 0
    
    var playerVelocity = CGFloat(0.0) // (dx: CGFloat(0.0), dy: CGFloat(0.0))
    var playerAngle = CGFloat(0.0)
    var playerAngleVelocity = CGFloat(0.0)
    
    var playerPosition = (x: 20, y: 2)
    
    var planetLeft = "planet 0"
    var planetLeftSize = 50
    var planetLeftPosition = 25
    
    var planetCounter = 0
    
    var asteroid = SKSpriteNode(imageNamed: "meteorBrown_big4")
    
    let background = SKSpriteNode(imageNamed: "darkPurple")
    //let cameraNode = SKCameraNode()
    
    
    override func didMove(to view: SKView)
    {
        print("entered space scene")
        
        if scene != nil
        {
            background.size = CGSize(width: scene!.frame.width , height: scene!.frame.height * 2.0)
            print("background size: ", background.size)
            // cameraNode.position = background.position // CGPoint(x: scene!.size.width / 2, y: scene!.size.height / 2)
            // scene!.addChild(cameraNode)
            //scene!.camera = cameraNode
            
        }
        
        background.zPosition = 0
        background.name = "background"
        addChild(background)
        
        asteroid.zPosition = 9
        asteroid.position = CGPoint(x: 100, y: -175)
        asteroid.name = "asteroid"
        addChild(asteroid)
        
        makePlanet(at: CGPoint(x: -200.0,y: -175.0), ofRadius: 60, color: .brown)
        makePlanet(at: CGPoint(x: -300.0,y: 120), ofRadius: 35, color: .blue)
        
        player = SKSpriteNode(imageNamed: "playerShip1_blue")
        player.setScale(0.4)
        player.zPosition = 10
        print("planet Left: ", planetLeft)
        
        var angle = player.zRotation
        
        if let planet = childNode(withName: "*" + planetLeft + "*")
        {
            print("using planet: ", planet.name!)
            let planetRadius = planet.frame.width / 2
            
            let planetSize = planetRadius + (self.player.frame.height / 2.0 + 5) // 25.0 // 15 is just an added buffer
            
            let relativeLocation = CGFloat(planetLeftPosition) / (CGFloat(planetLeftSize) + 1)
            
            let angleOnPlanet = relativeLocation * 360.0
            
            print("planetSize: ", planetSize,", relative Location: ", relativeLocation,", angle on planet: ", angleOnPlanet)
            
            
            
//            self.player.position = planet.position
//            self.player.position.y += planetSize
            
            self.player.position.x = planetSize * sin(angleOnPlanet * degreesToRadians) + planet.position.x
            self.player.position.y = planetSize * cos(angleOnPlanet * degreesToRadians) + planet.position.y
            
            
            print("setting angle to planet")
            angle = atan2(self.player.position.x - planet.position.x, planet.position.y - self.player.position.y)
            print("angle in let: ", angle)
            
            
            
        }
        print("angle out of let: ", -angle * radiansToDegrees)
        playerAngle = angle * radiansToDegrees + 180
        
        player.zRotation = -angle
        
        //        let rotateAction = SKAction.rotate(toAngle: angle - (.pi / 4.0), duration: 0.0)
        //        player.run(rotateAction)
        
        //player.position = CGPoint(x: 0, y: 0)
        player.name = "player"
        print("player position: ", player.position)
        
        addChild(player)
        
        buildUI()
    }
    
    func buildUI()
    {
        button = SKSpriteNode(color: .blue, size: CGSize(width: 50, height: 50))
        button.position = CGPoint(x:0, y: -170);
        button.zPosition = 35
        button.name = "up"
        self.addChild(button)
        
        button = SKSpriteNode(color: .blue, size: CGSize(width: 50, height: 50))
        button.position = CGPoint(x:0, y: -230);
        button.zPosition = 35
        button.name = "down"
        self.addChild(button)
        
        
        button = SKSpriteNode(color: .red, size: CGSize(width: 100, height: 100))
        button.position = CGPoint(x:100, y: -200);
        button.zPosition = 35
        button.name = "right"
        self.addChild(button)
        
        button = SKSpriteNode(color: .green, size: CGSize(width: 100, height: 100))
        button.position = CGPoint(x:-100, y: -200);
        button.zPosition = 35
        button.name = "left"
        
        self.addChild(button)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let touch = touches.first as UITouch?
        let touchLocation = touch?.location(in: self)
        let targetNode = atPoint(touchLocation!)
        for press in touches
        {
            print("press: ", press)
        }
        
        switch targetNode.name
        {
            case "up":
                
                
                
                print("pushing up")
                // playerVelocity += 1//  .dy += 1
                pushingUp = true
                pushingDown = false
                pushingRight = false
                pushingLeft = false
            
            case "down":
                
                print("pushing down")
                // playerVelocity -= 1 //.dy -= 1
                pushingDown = true
                pushingUp = false
                pushingRight = false
                pushingLeft = false
            
            case "left":
                
                print("pushing left")
                //playerVelocity.dx -= 1
                // playerAngle += 10
                pushingLeft = true
                pushingUp = false
                pushingDown = false
                pushingRight = false
            
            case "right":
                
                
                print("pushing right")
                // playerVelocity.dx += 1
                // playerAngle -= 10
                pushingRight = true
                pushingLeft = false
                pushingUp = false
                pushingDown = false
            
            case "background":
                
                pushingRight = false
                pushingLeft = false
                pushingUp = false
                pushingDown = false
            
            default:
                print("touches began - undefined")
                break
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        
        print("touches count: ", touches.count)
        
        let touch = touches.first as UITouch?
        let touchLocation = touch?.location(in: self)
        let targetNode = atPoint(touchLocation!)// as! SKSpriteNode
        
        switch targetNode.name
            
        {
            case "up":
                print("let off up")
                pushingUp = false
            
            case "down":
                print("let off down")
                pushingDown = false
            
            case "left":
                print("let off left")
                pushingLeft = false
            
            case "right":
                print("let off right")
                pushingRight = false
            
            default:
                print("let off undefined node")
        }
    }
    
    func showActiveTouches()
    {
        if pushingRight
        {
            //print("still pushing right")
        }
        if pushingLeft
        {
           // print("still pushing left")
        }
        if pushingUp
        {
           // print("still pushing up")
        }
        if pushingDown
        {
           // print("still pushing down")
        }
        
    }
    
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        
        let touch = touches.first as UITouch?
        let touchLocation = touch?.location(in: self)
        let targetNode = atPoint(touchLocation!) as! SKSpriteNode
        
        switch targetNode.name
            
        {
            case "up":
                print("cancel up")
                pushingUp = false
            
            case "down":
                print("cancel down")
                pushingDown = false
            
            case "left":
                print("cancel left")
                pushingLeft = false
            
            case "right":
                print("cancel right")
                pushingRight = false
            
            default:
                print("cancel undefined node")
        }
    }
    
    func isLocationOnScreen(position: CGPoint) -> Bool
    {
        
        if position.x < -self.size.width / 2 + player.frame.width / 2
        {
            //  print("out on the left of the screen")
            return false
            
        }
        if position.x > self.size.width / 2 - player.frame.width / 2
        {
            // print("out on the right of the screen")
            return false
            
        }
        if position.y > self.frame.height / 2 - player.frame.height / 2
        {
            // print("out on the top of the screen")
            return false
        }
        if position.y <  -self.frame.height / 2 + player.frame.height / 2
        {
            // print("out on the bottom of the screen")
            return false
        }
        return true
    }
    
    func makePlanet(at: CGPoint, ofRadius: CGFloat, color: SKColor)
    {
        let circle = SKShapeNode(circleOfRadius: ofRadius ) // Size of Circle = Radius setting.
        circle.position = at  //touch location passed from touchesBegan.
        
        circle.name = "planet " + String(planetCounter)
        planetCounter += 1
        // circle.strokeColor = SKColor.brown
        // circle.glowWidth = 1.0
        circle.fillColor = color
        circle.zPosition = 14
        self.addChild(circle)
        
    }
    
    //func landOnPlanet(name: String)
    func landOnPlanet(planet: SKNode)
    {
        let gameScene = GameScene(fileNamed: "GameScene")!
        gameScene.size = CGSize(width: 1334, height: 750)
        gameScene.scaleMode = .aspectFit
        gameScene.planetName =  planet.name ?? ""
        
        let angle = atan2(self.player.position.x - planet.position.x, self.player.position.y - planet.position.y)
        
        let decimalLocation = (angle ) / (2 * .pi)
        
        print("character landing location angle: ", angle,", decimalLocation: ", decimalLocation)
        
        gameScene.arrivedAtLocation = decimalLocation
        gameScene.landingAngle = angle


        //  spaceScene.anchorPoint = scene?.anchorPoint as! CGPoint //CGPoint(x: 0.5, y: 0.7)
        scene?.view?.presentScene(gameScene)
    }
    
    
    override func update(_ currentTime: TimeInterval)
    {
        counter += 1
        // Called before each frame is rendered
        
        if counter >= 10
        {
            counter = 0
            if pushingUp
            {
                playerVelocity += 2
            }
            
            if pushingDown
            {
                playerVelocity -= 2
                
            }
            
            let angleMax = CGFloat(5)
            
            if pushingLeft
            {
                playerAngleVelocity += 1
                print("pushing left playerangleVelocity: ", playerAngleVelocity)
                if playerAngleVelocity > angleMax
                {
                    playerAngleVelocity = angleMax
                }
                
            }
            
            if pushingRight
            {
                playerAngleVelocity -= 1
                if playerAngleVelocity < -angleMax
                {
                    playerAngleVelocity = -angleMax
                }
                print("pushing right playerangleVelocity: ", playerAngleVelocity)
            }
            
            if !pushingUp && !pushingDown && playerVelocity != 0
            {
                //  print("sign of player Velocity: ", CGFloat(Int(playerVelocity).signum()))
                
                // playerVelocity -=  CGFloat(Int(playerVelocity).signum())
            }
            
            if !pushingRight && !pushingLeft && playerAngleVelocity != 0
            {
                // print("sign of player angle Velocity: ", CGFloat(Int(playerAngleVelocity).signum()))
                playerAngleVelocity -= CGFloat(Int(playerAngleVelocity).signum())
            }
            
        }
        
        if playerAngle < 0
        {
            playerAngle += 360
        }
        
        if playerAngle > 360
        {
            playerAngle -= 360
        }
        
        playerAngle += playerAngleVelocity
        
        self.enumerateChildNodes(withName: "planet*", using: ({(planet, error) in
            let planetRadius = planet.frame.width / 2
            //print("planet radius: ", planetRadius)
            let planetSize = planetRadius -  1 //(self.player.frame.height / 2.0) // 5 is just an added buffer
            
            if abs(self.player.position.x - planet.position.x) < planetSize && abs(self.player.position.y - planet.position.y) < planetSize
            {
                print("in planet - do stuff")
                print("landing on planet: ", planet.name)
                
               // self.landOnPlanet(name: planet.name ?? "")
                self.landOnPlanet(planet: planet)
            }
            
        }))
        
        
        // print("player x:, ", player.position.x,", y: ", player.position.y)
        
        if !isLocationOnScreen(position: player.position)  && counter > 5
        {
            counter = 0
            print("off screen - need to adjust view")
            //            let zoomOutAction = SKAction.scale(to: 2.0, duration: 1)
            //            cameraNode.run(zoomOutAction)
            
            let changeInX = -player.position.x / 2
            let changeInY = -player.position.y / 2
            
            let movePlanet = SKAction.move(to: CGPoint(x: asteroid.position.x + changeInX, y: asteroid.position.y + changeInY), duration: 0.2)
            counter = -20
            asteroid.run(movePlanet)
            
            
            self.enumerateChildNodes(withName: "planet*", using: ({
                (planet, error) in
                let movePlanet = SKAction.move(to: CGPoint(x: planet.position.x + changeInX, y: planet.position.y + changeInY), duration: 0.2)
                planet.run(movePlanet)
            }))
            
            //planet.position.x += changeInX
            // planet.position.y += changeInY
            
            let movePlayer = SKAction.move(to: CGPoint(x: player.position.x + changeInX, y: player.position.y + changeInY), duration: 0.2)
            player.run(movePlayer)
            
            //player.position = CGPoint(x: player.position.x + changeInX, y: player.position.y + changeInY)
            
            
        }
        
        
        player.zRotation = playerAngle * degreesToRadians
        
        player.position = CGPoint(x:player.position.x - sin(player.zRotation) * playerVelocity / 2.0,y:player.position.y + cos(player.zRotation) * playerVelocity / 2.0)
        
        showActiveTouches()
        
        // let angle = atan2(playerVelocity.dy, playerVelocity.dx)
        // player.zRotation = angle - .pi / 2.0
        
        
        
        
    }
}
