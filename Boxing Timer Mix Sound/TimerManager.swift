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
    @Published var roundTime: Int = (UserDefaults.standard.object(forKey: "roundTime") as? Int ?? K.Timer.roundTime) {
        didSet {
            UserDefaults.standard.set(self.roundTime, forKey: "roundTime")
        }
    }
    @Published var intervalTime: Int = (UserDefaults.standard.object(forKey: "intervalTime") as? Int ?? K.Timer.intervalTime) {
        didSet {
            UserDefaults.standard.set(self.intervalTime, forKey: "intervalTime")
        }
    }
    @Published var waitTime: Int = (UserDefaults.standard.object(forKey: "waitTime") as? Int ?? K.Timer.waitTime) {
        didSet {
            UserDefaults.standard.set(self.waitTime, forKey: "waitTime")
        }
    }
    @Published var repeatRound: Int = (UserDefaults.standard.object(forKey: "repeatRound") as? Int ?? K.Timer.repeatRound) {
        didSet {
            UserDefaults.standard.set(self.repeatRound, forKey: "repeatRound")
        }
    }
    @Published var isTiming: Bool = true {
        didSet {
            UIApplication.shared.isIdleTimerDisabled = self.isTiming
        }
    }
    
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
    
    
    func startTimer(){
        self.currentTimePublisher = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
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
        self.currentTimePublisher.upstream.connect().cancel()
        self.roundTimeRemaining = self.roundTime
        self.intervalTimeRemaining = self.intervalTime
        self.repeatRoundRemaining = self.repeatRound
        self.waitTimeRemaining = self.waitTime
        self.currentTimerStage = timerStage.Wait
        self.isTiming = false
    }
    
    func timesUp(_ stage:TimerManager.timerStage){
//        self.isTimeUp
        switch stage{
        case .Interval:
            // ends an interval
            self.repeatRoundRemaining -= 1
            self.currentTimerStage = timerStage.Round
            self.soundManager.playSound(currentSoundTrackId: self.soundManager.currentSoundTrackStartId, customizedBookMark: self.soundManager.soundTrackCustomizedStartBookMark)
            self.roundTimeRemaining = self.roundTime
            
        case .Round:
            if (self.repeatRoundRemaining <= 1){
                // ends all rounds
                do{
                    if (self.soundManager.isStopBackgroundPlayer){
//                        print("setup stop backgroundplayer")
                        try self.soundManager.audioSession.setCategory(.soloAmbient, mode: .default, options: [])
//                        try self.soundManager.audioSession.setActive(true)
                    }
                    self.soundManager.playSound(currentSoundTrackId: self.soundManager.currentSoundTrackAllEndId, customizedBookMark: self.soundManager.soundTrackCustomizedAllEndBookMark)
                    
                    if (self.soundManager.isStopBackgroundPlayer){
//                        print("restore stop backgroundplayer behaviour")
                        try self.soundManager.audioSession.setCategory(.playback, mode: .default, options: [.mixWithOthers, .duckOthers])
//                        try self.soundManager.audioSession.setActive(false)
                    }
                    self.stopTimer()
                    
                }catch{
                    print(error)
                }
                
            } else if (self.repeatRoundRemaining > 1){
                // ends a usual round
                self.currentTimerStage = timerStage.Interval
                self.soundManager.playSound(currentSoundTrackId: self.soundManager.currentSoundTrackEndId, customizedBookMark: self.soundManager.soundTrackCustomizedEndBookMark)
    //            self.stopTimer()
//                self.repeatRoundRemaining -= 1
                
                self.intervalTimeRemaining = self.intervalTime
            }
        case .Wait:
            // ends a wait
            self.currentTimerStage = timerStage.Round
            self.soundManager.playSound(currentSoundTrackId: self.soundManager.currentSoundTrackStartId, customizedBookMark: self.soundManager.soundTrackCustomizedStartBookMark)
        }
        
    }
    
//    self.soundManager.playSound(name: "service-bell-ring-14610")
}

