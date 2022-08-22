//
//  TimerManager.swift
//  Boxing Timer Mix Sound
//
//  Created by Len Lin on 2022/8/22.
//

import SwiftUI
import Foundation
import AVFoundation
import Combine

class TimerManager: ObservableObject {
    @Published var currentTimePublisher = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @Published var roundTime: Int = 5
    @Published var intervalTime: Int = 3
    @Published var waitTime: Int = 2
    @Published var repeatRound: Int = 1
    @Published var isTiming: Bool = true
    
    @Published var roundTimeRemaining: Int = 999
    @Published var intervalTimeRemaining: Int = 999
    @Published var waitTimeRemaining: Int = 999
    @Published var repeatRoundRemaining: Int = 999
    public enum timerStage {
        case Wait
        case Round
        case Interval
    }
    
    @Published var currentTimerStage = timerStage.Wait
//    @Published var isTimeUp = timeRemaining
    
    @Published var soundManager = SoundManager()
    
    var cancellable: Cancellable?
    
    
    
    
    init() {
//        self.cancellable = self.currentTimePublisher.connect()
//        print(self.cancellable)
    }
    deinit {
//        self.cancellable?.cancel()
    }
    
    func startTimer(){
        self.currentTimePublisher = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
//        print(self.currentTimePublisher)
//        self.cancellable = self.currentTimePublisher.connect()
        self.isTiming = true
    }
    
    func pauseTimer(){
//        self.cancellable?.cancel()
//        self.cancellable = nil
        self.currentTimePublisher.upstream.connect().cancel()
        self.soundManager.stopSound()
        self.isTiming = false
    }
    
    func manualStopTimer(){
        self.stopTimer()
        self.soundManager.stopSound()
    }
    
    func stopTimer(){
//        print(timeRemaining)
//
        self.currentTimePublisher.upstream.connect().cancel()
        self.roundTimeRemaining = self.roundTime
        self.intervalTimeRemaining = self.intervalTime
        self.repeatRoundRemaining = self.repeatRound
        self.waitTimeRemaining = self.waitTime
        self.currentTimerStage = timerStage.Wait
        self.isTiming = false
//        let secondsToDelay = 2.0
//        DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
//            self.soundManager.stopSound()
//        }
        
//        print(self.cancellable)
//        self.cancellable?.cancel()
//        self.cancellable = nil
//        print(self.cancellable)
    }
    
    func timesUp(_ stage:TimerManager.timerStage){
//        self.isTimeUp
        switch stage{
        case .Interval:
            // ends an interval
            self.repeatRoundRemaining -= 1
            self.currentTimerStage = timerStage.Round
            self.soundManager.playSound()
            self.roundTimeRemaining = self.roundTime
            
        case .Round:
            if (self.repeatRoundRemaining <= 1){
                // ends all rounds
                self.soundManager.playSound()
                self.stopTimer()
            } else if (self.repeatRoundRemaining > 1){
                // ends a usual round
                self.currentTimerStage = timerStage.Interval
                self.soundManager.playSound()
    //            self.stopTimer()
//                self.repeatRoundRemaining -= 1
                
                self.intervalTimeRemaining = self.intervalTime
            }
        case .Wait:
            // ends a wait
            self.currentTimerStage = timerStage.Round
            self.soundManager.playSound()
        }
        
    }
    
//    self.soundManager.playSound(name: "service-bell-ring-14610")
}

struct SoundTrack {
    var id: String
    var displayName: String
    var fileName: String
}

class SoundManager: ObservableObject {
    var audioPlayer: AVAudioPlayer? = nil
    var audioSession: AVAudioSession
    var volume: Float = 1
    var numberOfLoops: Int = 0
    
    @Published var soundTrackType: String = "Default Ring 1"
    @Published var soundTrackFullURL: URL
    
    var soundTrackMenu = [
        SoundTrack(id: "defaulebell1", displayName: "Default Bell 1", fileName: "bell_ring_b.m4a"),
        SoundTrack(id: "defaulebell2", displayName: "Default Bell 2", fileName: "service-bell-ring.m4a"),
        SoundTrack(id: "customized", displayName: "Customized", fileName: "")
    ]
//    private var _soundTrackFull: URL? = nil
//    private var _soundTrackExtension: String = ""
//    private var _soundTrackFullNoExtension: URL? = nil
//    private var _soundTrackLastNoExtension: String = ""
//
//    var soundTrackFullURL: URL? {
//        get {
//            return _soundTrackFull;
//        }
//        set {
////            self._soundTrackFull = newValue
////            self._soundTrackExtension = newValue.pathExtension
////            self._soundTrackFullNoExtension = newValue.deletingPathExtension()
////            self._soundTrackLastNoExtension = newValue.deletingPathExtension().lastPathComponent
//        }
//    }
    
    init(){
        func getSoundTrackURL(name: String = "bell_ring_b", type: String = "m4a") -> URL?{
            guard let url = Bundle.main.url(forResource: name, withExtension: type) else { return nil }
            return url
        }
        
        soundTrackFullURL = getSoundTrackURL()!
        audioSession = AVAudioSession.sharedInstance()
        do {
            // Set the audio session category, mode, and options.
            try audioSession.setCategory(.playback, mode: .default, options: [.mixWithOthers, .duckOthers])
        } catch {
            print("Failed to set audio session category.")
        }
    }
    
    func getSoundTrackURL(by fullname: NSString) -> URL?{
        let name = fullname.deletingPathExtension
        let type = fullname.pathExtension
        guard let url = Bundle.main.url(forResource: name, withExtension: type) else { return nil }
        return url
    }
    
    func playSound(url: URL? = nil){
//        let path = Bundle.main.path(forResource: name, ofType: nil)
//        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else { return }
        var newUrl = url
        
        if (newUrl == nil){
            newUrl = self.soundTrackFullURL
        }
//        print("Path: \(path)")
//        let url = URL(fileURLWithPath: path!)
//        print("Play URL from name: \(name)")
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: newUrl!)
            audioPlayer?.stop()
            audioPlayer?.volume = self.volume
            audioPlayer?.numberOfLoops = self.numberOfLoops
            audioPlayer?.play()
            print("Played sound")
        } catch {
            print("Error playing \(newUrl) sound")
        }
    }
    
    func stopSound(){
//        print(audioPlayer?.isPlaying)
//        if ((audioPlayer?.isPlaying) == true){
            audioPlayer?.stop()
//        }
        
    }
}
