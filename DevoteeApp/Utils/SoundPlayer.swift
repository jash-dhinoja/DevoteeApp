//
//  SoundPlayer.swift
//  DevoteeApp
//
//  Created by Jash Dhinoja on 19/03/2023.
//

import AVFoundation
import Foundation

var audioPlayer: AVAudioPlayer?

func playSound(sound: String, type: String){
    if let path = Bundle.main.path(forResource: sound, ofType: type){
        do{
            audioPlayer = try? AVAudioPlayer(contentsOf: URL(filePath: path))
            audioPlayer?.play()
        }catch{
            fatalError("Could not find sound file")
        }
    }
}
