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
    var playerPosition = CGPoint(x: 25, y: 2)
    
    var counter = 0
    var recentered = false
    var falling = false
    
    let canJump = [Character(" "), "r", "p", "^", "B"]
    
    var mapCenteredLoc = 15
    var planetCircumferance = 50
    
    let jumpSound = Sound(name: "jumpSound", type: "mp3")
    
    
    let displaytileHeight = 10
    let displaytileWidth = 28 // will add one for center I believe
    
    var spriteList = [SKSpriteNode]()
    
    var button: SKNode! = nil
    
    let playerCategory: UInt32 = 0b001
    let landCategory: UInt32 = 0b010
    
    
    private var player = SKSpriteNode()
    private var playerWalkingFrames: [SKTexture] = []

    override func didMove(to view: SKView)
    {
        let background = SKSpriteNode(imageNamed: "purple")
        background.size = self.frame.size
        background.zPosition = 0
        addChild(background)
   
        addStars()
        buildPlanetMap(planetCircumferance: planetCircumferance)
        drawPlanetCenteredAt(x: mapCenteredLoc)
        printMap()
        
        button = SKSpriteNode(color: .blue, size: CGSize(width: 50, height: 50))
        button.position = CGPoint(x:0, y: 124);
        button.zPosition = 35
        button.name = "jump"
        self.addChild(button)
        
        button = SKSpriteNode(color: .blue, size: CGSize(width: 50, height: 50))
        button.position = CGPoint(x:0, y: 20);
        button.zPosition = 35
        button.name = "down"
        self.addChild(button)
        
        
        button = SKSpriteNode(color: .red, size: CGSize(width: 100, height: 100))
        button.position = CGPoint(x:100, y: 24);
        button.zPosition = 35
        button.name = "right"
        self.addChild(button)
        
        button = SKSpriteNode(color: .green, size: CGSize(width: 100, height: 100))
        button.position = CGPoint(x:-100, y: 24);
        button.zPosition = 35
        button.name = "left"
        
        self.addChild(button)
        
        buildPlayer()
        player.xScale = -player.xScale
        placePlayer()
    }
    
    func placePlayer()
    {
        if let position = findPositionofMapLocation(x: playerPosition.x , y: playerPosition.y)
        {
            player.position.x = position.x
            player.position.y = position.y
        }
        else
        {
            print("ERROR placing player!")
        }
        
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
    
    func buildPlayer()
    {
        let playerAnimatedAtlas = SKTextureAtlas(named:"p1_walk")
        var walkFrames: [SKTexture] = []
        
        let numImages = playerAnimatedAtlas.textureNames.count
        for i in 1...numImages
        {
            var playerTextureName = "p1_walk0\(i)"
            
            if i >= 10
            {
                playerTextureName = "p1_walk\(i)"
            }
            
            walkFrames.append(playerAnimatedAtlas.textureNamed(playerTextureName))
        }
        playerWalkingFrames = walkFrames
        
        let firstFrameTexture = playerWalkingFrames[0]
        player = SKSpriteNode(texture: firstFrameTexture)
        player.position = CGPoint(x:frame.midX, y: frame.midY)
        player.setScale(0.4)
        player.zPosition = 12
        player.name = "player"
        
        addChild(player)
    }
    
    func animatePlayer()
    {
        player.run(SKAction.repeatForever(
            SKAction.animate(with: playerWalkingFrames, timePerFrame: 0.1,
                             resize: false,
                             restore: true)),
        withKey: "PlayerWalkingInPlace")
    }
    
    func addLand(x: Int, y: Int, type: String)
    {
        let land = SKSpriteNode(imageNamed: type)
        land.setScale(0.3)
        land.zPosition = 10
        land.position =  CGPoint(x: x, y: y)
        land.name = "land:" + type
        
        if type.contains("ufo")
        {
           // print("start Ufo animation")
            let tiltRight = SKAction.rotate(byAngle: 0.1, duration: 0.1)
            
            land.run(SKAction.repeatForever(tiltRight))
            
        }
        if type.contains("Ship")
        {
           // print("start Ship animation")
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
    
        for i in -((displaytileWidth) / 2)...(displaytileWidth / 2)
        {
            displayX = mapCenteredLoc + i
            if displayX < 0
            {
                displayX += planetCircumferance + 1
            }
            
            if displayX > planetCircumferance
            {
                displayX -= planetCircumferance + 1
            }
            
            let yAdjust = -((abs(i) * 2) + ((i * i) / 4))
            let xPos = i * Int(grass.size.width )
            for j in 1...displaytileHeight
            
            {
                let yPos = Int(yAdjust - Int(dirt.size.height  ) * (j + 1))
                addLandAtLoc(x: xPos, y: yPos, mapChar: planetMap[displayX][j])
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
            
            case "B":
                addLand(x: x, y: y, type: "fence_wood")
            
            case "r":
                addLand(x: x, y: y, type: "rock")
            
            case "p":
                addLand(x: x, y: y, type: "tile_grassPurpleLarge")
            
            case "!":
                addLand(x: x, y: y, type: "wingMan1")
            
            default:
            print("undefined")
        }
    }
    
    func buildPlanetMap(planetCircumferance: Int)
    {
        playerPosition = CGPoint(x: planetCircumferance / 2, y: 2)
        print("building map")
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
                
                if j == 2 && Int.random(in: 0...100) > 80
                {
                    planetMap[i][j] = "r"
                }
                
                if j == 2 && Int.random(in: 0...100) > 90
                {
                    planetMap[i][j] = "p"
                }
                
                if i == (planetCircumferance / 2) && j == 2
                {
                    planetMap[i][j] = "^"
                }
                
                if i == 3 && j == 1
                {
                    planetMap[i][j] = "u"
                }
                
                if i == 36 && j == 2
                {
                    planetMap[i][j] = "!"
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
    
    func moveLeft()
    {
        player.xScale = -abs(player.xScale)
        
        if (player.action(forKey: "falling") != nil)
        {
            return
        }
        
        if canJump.contains(planetMap[Int(playerPosition.x)][Int(playerPosition.y) + 1])
        {
            print("falling in left")
            falling = true
            moveDown()
           // return
        }
        movePlayer(tiles: -1)
    }

    func moveRight()
    {
        if (player.action(forKey: "falling") != nil)
        {
            return
        }
        
        player.xScale = abs(player.xScale)
        
        if canJump.contains(planetMap[Int(playerPosition.x)][Int(playerPosition.y) + 1])
        {
            print("falling in right")
            falling = true
            moveDown()
           // return
        }
        
        movePlayer(tiles: 1)
        
        
    }
    
    func distanceFromCenter(x: Int, y: Int) -> Int
    {
        let distance1 = abs(mapCenteredLoc - x)
        let distance2 = abs(x - (planetCircumferance + 1)  - mapCenteredLoc)
        let distance3 = abs(x + (planetCircumferance + 1) - mapCenteredLoc)
        
      //  print("d1: ", distance1, ",d2: ", distance2, ",d3: ", distance3)
        var shortestDistance = min(distance1, distance2, distance3)
        
        if shortestDistance == abs(x - mapCenteredLoc)
        {
            shortestDistance = x - mapCenteredLoc
        }
        
        if shortestDistance == abs(x - (planetCircumferance + 1) - mapCenteredLoc)
        {
            shortestDistance = x - (planetCircumferance + 1) - mapCenteredLoc
        }
        
        if shortestDistance == abs(x + planetCircumferance + 1 - mapCenteredLoc)
        {
            shortestDistance = x + (planetCircumferance + 1) - mapCenteredLoc
        }
        
        return shortestDistance
        
        
        
    }
    
    func movePlayer(tiles: Int)  //positive for right, negative for left
    {
        recentered = false
        playerPosition.x += CGFloat(tiles)
        
        if playerPosition.x < 0
        {
            playerPosition.x += CGFloat(planetCircumferance + 1)
        }
        
        if playerPosition.x > CGFloat(planetCircumferance)
        {
            playerPosition.x -= CGFloat(planetCircumferance + 1)
        }
        
        player.xScale = abs(player.xScale) * CGFloat(tiles.signum())
        
        if  abs(distanceFromCenter(x: Int(playerPosition.x), y: Int(playerPosition.y))) > (displaytileWidth / 2) - 2
        {
            recentered = true
        }
        
        if let position = findPositionofMapLocation(x: CGFloat(playerPosition.x), y: CGFloat(playerPosition.y))
        {
            
            if !recentered && (player.action(forKey: "moving") == nil) && (player.action(forKey: "falling") == nil)
            {
                let movePlayerAction = SKAction.move(to: position, duration: 0.25)
                let animate = SKAction.animate(with: playerWalkingFrames, timePerFrame: 0.1, resize: false, restore: true)
                player.run(animate, withKey: "walking")
                player.run(.sequence([movePlayerAction, .run({self.playerMoveEnded()}), .setTexture(SKTexture(imageNamed:"p1_stand"))]), withKey: "moving")
            }
            else
            {
                player.position.x = position.x
                player.position.y = position.y
            }
        }
        
//        if canJump.contains(planetMap[Int(playerPosition.x)][Int(playerPosition.y) + 1])
//        {
//            falling = true
//            print("falling in move...")
//            moveDown()
//        }
        
    }
    
    func moveDisplay(by: Int)
    {
        print("moving by: ", by)
        mapCenteredLoc += by
        
        if mapCenteredLoc > planetCircumferance
        {
            mapCenteredLoc -= planetCircumferance
        }
        
        if mapCenteredLoc < 0
        {
            mapCenteredLoc += planetCircumferance
        }
        
        drawPlanetCenteredAt(x: mapCenteredLoc)
        placePlayer()
        
        
    }
    
    func recenterPlayer()
    {
        print("recentering...")
        while mapCenteredLoc != Int(playerPosition.x)
        {
            let moveBy = distanceFromCenter(x: Int(playerPosition.x), y: Int(playerPosition.y)).signum()
            print("adjusting by: ",distanceFromCenter(x: Int(playerPosition.x), y: Int(playerPosition.y)).signum())
              mapCenteredLoc += moveBy

            if mapCenteredLoc > planetCircumferance
            {
                mapCenteredLoc -= planetCircumferance
            }

            if mapCenteredLoc < 0
            {
                mapCenteredLoc += planetCircumferance
            }

            let delay = SKAction.wait(forDuration: 0.1)
            let redrawMap = SKAction.run({self.drawPlanetCenteredAt(x: self.mapCenteredLoc)})
            let drawSequence = SKAction.sequence([delay, redrawMap])
            player.run(drawSequence)
 
        }
        
    }
    
    func playerMoveEnded()
    {
        player.removeAllActions()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
    
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
      
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let touch = touches.first as UITouch?
        let touchLocation = touch?.location(in: self)
        let targetNode = atPoint(touchLocation!) as! SKSpriteNode
        
        if targetNode.name == "right"
            {
                moveRight()
                print("tapped right!")
            }
            
            if targetNode.name == "left"
            {
                
                moveLeft()
                print("tapped left!")
            }
        
        
        if targetNode.name == "jump" && player.action(forKey: "jumping") == nil && player.action(forKey: "moving") == nil
        {
            print("jump")
       
            let currentCharacter = planetMap[Int(playerPosition.x)][Int(playerPosition.y)]
            
            if canJump.contains(currentCharacter) //currentCharacter == " " || currentCharacter == "r" || currentCharacter == "^" || currentCharacter == "p"
            {
                let jump = SKAction.moveBy(x: 0.0, y: 20.0, duration: 0.25)
                let jumpTexture = SKTexture(imageNamed: "p1_jump")
                let land = SKAction.moveBy(x: 0.0, y: -20.0, duration: 0.25)
                jumpSound.play()
                player.run(.sequence([.setTexture(jumpTexture), jump, land]), completion: {self.player.texture = SKTexture(imageNamed: "p1_stand")})//,withKey: "jumping")
                
            }
            else
            {
                playerPosition.y -= 1
                let position = findPositionofMapLocation(x: CGFloat(playerPosition.x), y: CGFloat(playerPosition.y))!
                let movePlayerAction = SKAction.move(to: position, duration: 0.25)
                let animate = SKAction.animate(with: playerWalkingFrames, timePerFrame: 0.1, resize: false, restore: true)
                player.run(animate, withKey: "walking")
                player.run(.sequence([movePlayerAction, .run({self.playerMoveEnded()}), .setTexture(SKTexture(imageNamed:"p1_stand"))]), withKey: "moving")
                
            }
            
        }
        
        if targetNode.name == "down"
        {
            moveDown()
            
            print("tapped down!")
        }
        
        
        if targetNode.name != nil
        {
            if (targetNode.name?.description.contains("dirt"))!
            {
                targetNode.removeFromParent()
        
                let mapLocation = mapLocationPressed(x: targetNode.position.x, y: touchLocation!.y)
                print("character at map location is: ", planetMap[mapLocation.mapLocationX][mapLocation.mapLocationY])
                planetMap[mapLocation.mapLocationX][mapLocation.mapLocationY] = "B"
                
                if canJump.contains(planetMap[Int(playerPosition.x)][Int(playerPosition.y) + 1])
                {
                    falling = true
                    print("falling in touch...")
                    moveDown()
                }
                drawPlanetCenteredAt(x: Int(playerPosition.x))
            }
            else
            {
                if (targetNode.name?.contains("land:"))!
                {
                    let mapLocation = mapLocationPressed(x: touchLocation!.x, y: touchLocation!.y)
                    print("character at map location is: ", planetMap[mapLocation.mapLocationX][mapLocation.mapLocationY])
                }
                
            }
        }
        
        
    }
    
    func fall()
    {
        
    }
    
    func moveDown()
    {
        var delay = SKAction.wait(forDuration: 0.0)
        if (player.action(forKey: "moving") != nil) && falling
        {
            delay = SKAction.wait(forDuration: 0.1)
            //return
        }
       
        playerPosition.y += 1
        
        if playerPosition.y > 9 //mapheight
        {
            playerPosition.y = 9
        }
        
        let usePosition = findPositionofMapLocation(x: CGFloat(playerPosition.x), y: CGFloat(playerPosition.y))!
        
        let movePlayerActionVertical = SKAction.move(to: usePosition, duration: 0.15)
    
       // let animate = SKAction.animate(with: playerWalkingFrames, timePerFrame: 0.1, resize: false, restore: true)
        
        if falling
        {
            if (player.action(forKey: "falling") == nil)
            {
    
                player.run(.sequence([delay, movePlayerActionVertical, .run({self.playerMoveEnded()}), .setTexture(SKTexture(imageNamed:"p1_stand"))]), withKey: "falling")
                
            }
        }
        else
        {
            if (player.action(forKey: "falling") == nil)
            {
               //player.run(animate, withKey: "walking")
                animatePlayer()
                player.run(.sequence([delay, movePlayerActionVertical, .run({self.playerMoveEnded()}), .setTexture(SKTexture(imageNamed:"p1_stand"))]), withKey: "moving")
            }
        }
        
    }
    
    func findPositionofMapLocation(x: CGFloat, y: CGFloat) -> CGPoint? //(x: CGFloat, y: CGFloat)?
    {
        
        var adjustedDisplayX = x - CGFloat(mapCenteredLoc)
        
        var displayMin = mapCenteredLoc - displaytileWidth / 2
        var displayMax = mapCenteredLoc + displaytileWidth / 2
        
        if displayMin < 0
        {
            displayMin += planetCircumferance + 1
        }
        
        if displayMax > planetCircumferance
        {
            displayMax -= planetCircumferance + 1
        }

        if displayMax < displayMin  && abs(adjustedDisplayX) > CGFloat(displaytileWidth / 2)
        {
             
            if adjustedDisplayX < 0
            {
                adjustedDisplayX += CGFloat(planetCircumferance + 1)
            }
            
            if adjustedDisplayX > CGFloat(planetCircumferance) || x > CGFloat(displayMin)
            {
                adjustedDisplayX -= CGFloat(planetCircumferance + 1)
            }
        }
        
        let tile = SKSpriteNode(imageNamed:"dirt_grass")
        tile.setScale(0.3)
        
        let yAdjust = -((abs(adjustedDisplayX) * 2) + ((adjustedDisplayX * adjustedDisplayX) / 4))
        let xPos = adjustedDisplayX * (tile.size.width)
        
        let yPos = (yAdjust - (tile.size.height) * (CGFloat(y) + 1.0))
    
        return CGPoint(x: xPos, y: yPos)
        
    }
    
    
    func mapLocationPressed(x: CGFloat, y: CGFloat) -> (mapLocationX: Int,mapLocationY: Int)
    {
        let grass = SKSpriteNode(imageNamed:"dirt_grass")
        grass.setScale(0.3)
        
        var xAdjustment = -(x / grass.size.width)
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
      
        while useX > planetCircumferance
        {
            useX -= planetCircumferance
        }

        while useX < 0
        {
            useX += planetCircumferance
        }

        let adjustedi = xAdjustment
       
        let doubleX = CGFloat(abs(Double(adjustedi)) * 2.0) + (adjustedi*adjustedi) / 4.0
       
        let tileHeight = grass.size.height
        
        let adjustedY = y + doubleX + tileHeight
        let heightInTiles = -(adjustedY / tileHeight)
        
        var heightAdjustmentForX = CGFloat(abs(useX)*2)
        heightAdjustmentForX += CGFloat((useX * useX)) / 4.0
   
        var actualY = heightInTiles
        
        if actualY < 0
        {
            actualY += 0.4
        }
        
        if actualY > 0
        {
            actualY -= 0.4
        }
        
        if actualY < 0
        {
            actualY = 0
        }
        
        return  (useX ,Int(actualY) + 1)
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?)
    {
      
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        counter += 1
        
        if (player.action(forKey: "moving") == nil)
        {
           // player.texture = SKTexture(imageNamed: "p1_stand")
        }
        
        let playerDistanceFromCenter = distanceFromCenter(x: Int(playerPosition.x), y: Int(playerPosition.y))
        if recentered //&& counter > 10 //(abs(playerDistanceFromCenter) > (displaytileWidth / 2)) && counter > 10
         {
            counter = 0
            
            if mapCenteredLoc == Int(playerPosition.x)
            {
                recentered = false
            }
            let moveBy = playerDistanceFromCenter.signum()
            print("adjusting by: ",distanceFromCenter(x: Int(playerPosition.x), y: Int(playerPosition.y)).signum())
            moveDisplay(by: moveBy)
            
        }
        
        if (player.action(forKey: "falling") == nil)
        {
            falling = false
        }
        if canJump.contains(planetMap[Int(playerPosition.x)][Int(playerPosition.y + 1.0)]) && (player.action(forKey: "falling") == nil) && (player.action(forKey: "moving") == nil)
        {
            print("falling in update")
            falling = true
            moveDown()
        }
    }
}

