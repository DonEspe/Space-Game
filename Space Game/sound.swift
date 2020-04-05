//
//  sound.swift
//  Text Maze 2
//
//  Created by Don Espe on 4/11/16.
//  Copyright © 2016 Don Espe. All rights reserved.
//

import Foundation

import AVFoundation
import UIKit

class Sound {
    
    var soundEffect: SystemSoundID = 0
    init(name: String, type: String)
    {
        let path  = Bundle.main.path(forResource: name, ofType: type)!
        let pathURL = URL(fileURLWithPath: path)
        AudioServicesCreateSystemSoundID(pathURL as CFURL, &soundEffect)
    }
    
    func play() {
        AudioServicesPlaySystemSound(soundEffect)
    }
    
    
    
    
    func playSound(_ soundName: String)
    {
        let coinSound = URL(fileURLWithPath: Bundle.main.path(forResource: soundName, ofType: "aif")!)
        do{
            let audioPlayer = try AVAudioPlayer(contentsOf:coinSound)
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        }catch {
            print("Error getting the audio file")
        }
    }
    
    
}
//Usage:

//testSound = Sound(name: "Door", type: "aif")
//testSound.play()
