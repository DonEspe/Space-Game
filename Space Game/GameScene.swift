//
//  GameScene.swift
//  Space Game
//
//  Created by Don Espe on 4/2/20.
//  Copyright © 2020 Ducky Planet LLC. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    var planetMap = Array(repeating: Array(repeating: Character("."), count: 20), count: 100)// [[Character]]()
    var playerPosition = (x: 25, y: 3)
    var mapCenteredLoc = 15
    var planetCircumferance = 50
    
    var spriteList = [SKSpriteNode]()
    
    var button: SKNode! = nil

    override func didMove(to view: SKView) {
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        
        
        
        let grass = SKSpriteNode(imageNamed:"dirt_grass")
        grass.setScale(0.3)
        
        let dirt = SKSpriteNode(imageNamed: "gravel_dirt")
        dirt.setScale(0.3)
        
        let background = SKSpriteNode(imageNamed: "purple")
        background.size.height = size.height
        background.size.width = size.width
        background.zPosition = 0
        addChild(background)
        
        
        
        addStars()
        buildPlanetMap(planetCircumferance: planetCircumferance)
        drawPlanetCenteredAt(x: mapCenteredLoc)
        printMap()
        
        button = SKSpriteNode(color: .red, size: CGSize(width: 100, height: 100))
        // Put it in the center of the scene
        button.position = CGPoint(x:100, y: 24);
        button.zPosition = 35
        button.name = "right"
        
        self.addChild(button)
        
        button = SKSpriteNode(color: .green, size: CGSize(width: 100, height: 100))
        // Put it in the center of the scene
        button.position = CGPoint(x:-100, y: 24);
        button.zPosition = 35
        button.name = "left"
        
        self.addChild(button)
        
        
//        for i in 0...14
//        {
//            let yAdjust = -((i * 2) + (i * i / 4))
//            addLand(x: i * Int(grass.size.width), y:yAdjust, type: "dirt_grass")
//            addLand(x: -(i * Int(grass.size.width)), y: yAdjust, type: "dirt_grass")
//
//            for j in 0...10
//            {
//                addLand(x: i * Int(dirt.size.width), y: Int(yAdjust - Int(dirt.size.height) * (j + 1)), type: "gravel_dirt")
//                addLand(x: -(i * Int(dirt.size.width)), y: Int(yAdjust - Int(dirt.size.height) * (j + 1)), type: "gravel_dirt")
//
//            }
//
//        }
//
        
        
        //  land.position =  CGPoint(x: i * Int(land.size.width), y: 0) //size.width * 0.1, y: size.height * 0.5)
        //  addChild(land)
        
        //  land.position =  CGPoint(x: -(i * Int(land.size.width)), y: 0) //size.width * 0.1, y: size.height * 0.5)
        //  addChild(land)
        // }
    }
    
    func printMap()
    {
        for j in 0...18
        {
            for  i in 0...90
            {
                print(planetMap[i][j], terminator:"")
            }
            print("\n")
        }
    }
    
    func addLand(x: Int, y: Int, type: String)
    {
        let land = SKSpriteNode(imageNamed: type)
        land.setScale(0.3)
        land.zPosition = 10
        land.position =  CGPoint(x: x, y: y)
      //  land.color = .red
       // land.colorBlendFactor = 0.4
        land.name = "land:" + type
        
        if type.contains("ufo")
        {
            print("start Ufo animation")
            let tiltRight = SKAction.rotate(byAngle: 0.1, duration: 0.1)
            
            land.run(SKAction.repeatForever(tiltRight))
            
        }
        if type.contains("Ship")
        {
            print("start Ship animation")
            let tiltRight = SKAction.rotate(byAngle: 0.1, duration: 0.25)
            let delay = SKAction.wait(forDuration: 0.1)
            let tiltLeft = SKAction.rotate(byAngle: -0.1, duration: 0.25)
            
            land.run(SKAction.repeatForever(SKAction.sequence([tiltRight, tiltLeft, delay, tiltLeft, tiltRight, delay])))
            
        }
        
        addChild(land)
        spriteList.append(land)
    }
    
    func addStars()
    {
        for _ in 0...12
        {
            let star = SKSpriteNode(imageNamed: "star1")
            let starX = Double.random(in: Double(-size.width / 2.0)...Double(size.width / 2.0))
            let starY = Double.random(in: 0...Double(size.height / 2.0))
            star.position = CGPoint(x: starX , y: starY)
            star.zPosition = 2
            star.name = "star"
            star.color = .blue
            star.colorBlendFactor = 0.5
            addChild(star)
            
            let time = Double.random(in: 0.5...2)
            
            let fadeOut = SKAction.fadeAlpha(to: 0.5, duration: time)
            let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: time)
            
            star.run(SKAction.repeatForever(SKAction.sequence([fadeIn, fadeOut])))
        }
        
    }
    
    func drawPlanetCenteredAt(x: Int)
    {
        for sprite in spriteList
        {
            sprite.removeFromParent()
        }
        
        let grass = SKSpriteNode(imageNamed:"dirt_grass")
        grass.setScale(0.3)
        
        let dirt = SKSpriteNode(imageNamed: "gravel_dirt")
        dirt.setScale(0.3)
        
        var displayX:Int
    
        for i in -14...14
        {
            displayX = mapCenteredLoc + i  //-?
            if displayX < 0
            {
                displayX += planetCircumferance
            }
            
            if displayX > planetCircumferance
            {
                displayX -= planetCircumferance
            }
            
            let yAdjust = -((abs(i) * 2) + ((i * i) / 4))
            let xPos = i * Int(grass.size.width)
            
            for j in 0...10
            
            {
                addLandAtLoc(x: xPos, y: Int(yAdjust - Int(dirt.size.height) * (j + 1)), mapChar: planetMap[displayX][j])
            }
            
        }
    }
    
    func addLandAtLoc(x: Int, y: Int, mapChar: Character)
    {
        switch mapChar
        {
            case " ":
            //print("blank")
              break
            
            case "X":
            //print("grass")
            addLand(x: x, y: y, type: "dirt_grass")
            
            case "S":
            //print("sand")
            addLand(x: x, y: y, type: "dirt_sand")
            
            case ".":
           // print("dirt")
            addLand(x: x, y: y, type: "gravel_dirt")
            
            case "^":
            addLand(x: x, y: y, type: "playerShip1_blue")
        
            case "u":
                addLand(x: x, y: y, type: "ufoGreen.png")
            
            case "d":
                addLand(x: x, y: y, type: "gravel_stone")
            
            default:
            print("undefined")
        }
    }
    
    func buildPlanetMap(planetCircumferance: Int)
    {
        playerPosition = (x: planetCircumferance / 2, y: 3)
        mapCenteredLoc = planetCircumferance / 2
        for i in 0...planetCircumferance
        {
            for j in 0...10
            {
                if j == 3 //&& j < 7
                {
                    if Int.random(in: 0...100) > 75
                    {
                    planetMap[i][j] = "X"
                    }
                    else
                    {
                        planetMap[i][j] = "S"
                    }
                }
                else
                {
                    if j > 3
                    {
                        planetMap[i][j] = "."
                    }
                    if j < 3
                    {
                        planetMap[i][j] = " "
                    }
                }
                if i == (planetCircumferance / 2) && j == 2
                {
                    planetMap[i][j] = "^"
                }
                
                if i == 3 && j == 1
                {
                    planetMap[i][j] = "u"
                }
                
                if i == 10 && j == 8
                {
                    planetMap[i][j] = "d"
                }
                
            }
        }
    }
    
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      //  if let label = self.label {
       //     label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
      //  }
        
     //   for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
      //  for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
      //  for t in touches { self.touchUp(atPoint: t.location(in: self)) }
        
        let touch = touches.first as UITouch?
        let touchLocation = touch?.location(in: self)
        let targetNode = atPoint(touchLocation!) as! SKSpriteNode
        
            if targetNode.name == "right"
            {
                mapCenteredLoc += 1
                if mapCenteredLoc > planetCircumferance
                {
                    mapCenteredLoc -= planetCircumferance
                }
                print("map centered at: ", mapCenteredLoc)
                drawPlanetCenteredAt(x: mapCenteredLoc)
                print("tapped right!")
            }
            
            if targetNode.name == "left"
            {
                mapCenteredLoc -= 1
                if mapCenteredLoc < 0
                {
                    mapCenteredLoc += planetCircumferance
                }
                print("map centered at: ", mapCenteredLoc)
                drawPlanetCenteredAt(x: mapCenteredLoc)
                print("tapped left!")
            }
        if targetNode.name != nil
        {
            if (targetNode.name?.description.contains("dirt"))!
            {
                targetNode.removeFromParent()
                print("map location pressed: ", mapLocationPressed(x: touchLocation!.x, y: touchLocation!.y))
                let mapLocation = mapLocationPressed(x: touchLocation!.x, y: touchLocation!.y)
                print("character at map location is: ", planetMap[mapLocation.mapLocationX][mapLocation.mapLocationY])
            }
            else
            {
                if (targetNode.name?.contains("land:"))!
                {
                    print("map location pressed: ", mapLocationPressed(x: touchLocation!.x, y: touchLocation!.y))
                    let mapLocation = mapLocationPressed(x: touchLocation!.x, y: touchLocation!.y)
                    print("character at map location is: ", planetMap[mapLocation.mapLocationX][mapLocation.mapLocationY])
                }
                
            }
        }
        
        
    }
    
    
    func mapLocationPressed(x: CGFloat, y: CGFloat) -> (mapLocationX: Int,mapLocationY: Int)
    {
        let grass = SKSpriteNode(imageNamed:"dirt_grass")
        grass.setScale(0.3)
        
        var xAdjustment = -(x / grass.size.width)  //-?
        print("unrounded xAdjustment: ", xAdjustment)
        
        if xAdjustment < 0
        {
            xAdjustment -= 0.5
        }
        else
        {
            xAdjustment += 0.5
        }
        
        var useX = (planetCircumferance +  Int(mapCenteredLoc - Int(xAdjustment)))
        
        print("useX before adjustment: ", useX)
        if useX > planetCircumferance
        {
            useX -= planetCircumferance
        }
        
        if useX < 0
        {
            useX += planetCircumferance
        }
        
      //  let absPart = Double(-(abs(Double(useX)) * 2.0))
//        var actualY = absPart + (Double((useX * useX)) / 4.0)
        let adjustedi = xAdjustment// CGFloat(useX) - CGFloat(planetCircumferance) / 2.0
        print("adjusted i: ", adjustedi)
        let doubleX = CGFloat(abs(Double(adjustedi)) * 2.0) + (adjustedi*adjustedi) / 4.0
       
        let tileHeight = grass.size.height
        
        var adjustedY = y + doubleX + tileHeight
        let heightInTiles = -(adjustedY / tileHeight)
        
        print("height in tiles ", heightInTiles, "at y position: ", y)
        
        var heightAdjustmentForX = CGFloat(abs(useX)*2)
        heightAdjustmentForX += CGFloat((useX * useX)) / 4.0
       // heightAdjustmentForX = -heightAdjustmentForX
        
        
    
      //  var actualY = ((y - CGFloat(heightAdjustmentForX)) / tileHeight) - 1
        var actualY = heightInTiles
        
        if actualY < 0
        {
            actualY += 0.5
        }
        
        if actualY > 0
        {
            actualY -= 0.5
        }
        
        if actualY < 0
        {
            actualY = 0
        }
        
        print("actualX: ",xAdjustment,", actualY: ", actualY)
        
        return  (useX ,Int(actualY) + 1)
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
      //  for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
