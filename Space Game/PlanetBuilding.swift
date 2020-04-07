//
//  PlanetBuilding.swift
//  Space Game
//
//  Created by Don Espe on 4/6/20.
//  Copyright © 2020 Ducky Planet LLC. All rights reserved.
//

import Foundation

let canJump = [Character(" "), "r", "p", "^", "B"]
let blocked = [Character("d")]
let cantFallThrough = [Character("."), "d", "S", "X"]

struct PlanetBuilding
    
{
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
    
    func buildPlanetMap(planetCircumferance: Int)
    {
        // playerPosition = CGPoint(x: planetCircumferance / 2, y: 2)
        print("building map")
        mapCenteredLocX = Int(playerPosition.x) // planetCircumferance / 2
        for i in 0...planetCircumferance
        {
            for j in 0...15
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
                
                if j >= 10
                {
                    planetMap[i][j] = "d"
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
                
                if i == 0 && j == 3
                {
                    planetMap[i][j] = "d"
                    
                }
            }
        }
    }
}

