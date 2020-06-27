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
    var throttleTouched = false
    
    var counter = 0
    
    var playerVelocity = CGFloat(0.0) // (dx: CGFloat(0.0), dy: CGFloat(0.0))
    var playerAngle = CGFloat(0.0)
    var playerAngleVelocity = CGFloat(0.0)
    
    var playerPosition = (x: 20, y: 2)
    
    var planetLeft = "planet 0"
    var planetLeftSize = 50
    var planetLeftPosition = 25
    
    var planetCounter = 0
    
    let radarRadius = CGFloat(100)
    
    var asteroid = SKSpriteNode(imageNamed: "meteorBrown_big4")
    
    var nebula = SKSpriteNode(imageNamed: "nebula")
    
    var throttle = SKNode()
    
    var radarNode = SKShapeNode()
    
    let background = SKSpriteNode(imageNamed: "darkPurple")
    //let cameraNode = SKCameraNode()
    
    let fireNode = SKSpriteNode(imageNamed: "fire03")
    
    
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
            view.isMultipleTouchEnabled = true
            
        }
        
        background.zPosition = 0
        background.name = "background"
        addChild(background)
        
        asteroid.zPosition = 9
        asteroid.position = CGPoint(x: 100, y: -175)
        asteroid.name = "radar: asteroid"
        addChild(asteroid)
        
        nebula.zPosition = 11
        nebula.position = CGPoint(x: -150, y: 600)
        nebula.name = "radar: nebula"
        nebula.alpha = 0.2
        nebula.color = .blue
        nebula.colorBlendFactor = 0.7
        addChild(nebula)
        
        
        makePlanet(at: CGPoint(x: -200.0,y: -175.0), ofRadius: 60, color: .brown)
        makePlanet(at: CGPoint(x: -300.0,y: 120), ofRadius: 35, color: .blue)
        makePlanet(at: CGPoint(x:100, y: 200), ofRadius: 75, color: .green)
        makePlanet(at: CGPoint(x:1000, y:1000), ofRadius: 80, color: .purple)
        
        player = SKSpriteNode(imageNamed: "playerShip1_blue")
        player.setScale(0.4)
        player.zPosition = 10
        print("planet Left: ", planetLeft)
        
        var angle = player.zRotation
        
        if let planet = childNode(withName: "*" + planetLeft + "*")
        {
            print("using planet: ", planet.name!)
            let planetRadius = planet.frame.width / 2 + 2.0
            
            let usePlayerSize = max(self.player.frame.height, self.player.frame.width)
            
            let planetSize = planetRadius + (usePlayerSize / 2.0) + 3.0 // 25.0 // 15 is just an added buffer
            
            let relativeLocation = CGFloat(planetLeftPosition) / (CGFloat(planetLeftSize) + 1)
            
            let angleOnPlanet = relativeLocation * 360.0
            
            print("planetSize: ", planetSize,", relative Location: ", relativeLocation,", angle on planet: ", angleOnPlanet)
            print("change in position from planet x: ",planetSize * sin(angleOnPlanet * degreesToRadians), ", y:", planetSize * cos(angleOnPlanet * degreesToRadians))
            print("planet location: ", planet.position)
            
            self.player.position.x = planetSize * sin(angleOnPlanet * degreesToRadians) + planet.position.x
            self.player.position.y = planetSize * cos(angleOnPlanet * degreesToRadians) + planet.position.y
            
            print("setting angle to planet")
            angle = atan2(self.player.position.x - planet.position.x, planet.position.y - self.player.position.y)
            print("angle in let: ", angle)
            
            
            
        }
        print("angle out of let: ", -angle * radiansToDegrees)
        playerAngle = angle * radiansToDegrees + 180
        
        player.zRotation = -angle
        
        player.name = "player"
        print("player position: ", player.position)
        
        addChild(player)
        
        fireNode.zPosition = 10
        fireNode.zRotation = player.zRotation
        fireNode.position = player.position
        let pulsedRed = SKAction.sequence([
            SKAction.colorize(with: .red, colorBlendFactor: 0.3, duration: 0.1),
            SKAction.colorize(withColorBlendFactor: 0, duration: 0.1)])
        fireNode.run(SKAction.repeatForever( pulsedRed))
        addChild(fireNode)
        
        buildUI()
    }
    
    func buildUI()
    {
        button = SKSpriteNode(color: .purple, size: CGSize(width: 50, height: 500))
        button.position = CGPoint(x:-600, y: -75);
        button.zPosition = 35
        button.name = "throttleBar"
        self.addChild(button)
        
        button = SKSpriteNode(color: .clear, size: CGSize(width: 100, height: 500))
        button.position = CGPoint(x:-600, y: -75);
        button.zPosition = 35
        button.name = "throttleBar"
        self.addChild(button)
        
        throttle = SKSpriteNode(color: .blue, size: CGSize(width: 50, height: 50))
        throttle.position = CGPoint(x:-600, y: -300);
        throttle.zPosition = 35
        throttle.name = "throttle"
        self.addChild(throttle)
        
//        button = SKSpriteNode(color: .blue, size: CGSize(width: 50, height: 50))
//        button.position = CGPoint(x:0, y: -170);
//        button.zPosition = 35
//        button.name = "up"
//        self.addChild(button)
//
//        button = SKSpriteNode(color: .blue, size: CGSize(width: 50, height: 50))
//        button.position = CGPoint(x:0, y: -230);
//        button.zPosition = 35
//        button.name = "down"
//        self.addChild(button)
        
        radarNode = SKShapeNode(circleOfRadius: radarRadius )
        
        
        //radarNode = SKSpriteNode(color: .black, size: CGSize(width: 200, height: 200))
        radarNode.fillColor = .black
        radarNode.position = CGPoint(x: 550, y: 250);
        radarNode.zPosition = 35
        radarNode.alpha = 0.7
        radarNode.name = "radar"
        self.addChild(radarNode)
        
        button = SKSpriteNode(color: .red, size: CGSize(width: 100, height: 100))
        button.position = CGPoint(x: 600, y: -300);
        button.zPosition = 35
        button.name = "right"
        self.addChild(button)
        
        button = SKSpriteNode(color: .green, size: CGSize(width: 100, height: 100))
        button.position = CGPoint(x: 450, y: -300);
        button.zPosition = 35
        button.name = "left"
        
        self.addChild(button)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let touch = touches.first as UITouch?
        let touchLocation = touch?.location(in: self)
        let targetNode = atPoint(touchLocation!)
//        for press in touches
//        {
//            //print("press: ", press)
//        }
        
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
            
            case "throttle":
                throttleTouched = true
                print("touched trottle")
    
            
            default:
                print("touches began - undefined")
                break
        }
        
    }
    

    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        
        for touch in touches
        {
            //let touch = touches.first as UITouch?
            let touchLocation = touch.location(in: self)
            let targetNode = atPoint(touchLocation) as! SKNode
            print("touch moved: ", targetNode.name)
        
            if throttleTouched && targetNode.name == "throttle" || targetNode.name == "throttleBar"
        {
            let touch = touches.first
            let touchLocation = touch!.location(in: self)
            let previousLocation = touch!.previousLocation(in: self)
            var throttlePosition = touch!.location(in: self).y
            
            if throttlePosition < -300
            {
                throttlePosition = -300
            }
            
            if throttlePosition > 150
            {
                throttlePosition = 150
            }
            
            print("throttle position: ", throttlePosition)
            throttle.position.y = throttlePosition  // touch?.location(in: self).y as! CGFloat
            
        }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        
        print("touches count: ", touches.count)
        
        
        for touch in touches
        {
            //let touch = touches.first as UITouch?
            let touchLocation = touch.location(in: self)
            let targetNode = atPoint(touchLocation) as! SKNode
            
//            for press in touches
//            {
//                //print("press: ", press)
//
//                let touchEnded = atPoint(press.location(in: self))
//                if touchEnded.name == "throttle"
//                {
//                    throttleTouched = false
//                }
//            }
            // throttleTouched = false
            
            print("touch ended for:", targetNode.name)
            
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
                
                case "throttle":
                    print("let off throttle")
                    
                    throttleTouched = false
                
                case "throttleBar":
                    print("let off throttle")
                    
                    throttleTouched = false
                
                default:
                    print("let off undefined node")
            }
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
        
        
        for touch in touches
        {
            //let touch = touches.first as UITouch?
            let touchLocation = touch.location(in: self)
            let targetNode = atPoint(touchLocation) as! SKNode
            
            //        let touch = touches.first as UITouch?
            //        let touchLocation = touch?.location(in: self)
            //        let targetNode = atPoint(touchLocation!) as! SKSpriteNode
            
            for press in touches
            {
                //print("press: ", press)
                
                let touchEnded = atPoint(press.location(in: self))
                if touchEnded.name == "throttle"
                {
                    throttleTouched = false
                }
            }
            
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
                
                case "throttle":
                    print("cancel throttle")
                    throttleTouched = false
                
                default:
                    print("cancel undefined node")
            }
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
        
        circle.name = "radar: planet " + String(planetCounter)
        circle.fillTexture = SKTexture(imageNamed: "gravel_dirt")
        circle.alpha = 0.6
        planetCounter += 1
        // circle.strokeColor = SKColor.brown
        // circle.glowWidth = 1.0
        circle.fillColor = color
        circle.zPosition = 14
        self.addChild(circle)
        
    }
    
    func updateRadar()
    {
        self.enumerateChildNodes(withName: "radar image", using: ({(item, error) in
            item.removeFromParent()
        }))
        
        
        
        self.enumerateChildNodes(withName: "radar:*", using: ({(planet, error) in
            let planetRadiusScaled = (planet.frame.width / 2) / 25
            //print("planet radius: ", planetRadius)

            let changeInX =  -(self.player.position.x / 2.0) + planet.position.x
            let changeInY = -(self.player.position.y / 2.0) + planet.position.y
            
           
            
            
            
                
                let scaledX = (changeInX ) / (self.radarNode.frame.width / 2)
                let scaledY = (changeInY ) / (self.radarNode.frame.height / 2)
            
        
            
                let circle = SKShapeNode(circleOfRadius: planetRadiusScaled ) // Size of Circle = Radius setting.
                circle.position.x = scaledX * 2.5 + self.radarNode.position.x
                circle.position.y = scaledY * 2.5 + self.radarNode.position.y
                circle.strokeColor = .black
                
                circle.name = "radar image"
                // circle.fillColor = planet.fillcolor
                //circle.alpha = 0.6
                // planetCounter += 1
                // circle.strokeColor = SKColor.brown
                // circle.glowWidth = 1.0
                
                if planet is SKShapeNode
                {
                    circle.fillTexture = (planet as! SKShapeNode).fillTexture
                    circle.fillColor = (planet as! SKShapeNode).fillColor
                    circle.strokeColor = (planet as! SKShapeNode).fillColor
                }
                
                circle.zPosition = 36
            
            let xDistance =  self.radarNode.position.x - circle.position.x
            let yDistance =  self.radarNode.position.y - circle.position.y
            
            let distance = sqrt(xDistance * xDistance + yDistance * yDistance)
            
            print("distance: ", distance)
            if distance < self.radarRadius - circle.frame.width
            {
                self.addChild(circle)
            }
            
            
 
        }))
        
//        player = SKSpriteNode(imageNamed: "playerShip1_blue")
//        player.setScale(0.4)
//        player.zPosition = 10
        
        let radarPlayer = SKSpriteNode(imageNamed: "playerShip1_blue")
        radarPlayer.position = radarNode.position
        radarPlayer.setScale(0.1)
        radarPlayer.zPosition = 36
        radarPlayer.zRotation = player.zRotation
        radarPlayer.name = "radar image"
        addChild(radarPlayer)
        
    }
    
    //func landOnPlanet(name: String)
    func landOnPlanet(planet: SKShapeNode)
    {
        let gameScene = GameScene(fileNamed: "GameScene")!
        gameScene.size = CGSize(width: 1334, height: 750)
        gameScene.scaleMode = .aspectFit
        var usePlanetName = planet.name
        
        if usePlanetName?.hasPrefix("radar:") != nil
        {
            usePlanetName = String(usePlanetName?.dropFirst(6) ?? "")
        }
        gameScene.planetName =  usePlanetName ?? ""
        
        
        
        let angle = atan2(self.player.position.x - planet.position.x, self.player.position.y - planet.position.y)
        
        gameScene.landingAngle = angle
        gameScene.landedFillColor = planet.fillColor
        
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
                playerAngleVelocity += 0.5// 1
                print("pushing left playerangleVelocity: ", playerAngleVelocity)
                if playerAngleVelocity > angleMax
                {
                    playerAngleVelocity = angleMax
                }
                
            }
            
            if pushingRight
            {
                playerAngleVelocity -= 0.5 // 1
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
                
                if abs(playerAngleVelocity) <= 0.5
                {
                    playerAngleVelocity = 0
                }
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
        
        self.enumerateChildNodes(withName: "*planet*", using: ({(planet, error) in
            let planetRadius = planet.frame.width / 2
            //print("planet radius: ", planetRadius)
            let usePlayerSize = min(self.player.frame.height, self.player.frame.width)
            let planetSize = planetRadius + usePlayerSize / 2 // (self.player.frame.height / 2.0) // 5 is just an added buffer
            
            let changeInX = self.player.position.x - planet.position.x
            let changeInY = self.player.position.y - planet.position.y
            
            let distanceFromPlanet = sqrt( changeInX * changeInX + changeInY * changeInY)
            
           // if abs(self.player.position.x - planet.position.x) < planetSize && abs(self.player.position.y - planet.position.y) < planetSize
                
            if distanceFromPlanet < planetSize
            {
                print("in planet - do stuff")
                print("landing on planet: ", planet.name ?? "Unknown")
                
                self.landOnPlanet(planet: planet as! SKShapeNode)  //MARK: need to add back
            }
            
          //  print("player size: ", self.player.frame.width,", ",self.player.frame.height)
            
        }))
        
        
        if !isLocationOnScreen(position: player.position)  && counter > 5
        {
            counter = 0
            print("off screen - need to adjust view")
        
            let changeInX = -player.position.x / 2
            let changeInY = -player.position.y / 2
            
            let movePlanet = SKAction.move(to: CGPoint(x: asteroid.position.x + changeInX, y: asteroid.position.y + changeInY), duration: 0.2)
            counter = -20
            asteroid.run(movePlanet)
            
            let moveNebula = SKAction.move(to: CGPoint(x: nebula.position.x + changeInX, y: nebula.position.y + changeInY), duration: 0.2)
            nebula.run(moveNebula)
            
            
            self.enumerateChildNodes(withName: "*planet*", using: ({
                (planet, error) in
                let movePlanet = SKAction.move(to: CGPoint(x: planet.position.x + changeInX, y: planet.position.y + changeInY), duration: 0.2)
                planet.run(movePlanet)
            }))
            
            
            
            
            let movePlayer = SKAction.move(to: CGPoint(x: player.position.x + changeInX, y: player.position.y + changeInY), duration: 0.2)
            player.run(movePlayer)
            
            
        }
        let throttleSpeed = ((throttle.position.y + 300) / 450) * 15
        
       // print("throttle speed: ", throttleSpeed)
        
        if throttleSpeed < playerVelocity
        {
            playerVelocity -= 0.1
        }
        
        if throttleSpeed > playerVelocity
        {
            playerVelocity += 0.1
        }
        
        if abs(throttleSpeed - playerVelocity) < 0.1
        {
            playerVelocity = throttleSpeed
        }
        
        
        player.zRotation = playerAngle * degreesToRadians
        
        player.position = CGPoint(x:player.position.x - sin(player.zRotation) * playerVelocity / 2.0,y:player.position.y + cos(player.zRotation) * playerVelocity / 2.0)
        
        //player.position = CGPoint(x:player.position.x - sin(player.zRotation) * throttleSpeed / 2.0,y:player.position.y + cos(player.zRotation) * throttleSpeed / 2.0)
        
        var flameSize = throttleSpeed * 4
       // var flameSize = playerVelocity * 4
        if flameSize > 30
        {
            flameSize = 30
        }
        
        if flameSize < 0
        {
            flameSize = 0
        }
        
//print("playerVelocity: ", playerVelocity)
        
        fireNode.position.x = player.position.x + flameSize * sin(player.zRotation)
        fireNode.position.y = player.position.y - flameSize * cos(player.zRotation)
        fireNode.zRotation = player.zRotation
        
        updateRadar()
        showActiveTouches()
        
    }
}