struct SoundTrack: Codable {
    var id: String
    var displayName: String
    var fileName: String
    var url: URL?
//    var bookMark: Data?
}

class SoundManager: ObservableObject {
    var audioPlayer: AVAudioPlayer? = nil
    var audioSession: AVAudioSession
    var volume: Float = (UserDefaults.standard.object(forKey: "volume") as? Float ?? K.Sound.volume) {
        didSet {
            UserDefaults.standard.set(self.volume, forKey: "volume")
        }
    }
    var numberOfLoops: Int = (UserDefaults.standard.object(forKey: "numberOfLoops") as? Int ?? K.Sound.numberOfLoops) {
        didSet {
            UserDefaults.standard.set(self.numberOfLoops, forKey: "numberOfLoops")
        }
    }
    
    @Published var currentSoundTrackStartId: String = (UserDefaults.standard.object(forKey: "currentSoundTrackStartId") as? String ?? K.Sound.currentSoundTrackStartId) {
        didSet {
            UserDefaults.standard.set(self.currentSoundTrackStartId, forKey: "currentSoundTrackStartId")
        }
    }
    @Published var currentSoundTrackEndId: String = (UserDefaults.standard.object(forKey: "currentSoundTrackEndId") as? String ?? K.Sound.currentSoundTrackEndId) {
        didSet {
            UserDefaults.standard.set(self.currentSoundTrackEndId, forKey: "currentSoundTrackEndId")
        }
    }
    @Published var currentSoundTrackAllEndId: String = (UserDefaults.standard.object(forKey: "currentSoundTrackAllEndId") as? String ?? K.Sound.currentSoundTrackAllEndId) {
        didSet {
            UserDefaults.standard.set(self.currentSoundTrackAllEndId, forKey: "currentSoundTrackAllEndId")
        }
    }
    @Published var isStopBackgroundPlayer: Bool = (UserDefaults.standard.object(forKey: "isStopBackgroundPlayer") as? Bool ?? K.Sound.isStopBackgroundPlayer) {
        didSet {
            UserDefaults.standard.set(self.isStopBackgroundPlayer, forKey: "isStopBackgroundPlayer")
        }
    }
    
    
    subscript(_ member: String) -> Any? {
        get {
            switch member {
            case "currentSoundTrackStartId":
                return soundTrackCustomizedStartBookMark
            case "currentSoundTrackEndId":
                return soundTrackCustomizedEndBookMark
            case "currentSoundTrackAllEndId":
                return soundTrackCustomizedAllEndBookMark
            default:
                return nil
            }
        }
        set {
            switch member {
            case "currentSoundTrackStartId":
                soundTrackCustomizedStartBookMark = newValue as? Data
            case "currentSoundTrackEndId":
                soundTrackCustomizedEndBookMark  = newValue as? Data
            case "currentSoundTrackAllEndId":
                soundTrackCustomizedAllEndBookMark  = newValue as? Data
            default:
                break
            }
        }
            
        }
    
    @Published var soundTrackCustomizedStartBookMark: Data? =  (UserDefaults.standard.object(forKey: "soundTrackCustomizedStartBookMark") as? Data? ?? nil) {
        didSet {
            UserDefaults.standard.set(self.soundTrackCustomizedStartBookMark, forKey: "soundTrackCustomizedStartBookMark")
        }
    }
    @Published var soundTrackCustomizedEndBookMark: Data? =  (UserDefaults.standard.object(forKey: "soundTrackCustomizedEndBookMark") as? Data? ?? nil) {
        didSet {
            UserDefaults.standard.set(self.soundTrackCustomizedEndBookMark, forKey: "soundTrackCustomizedEndBookMark")
        }
    }
    @Published var soundTrackCustomizedAllEndBookMark: Data? =  (UserDefaults.standard.object(forKey: "soundTrackCustomizedAllEndBookMark") as? Data? ?? nil) {
        didSet {
            UserDefaults.standard.set(self.soundTrackCustomizedAllEndBookMark, forKey: "soundTrackCustomizedAllEndBookMark")
        }
    }
        
