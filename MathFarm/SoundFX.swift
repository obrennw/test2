//
//  AnimalSoundFX.swift
//  MathFarm
//
//  Created by John Leland Washburn on 4/25/18.
//  Copyright © 2018 oqbrennw. All rights reserved.
//

import Foundation
import AVFoundation

///an object that consists of multiple function calls to play sounds; how to use: instantiate SoundFX object, call functions to play sound--look for examples throughout code
class SoundFX {
    /// Audio player backing SoundFX object
    private var audioPlayer : AVAudioPlayer?
    /// Location of Pig Sound
    private let pigURL = Bundle.main.url(forResource: "pigfarm", withExtension: "mp3")
    /// Location of shortened Pig Sound
    private let pigShortURL = Bundle.main.url(forResource: "pigShort", withExtension: "mp3")
    /// Location of Cow Sound
    private let cowURL = Bundle.main.url(forResource: "cowmoo", withExtension: "mp3")
    /// Location of Cat Sound
    private let catURL = Bundle.main.url(forResource: "meow", withExtension: "mp3")
    /// Location of Tada Sound
    private let tadaURL = Bundle.main.url(forResource: "tada", withExtension: "mp3")
    /// Location of Dog Sound
    private let dogURL = Bundle.main.url(forResource: "bark", withExtension: "mp3")
    /// Location of Happy "Woo Hoo!" Sound
    private let happyURL = Bundle.main.url(forResource: "happy", withExtension: "mp3")
    /// Location of dinging Count Sound
    private let countURL = Bundle.main.url(forResource: "count", withExtension: "mp3")
    /// Location of error indicating Click Sound
    private let clickURL = Bundle.main.url(forResource: "click", withExtension: "mp3")
    /// Location of short dog bark sound
    private let shortDogURL = Bundle.main.url(forResource: "dogBark", withExtension: "mp3")

    
    /// Plays sound for corresponding animal
    ///
    /// - Parameter animal: String indicating which animal sound to be played
    public func playAnimalSound(animal: String) {
        switch(animal){
        case "pig":
            playPigSound()
            break
        case "pigShort":
            playPigSoundShort()
            break
        case "cow":
            playCowSound()
            break
            
        case "dog":
            playDogSound()
            break
            
        case "shortDog":
            playShortDogSound()
            break
            
        case "cat":
            playCatSound()
            break
        default:
            //no sound
            break
        }
    }
    
    /// Tells whether audio player is currently playing an effect or not
    ///
    /// - Returns: True boolean if audio player is playing, False boolean if audio player isn't playing
    public func isPlaying() -> Bool {
        if(audioPlayer != nil){
            return (audioPlayer?.isPlaying)!
        }
        return false
    }
    
    /// Play Tada Sound
    public func playTada(){
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: tadaURL!)
            audioPlayer?.play()
            
        } catch {
            // couldn't load file :(
        }
    }
    
    /// Play Happy "Woo Hoo!" Sound
    public func playHappy(){
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: happyURL!)
            audioPlayer?.volume = 5.0
            audioPlayer?.play()
            
        } catch {
            // couldn't load file :(
        }
    }
    
    /// Play Pig Sound
    private func playPigSound(){
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: pigURL!)
            audioPlayer?.play()
            
        } catch {
            // couldn't load file :(
        }
    }
    
    /// Play Pig Sound shortened
    public func playPigSoundShort(){
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: pigShortURL!)
            audioPlayer?.volume = 3.0
            audioPlayer?.play()
            
        } catch {
            // couldn't load file :(
        }
    }
    
    /// Play Cow Sound
    public func playCowSound(){
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: cowURL!)
            audioPlayer?.play()
            
        } catch {
            // couldn't load file :(
        }
    }
    
    /// Play Dog Sound
    public func playDogSound(){
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: dogURL!)
            audioPlayer?.play()
            
        } catch {
            // couldn't load file :(
        }
    }
    
    /// Play Short Dog Sound
    public func playShortDogSound(){
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: shortDogURL!)
            audioPlayer?.volume = 5.0
            audioPlayer?.play()
            
        } catch {
            // couldn't load file :(
            print("can't play")
        }
    }

    
    /// Play Cat Sound
    public func playCatSound(){
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: catURL!)
            audioPlayer?.play()
            
        } catch {
            // couldn't load file :(
        }
    }
    
    /// Play dinging Count Sound
    public func playCountSound() {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: countURL!)
            audioPlayer?.play()
        } catch {
            
        }
    }
    
    /// Play error indicating Click Sound
    public func playClickSound(){
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: clickURL!)
            audioPlayer?.volume = 3.0
            audioPlayer?.play()
            
        } catch {
            // couldn't load file :(
        }
    }
}

