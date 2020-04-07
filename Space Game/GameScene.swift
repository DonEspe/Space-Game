//
//  GameScene.swift
//  Space Game
//
//  Created by Don Espe on 4/2/20.
//  Copyright © 2020 Ducky Planet LLC. All rights reserved.
//

import SpriteKit
import GameplayKit

var planetMap = Array(repeating: Array(repeating: Character("."), count: 20), count: 100)
var mapCenteredLocX = 15
var mapCenteredLocY = 2
var playerPosition = (x: 10, y: 2)

let displaytileHeight = 15
let displaytileWidth = 26 // will add one for center I believe


class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
   
    
    
    var counter = 0
    var recentered = false
    var falling = false
    
    var onLand = true
    var flying = false
    
    var planetCircumferance = 50
    
    let jumpSound = Sound(name: "jumpSound", type: "mp3")
    let hitSound = Sound(name: "stoneHit1", type: "mp3")
    
    
    let tileScale = CGFloat(0.4)
    
    var spriteList = [SKSpriteNode]()
    
    var button: SKNode! = nil
    
    let planetBuilder = PlanetBuilding()
    
    
    private var player = SKSpriteNode()
    private var playerWalkingFrames: [SKTexture] = []

    override func didMove(to view: SKView)
    {
        let background = SKSpriteNode(imageNamed: "purple")
        background.size = self.frame.size
        background.zPosition = 0
        addChild(background)
   
        addStars()
        planetBuilder.buildPlanetMap(planetCircumferance: planetCircumferance)
        drawPlanetCenteredAt(x: mapCenteredLocX, y: mapCenteredLocY)
        planetBuilder.printMap()
        
        button = SKSpriteNode(color: .blue, size: CGSize(width: 50, height: 50))
        button.position = CGPoint(x:0, y: 124);
        button.zPosition = 35
        button.name = "up"
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
    
    func rotatePlayer()
    {
        let distance =  CGFloat(distanceFromCenter(x: Int(playerPosition.x), y: Int(playerPosition.y)))
        if distance != 0
        {
            player.zRotation = -(.pi / 3) / (CGFloat(planetCircumferance) / distance)
        }
        else
        {
            player.zRotation = 0
        }
        print("player rotation: ", player.zRotation)
        
    }
    
    func placePlayer()
    {
        if let position = findPositionofMapLocation(x: playerPosition.x , y: playerPosition.y)
        {
            player.position.x = position.x
            player.position.y = position.y
            rotatePlayer()
           
        }
        else
        {
            print("ERROR placing player!")
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
        rotatePlayer()
        player.setScale(tileScale * 1.1)
        player.zPosition = 12
        player.name = "land: player"
        
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
        land.setScale(tileScale)
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
    
    func drawPlanetCenteredAt(x: Int, y: Int)
    {
        for sprite in spriteList
        {
            sprite.removeFromParent()
        }
        
        let tile = SKSpriteNode(imageNamed:"dirt_grass")
        tile.setScale(tileScale)
        
        //let dirt = SKSpriteNode(imageNamed: "gravel_dirt")
        //dirt.setScale(tileScale)
        
        var displayX:Int
    
        for i in -((displaytileWidth) / 2)...(displaytileWidth / 2)
        {
            displayX = mapCenteredLocX + i
            if displayX < 0
            {
                displayX += planetCircumferance + 1
            }
            
            if displayX > planetCircumferance
            {
                displayX -= planetCircumferance + 1
            }
            
            let yAdjust = -((abs(i) * 2) + ((i * i) / 4))
            let xPos = i * Int(tile.size.width )
            for j in 0...displaytileHeight
            
            {
                var yPos = Int(yAdjust - Int(tile.size.height  ) * (j + 1))
                yPos +=  (mapCenteredLocY - 3) * Int(tile.size.height)
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
    
    func adjustForWrap(x: Int) -> Int
    {
        var adjustedX = x
        if adjustedX < 0
        {
            adjustedX += planetCircumferance + 1
        }
        
        if adjustedX > planetCircumferance
        {
            adjustedX -= planetCircumferance + 1
        }
        
        
        return adjustedX
        
    }
    
    func moveLeft()
    {
        player.xScale = -abs(player.xScale)
        
        if (player.action(forKey: "falling") != nil)  || (player.action(forKey: "moving") != nil)
        {
            return
        }
        
        if canJump.contains(planetMap[Int(playerPosition.x)][Int(playerPosition.y) + 1])
        {
            counter = 0
            print("falling in left")
            falling = true
            moveDown()
            // return
        }
        
        
        if blocked.contains(planetMap[adjustForWrap(x: Int(playerPosition.x - 1))][Int(playerPosition.y)])
        {
            hitSound.play()
            let movePlayerAction = SKAction.move(by: CGVector(dx: -8.0, dy: 0.0), duration: 0.1)
            player.run(.sequence([ movePlayerAction, movePlayerAction.reversed()]), withKey: "moving")
            print("blocked")
            return
        }
        movePlayer(tiles: -1)
    }

    func moveRight()
    {
       if (player.action(forKey: "falling") != nil)  || (player.action(forKey: "moving") != nil)
        {
            return
        }
        
        player.xScale = abs(player.xScale)
        
        if canJump.contains(planetMap[Int(playerPosition.x)][Int(playerPosition.y) + 1])
        {
            print("falling in right")
            counter = 0
            falling = true
            moveDown()
           // return
        }
        
        if blocked.contains(planetMap[adjustForWrap(x: Int(playerPosition.x + 1))][Int(playerPosition.y)])
        {
            print("blocked")
            
            let movePlayerAction = SKAction.move(by: CGVector(dx: 8.0, dy: 0.0), duration: 0.1)
            player.run(.sequence([ movePlayerAction, movePlayerAction.reversed()]), withKey: "moving")
            
            hitSound.play()
            return
        }
        
        movePlayer(tiles: 1)
        
        
    }
    
    func distanceFromCenter(x: Int, y: Int) -> Int
    {
        let distance1 = abs(mapCenteredLocX - x)
        let distance2 = abs(x - (planetCircumferance + 1)  - mapCenteredLocX)
        let distance3 = abs(x + (planetCircumferance + 1) - mapCenteredLocX)
        
      //  print("d1: ", distance1, ",d2: ", distance2, ",d3: ", distance3)
        var shortestDistance = min(distance1, distance2, distance3)
        
        if shortestDistance == abs(x - mapCenteredLocX)
        {
            shortestDistance = x - mapCenteredLocX
        }
        
        if shortestDistance == abs(x - (planetCircumferance + 1) - mapCenteredLocX)
        {
            shortestDistance = x - (planetCircumferance + 1) - mapCenteredLocX
        }
        
        if shortestDistance == abs(x + planetCircumferance + 1 - mapCenteredLocX)
        {
            shortestDistance = x + (planetCircumferance + 1) - mapCenteredLocX
        }
        
        return shortestDistance
        
        
        
    }
    
    func movePlayer(tiles: Int)  //positive for right, negative for left
    {
       
        recentered = false
        playerPosition.x += tiles
        
        if playerPosition.x < 0
        {
            playerPosition.x += planetCircumferance + 1
        }
        
        if playerPosition.x > planetCircumferance
        {
            playerPosition.x -= planetCircumferance + 1
        }
        
        player.xScale = abs(player.xScale) * CGFloat(tiles.signum())
        rotatePlayer()
        
        if  abs(distanceFromCenter(x: Int(playerPosition.x), y: Int(playerPosition.y))) > (displaytileWidth / 2) - 2
        {
            recentered = true
        }
        
        if let position = findPositionofMapLocation(x: playerPosition.x, y: playerPosition.y)
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
                rotatePlayer()
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
        mapCenteredLocX += by
        
        if mapCenteredLocX > planetCircumferance
        {
            mapCenteredLocX -= planetCircumferance
        }
        
        if mapCenteredLocX < 0
        {
            mapCenteredLocX += planetCircumferance
        }
        
        drawPlanetCenteredAt(x: mapCenteredLocX, y: mapCenteredLocY)
        placePlayer()
        
        
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
        
        
        if targetNode.name == "up" && player.action(forKey: "jumping") == nil && player.action(forKey: "moving") == nil
        {
            print("up")
            
            if blocked.contains(planetMap[Int(playerPosition.x)][Int(playerPosition.y - 1)])
            {
                let movePlayerAction = SKAction.move(by: CGVector(dx: 0.0, dy: 8.0), duration: 0.1)
                player.run(.sequence([ movePlayerAction, movePlayerAction.reversed()]), withKey: "moving")
                
                hitSound.play()
                print("blocked")
                return
            }
            
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
               // dsds
                
                playerPosition.y -= 1
                let position = findPositionofMapLocation(x: playerPosition.x, y: playerPosition.y)!
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
              //  print("node name clicked: ", targetNode.name?.description)
                targetNode.removeFromParent()
        
                let mapLocation = mapLocationPressed(x: targetNode.position.x, y: targetNode.position.y)
              //  print("location clicked: ", mapLocation)
                print("character at map location is: ", planetMap[mapLocation.mapLocationX][mapLocation.mapLocationY])
                planetMap[mapLocation.mapLocationX][mapLocation.mapLocationY] = "B"
                
                if canJump.contains(planetMap[Int(playerPosition.x)][Int(playerPosition.y) + 1])
                {
                    counter = 0
                    falling = true
                    print("falling in touch...")
                    moveDown()
                }
                drawPlanetCenteredAt(x: Int(playerPosition.x), y: Int(playerPosition.y))
            }
            else
            {
                if (targetNode.name?.contains("land:"))!
                {
                    
                   // print("item is land:")
                    let mapLocation = mapLocationPressed(x: targetNode.position.x, y: targetNode.position.y) // targetNode.position.x, y: targetNode.position.y)
                    print("character at map location is: ", planetMap[mapLocation.mapLocationX][mapLocation.mapLocationY])
                }
                
            }
        }
    }
    
    func findFirstSolidGround(atX: Int, startingY: Int) -> Int
    {
        var checkY = startingY
        
        while !cantFallThrough.contains(planetMap[atX][checkY]) && checkY < displaytileHeight
        {
           // print("character at y: ", planetMap[atX][checkY])
            checkY += 1
        }
        checkY -= 1
        print("final y:", checkY)
        return checkY
        
    }
    
    func moveDown()
    {
        var delay = SKAction.wait(forDuration: 0.0)
        if (player.action(forKey: "moving") != nil) && falling
        {
            delay = SKAction.wait(forDuration: 0.1)
            //return
        }
        
        if blocked.contains(planetMap[Int(playerPosition.x)][Int(playerPosition.y + 1)])
        {
            hitSound.play()
            
            let movePlayerAction = SKAction.move(by: CGVector(dx: 0.0, dy: -5.0), duration: 0.1)
            player.run(.sequence([ movePlayerAction, movePlayerAction.reversed()]), withKey: "moving")
            
            print("blocked")
            return
        }
        
        playerPosition.y += 1
        
        if playerPosition.y > displaytileHeight //mapheight
        {
            playerPosition.y = displaytileHeight
        }
        
        
        let playerbounce = SKAction.move(by: CGVector(dx: 0.0, dy: 4.0), duration: 0.05)
        
       // let animate = SKAction.animate(with: playerWalkingFrames, timePerFrame: 0.1, resize: false, restore: true)
        
        if falling
        {
            if (player.action(forKey: "falling") == nil)
            {
                //var y = Int(playerPosition.y)
               
                let y = findFirstSolidGround(atX: Int(playerPosition.x), startingY: Int(playerPosition.y))
                let fallDistance = y - playerPosition.y + 1
                
                print("fall distance: ", fallDistance)
                
                playerPosition.y = y
                
                let usePosition = findPositionofMapLocation(x: playerPosition.x, y: y)!

                let movePlayerActionVertical = SKAction.move(to: usePosition, duration: (0.1 + Double(fallDistance) * 0.05))
                let playSound = SKAction.run {self.hitSound.play()}
                //hitSound.play()
                player.run(.sequence([delay, movePlayerActionVertical, playSound, playerbounce, playerbounce.reversed(), .run({self.playerMoveEnded()}), .setTexture(SKTexture(imageNamed:"p1_stand"))]), withKey: "falling")
                
            }
        }
        else
        {
            if (player.action(forKey: "falling") == nil)
            {
                let usePosition = findPositionofMapLocation(x: playerPosition.x, y: playerPosition.y)!
                let movePlayerActionVertical = SKAction.move(to: usePosition, duration: 0.15)                //player.run(animate, withKey: "walking")
                animatePlayer()
                player.run(.sequence([delay, movePlayerActionVertical, .run({self.playerMoveEnded()}), .setTexture(SKTexture(imageNamed:"p1_stand"))]), withKey: "moving")
            }
        }
        
    }
    
    func findPositionofMapLocation(x: Int, y: Int) -> CGPoint? //(x: CGFloat, y: CGFloat)?
    {
        
        if distanceFromCenter(x: Int(x), y: Int(y)) > displaytileWidth / 2 || y > displaytileHeight || y < 0
        {
            print("tile won't be displayed")
            return nil
        }
        
        var adjustedDisplayX = x - mapCenteredLocX
        
        var displayMin = mapCenteredLocX - displaytileWidth / 2
        var displayMax = mapCenteredLocX + displaytileWidth / 2
        
        if displayMin < 0
        {
            displayMin += planetCircumferance + 1
        }
        
        if displayMax > planetCircumferance
        {
            displayMax -= planetCircumferance + 1
        }

        if displayMax < displayMin  && abs(adjustedDisplayX) > displaytileWidth / 2
        {
             
            if adjustedDisplayX < 0
            {
                adjustedDisplayX += planetCircumferance + 1
            }
            
            if adjustedDisplayX > planetCircumferance || x > displayMin
            {
                adjustedDisplayX -= planetCircumferance + 1
            }
        }
        
        let tile = SKSpriteNode(imageNamed:"dirt_grass")
        tile.setScale(tileScale)
        
         //yPos +=  (mapCenteredLocY - 3) * Int(tile.size.height)
        let adjustYForCenter = y - (mapCenteredLocY - 3) * Int(tile.size.height)
       // print("y: ", y, ", adjustedY: ", adjustYForCenter)
        
        let yAdjust = -((abs(adjustedDisplayX) * 2) + ((adjustedDisplayX * adjustedDisplayX) / 4))
        let xPos = CGFloat(adjustedDisplayX) * (tile.size.width)
        
        let yPos = (CGFloat(yAdjust) - (tile.size.height) * CGFloat(y + 1))
    
        return CGPoint(x: xPos, y: yPos - CGFloat(adjustYForCenter))
        
    }
    
    
    func mapLocationPressed(x: CGFloat, y: CGFloat) -> (mapLocationX: Int,mapLocationY: Int)
    {
        let tile = SKSpriteNode(imageNamed:"dirt_grass")
        tile.setScale(tileScale)
        
        var xAdjustment = -(x / tile.size.width)
       // print("unrounded xAdjustment: ", xAdjustment)
        
        if xAdjustment < 0
        {
            xAdjustment -= 0.5
        }
        else
        {
            xAdjustment += 0.5
        }
        
        var useX = ( Int(mapCenteredLocX - Int(xAdjustment)))
        
        //print("useX before adjustments: ", useX)
        
        while useX >= planetCircumferance
        {
           // print("subtracted from useX")
            useX -= (planetCircumferance + 1)
        }

        while useX < 0
        {
            //print("added to useX")
            useX += planetCircumferance + 1
            
        }

        let adjustedi = xAdjustment
       
        let doubleX = CGFloat(abs(Double(adjustedi)) * 2.0) + (adjustedi*adjustedi) / 4.0
       
        let tileHeight = tile.size.height
        
        let adjustYForCenter = (CGFloat(mapCenteredLocY - 3) * tile.size.height)
        
        let adjustedY = y + doubleX + tileHeight - adjustYForCenter
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
        
       // print("location returned X: ", useX, ", ", Int(actualY) + 1)
        
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
        if  recentered && counter >= 30
            //  recentered && counter >= 1000 // && (player.action(forKey: "falling") == nil) && (player.action(forKey: "moving") == nil) && !falling && counter >= 1000
         {
            print("centering in update")
            counter = 28

            if mapCenteredLocX == Int(playerPosition.x)
            {
                recentered = false
            }
            let moveBy = playerDistanceFromCenter.signum()
           // print("adjusting by: ",distanceFromCenter(x: Int(playerPosition.x), y: Int(playerPosition.y)).signum())
            moveDisplay(by: moveBy)

        }
        
        if (player.action(forKey: "falling") == nil)
        {
            falling = false
        }
        
        if abs(Int(playerPosition.y) - mapCenteredLocY) > 1 && (player.action(forKey: "falling") == nil) && (player.action(forKey: "moving") == nil) && !falling
        {
            print("moving here in update")
            
            //MARK: attempt to fix this so it can go back to start level.  Perhaps center on player location?
            
            let moveBy = (Int(playerPosition.y) - mapCenteredLocY).signum()
            mapCenteredLocY += moveBy
            drawPlanetCenteredAt(x: mapCenteredLocX, y: mapCenteredLocY)
            placePlayer()


        }
        
        if canJump.contains(planetMap[playerPosition.x][playerPosition.y + 1]) && (player.action(forKey: "falling") == nil) && (player.action(forKey: "moving") == nil)
        {
            print("falling in update")
            counter = 0
            falling = true
            moveDown()
        }
    }
}