    @Published var soundTrackMenu: [SoundTrack]
    {
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(self.soundTrackMenu) {
//                print("Saving soundTrackMenu: \(encoded)")
                UserDefaults.standard.set(encoded, forKey: "soundTrackMenu")
            }
        }
    }
    
    init(){
        func getSoundTrackURL(by fullname: NSString) -> URL?{
            let name = fullname.deletingPathExtension
            let type = fullname.pathExtension
            guard let url = Bundle.main.url(forResource: name, withExtension: type) else { return nil }
            return url
        }
        func getURLfromCache(by key: String) -> URL? {
            return UserDefaults.standard.url(forKey: key)
        }
        
//        soundTrackFullURL = getSoundTrackURL()!
        audioSession = AVAudioSession.sharedInstance()
        do {
            // Set the audio session category, mode, and options.
            try audioSession.setCategory(.playback, mode: .default, options: [.mixWithOthers, .duckOthers])
//            try audioSession.setCategory(.soloAmbient, mode: .default, options: [])
//            try audioSession.setActive(true)
        } catch {
            print("Failed to set audio session category.")
        }
        
        soundTrackMenu = K.Sound.soundTrackMenu
        if let data = UserDefaults.standard.object(forKey: "soundTrackMenu") as? Data {
            let decoder = JSONDecoder()
            if let savedData = try? decoder.decode([SoundTrack].self, from: data) {
                soundTrackMenu = savedData
            }
        }
    }
    
    static func getSoundTrackURL(by filename: NSString) -> URL?{
        let name = filename.deletingPathExtension
        let type = filename.pathExtension
        guard let url = Bundle.main.url(forResource: name, withExtension: type) else { return nil }
        return url
    }
    func getSoundTrackURL(from id: String) -> URL?{
        for soundTrack in soundTrackMenu {
            if (id == soundTrack.id){
                return soundTrack.url
            }
        }
        return soundTrackMenu[0].url
    }
    
    func playSound(currentSoundTrackId: String, customizedBookMark: Data? = nil){
        var newUrl: URL?
        var isSecuredURL = false
        
        if (newUrl == nil){
            newUrl = self.getSoundTrackURL(from: currentSoundTrackId)
        }
        
        
        
        do {
//            print("init playing: \(newUrl) with \(self.currentSoundTrackStartId)")
            if (currentSoundTrackId == K.Sound.customizedSoundTrackId){
//                print("init bookmark")
                print("soundTrackCustomizedBookMark:\(customizedBookMark)")
//                var bookmarkData = self.soundTrackMenu[2].bookMark as! Data
//                print("bookmarkData: \(bookmarkData)")
                var bookmarkDataIsStale: Bool = false
                newUrl = try URL.init(resolvingBookmarkData: customizedBookMark!, options: [.withoutUI], relativeTo: nil, bookmarkDataIsStale: &bookmarkDataIsStale)
                print("updated newUrl:\(newUrl)")
                isSecuredURL = newUrl!.startAccessingSecurityScopedResource()
//                print("isSecuredURL: \(isSecuredURL)")
//                newUrl?.bookmarkData()
//                isSecuredURL = newUrl!.startAccessingSecurityScopedResource() == true
//                print("grant result: \(isSecuredURL)")
            }
            defer {
                if(currentSoundTrackId == K.Sound.customizedSoundTrackId && isSecuredURL){
                    newUrl!.stopAccessingSecurityScopedResource()

                }
            }
            let isReachable = try newUrl!.checkResourceIsReachable()
            
            audioPlayer = try AVAudioPlayer(contentsOf: newUrl!)
            audioPlayer?.stop()
            audioPlayer?.volume = self.volume
            audioPlayer?.numberOfLoops = self.numberOfLoops
            audioPlayer?.play()
            print("Played sound")
        } catch {
            print(error.localizedDescription)
            print("Error playing \(newUrl)")
        }
        
        
    }
    
    func stopSound(){
//        print(audioPlayer?.isPlaying)
//        if ((audioPlayer?.isPlaying) == true){
            audioPlayer?.stop()
//        }
        
    }
}
