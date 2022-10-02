//
//  SoundManager.swift
//  Match App
//
//  Created by 10683973 on 07/06/22.
//

import Foundation
import AVFoundation

class SoundManager{
    var audioPlayer:AVAudioPlayer?
    
    enum SoundEffect {
        case flip
        case shuffle
        case match
        case nomatch
    }
    func playSound(_ effect:SoundEffect){
        
        var soundFilename=""
        switch effect {
        case .flip:
            soundFilename="cardflip"
        case .shuffle:
            soundFilename="shuffle"
        case .match:
            soundFilename="dingcorrect"
        case .nomatch:
            soundFilename="dingwrong"
            
        default:
            soundFilename=""
        }
        let bundlePath=Bundle.main.path(forResource: soundFilename, ofType: "wav")
        guard bundlePath != nil else {
            print("Couldn't find the sound file \(soundFilename) in the bundle")
            return
        }
        
        let soundURL = URL(fileURLWithPath: bundlePath!)
        
        do{
        audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            
        audioPlayer?.play()
        }
        catch{
            print("Couldn't create audio player object for sound file \(soundFilename)")
        }
    }
}
