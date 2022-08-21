//
//  ControlView.swift
//  Boxing Timer Mix Sound
//
//  Created by Len Lin on 2022/8/20.
//

import SwiftUI
import Foundation
import AVFoundation
import Combine

struct ControlView: View {
//    @StateObject var timerManager: TimerManager = TimerManager()
    @EnvironmentObject var timerManager: TimerManager
    
    var body: some View {
        VStack {
            ClockDisplayView()
                .environmentObject(timerManager)
            
            Spacer()
            
            PlayBarView()
            
            Spacer()
            
            SettingView()
            
        }
        .onAppear() {
            self.timerManager.stopTimer()
        }
    }
}

struct ClockDisplayView: View{
//    @State var timeRemaining: Int
//    @Binding var timer: Timer.TimerPublisher
//    @Binding var timer: Publishers.Autoconnect<Timer.TimerPublisher>
    @EnvironmentObject var timerManager: TimerManager
//    @Binding var updateDummy: Int
    
//    @State var timerText = "00:00"
//    @State var timerIntervalText = "00:00"
//    @State var timerText = getTimerText(by: timerManager.timeRemaining)
    
    
    
    init(){
        //TODO: update the timerText immediately after the timeRemaining changed
//        self.timerText = getTimerText(by: timerManager.timeRemaining)
    }
//
    var body: some View {
        VStack{
            Text("Current Ruond: \(self.timerManager.repeatRound - self.timerManager.repeatRoundRemaining + 1), Round Remaining: \(self.timerManager.repeatRoundRemaining - 1 )")
                .foregroundColor(.white)
            Text("Wait Remaing: \(formatSecondsToMinSec(by: self.timerManager.waitTimeRemaining))")
                .onReceive(self.timerManager.currentTimePublisher) { _ in
                    if (self.timerManager.currentTimerStage == TimerManager.timerStage.Wait){
                        if self.timerManager.waitTimeRemaining > 0 {
                            self.timerManager.waitTimeRemaining -= 1
                        }
                        if self.timerManager.waitTimeRemaining == 0 {
                            self.timerManager.timesUp(TimerManager.timerStage.Wait)
                        }
                    }
                    else if (self.timerManager.currentTimerStage == TimerManager.timerStage.Round){
                        if self.timerManager.roundTimeRemaining > 0 {
                            self.timerManager.roundTimeRemaining -= 1
                        }
                        if self.timerManager.roundTimeRemaining == 0 {
                            self.timerManager.timesUp(TimerManager.timerStage.Round)
                        }
                    }else if (self.timerManager.currentTimerStage == TimerManager.timerStage.Interval){
                        if self.timerManager.intervalTimeRemaining > 0 {
                            self.timerManager.intervalTimeRemaining -= 1
                        }
                        if self.timerManager.intervalTimeRemaining == 0 {
                            self.timerManager.timesUp(TimerManager.timerStage.Interval)
                        }
                    }
                }
                .foregroundColor(.white)
            
            Text("Round Remaing: \(formatSecondsToMinSec(by: self.timerManager.roundTimeRemaining))")
                .onReceive(self.timerManager.currentTimePublisher) { _ in
//                    if (self.timerManager.currentTimerStage == TimerManager.timerStage.Round){
//                        if self.timerManager.roundTimeRemaining > 0 {
//                            self.timerManager.roundTimeRemaining -= 1
//                        }
//                        if self.timerManager.roundTimeRemaining == 0 {
//                            self.timerManager.timesUp(TimerManager.timerStage.Round)
//                        }
//                    }
                }
                .foregroundColor(.white)
            
            Text("Interval Remaing: \(formatSecondsToMinSec(by: self.timerManager.intervalTimeRemaining))")
                .onReceive(self.timerManager.currentTimePublisher) { _ in
//                    if (self.timerManager.currentTimerStage == TimerManager.timerStage.Interval){
//                        if self.timerManager.intervalTimeRemaining > 0 {
//                            self.timerManager.intervalTimeRemaining -= 1
//                        }
//                        if self.timerManager.intervalTimeRemaining == 0 {
//                            self.timerManager.timesUp(TimerManager.timerStage.Interval)
//                        }
//                    }
                }
                .foregroundColor(.white)
        }.onAppear {
            
        }

        
    }
    
    
    func formatSecondsToMinSec(by timeRemaining: Int) -> String {
        let timeRemainingInMin = timeRemaining / 60
        let timeRemainingInSec = timeRemaining % 60
        let timerText: String = String(format: "%02d:%02d", timeRemainingInMin, timeRemainingInSec)
        return timerText
    }
}

struct PlayBarView: View {
    @EnvironmentObject var timerManager: TimerManager
    
    var body: some View{
        VStack{
            ControlBarView()
            SoundAdhocView(volume: $timerManager.soundManager.volume)
        }
    }
}

struct SoundAdhocView: View {
    @Binding var volume: Float
    
    var body: some View{
        HStack{
            Text("Sound Volume: ")
                .foregroundColor(.white)
            Slider(
                value: $volume,
                in: 0...5
            )
            Text("\(volume)")
                .foregroundColor(.white)
        }
        
    }
}

struct ControlBarView: View {
    @EnvironmentObject var timerManager: TimerManager
    
    var body: some View {
        HStack {
            ControlButton(systemIconName: "stop.circle", action: {
                print("Stop Button Pressed")
//                self.soundManager.playSound(name: "service-bell-ring-14610")
                self.timerManager.stopTimer()
            })
            ControlButton(systemIconName: "play.circle", action: {
                print("Start Button Pressed")
//                self.soundManager.playSound(name: "service-bell-ring-14610")
                self.timerManager.startTimer()
            })
            ControlButton(systemIconName: "pause.circle", action: {
                print("Pause Button Pressed")
//                self.soundManager.playSound(name: "service-bell-ring-14610")
                self.timerManager.pauseTimer()
            })
        }.onAppear {
        }
        
    }
}

struct ControlButton: View{
    let systemIconName: String
    let action: () -> Void
    
    var body: some View{
        Button(action:
            self.action
        ){
            Image(systemName: systemIconName)
                .font(.system(size: 35))
                .foregroundColor(.white)
                .buttonStyle(PlainButtonStyle())
        }
        .frame(width: 50, height: 50)
    }
}


struct SettingView: View{
    var body: some View{
        VStack{
            Text("Settings:").foregroundColor(.white)
            SettingsGrid()
        }
    }
}

struct SettingsGrid: View{
    @EnvironmentObject var timerManager: TimerManager
    
    @State var roundNumberIndex: Int = 0
    
    private var gridItemLayout = [GridItem(.adaptive(minimum: 150, maximum: 300), spacing: 25)]
    
    var body: some View{
        LazyVGrid(columns: gridItemLayout, spacing: 25){
//            SettingItem(repeatRound: $timerManager.repeatRound, repeatRoundRemaining: $timerManager.repeatRoundRemaining)
            SettingItem(
                timerParameter: $timerManager.repeatRound,
                timerParameterRemaining: $timerManager.repeatRoundRemaining,
                label: "Round Number: ")
            SettingItem(
                timerParameter: $timerManager.waitTime,
                timerParameterRemaining: $timerManager.waitTimeRemaining,
                label: "Wait Time: ")
            SettingItem(
                timerParameter: $timerManager.roundTime,
                timerParameterRemaining: $timerManager.roundTimeRemaining,
                label: "Round Time: ")
            SettingItem(
                timerParameter: $timerManager.intervalTime,
                timerParameterRemaining: $timerManager.intervalTimeRemaining,
                label: "Interval Time: ")
            SettingTimerItem(
                timerParameter: $timerManager.soundManager.numberOfLoops,
                label: "Sound Loop Number: ")
        }
        
    }
}

struct SettingItem: View {
    @Binding var timerParameter: Int
    @Binding var timerParameterRemaining: Int
    @State var label: String
//    @State var items: View
    //TODO: generelaize this
    
    var body: some View{
        HStack{
            Text(label).foregroundColor(.white)
            Picker(label, selection: $timerParameter){
                ForEach(0..<30) { round in
                    Text(String(round))
                }
            }.onChange(of: timerParameter) { value in
                print(value)
//                timerManager.repeatRound = Int(value)
                timerParameterRemaining = Int(value)
            }
//            .pickerStyle(MenuPickerStyle())
        }
//        .onAppear(){
//            roundNumberIndex = timerManager.repeatRound
//        }
    }
}

struct SettingTimerItem: View {
    @Binding var timerParameter: Int
    @State var label: String
//    @State var items: View
    //TODO: generelaize this
    
    var body: some View{
        HStack{
            Text(label).foregroundColor(.white)
            Picker(label, selection: $timerParameter){
                ForEach(0..<30) { round in
                    Text(String(round))
                }
            }.onChange(of: timerParameter) { value in
                print(value)
            }
        }
    }
}

class TimerManager: ObservableObject {
    @Published var currentTimePublisher = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @Published var roundTime: Int = 5
    @Published var intervalTime: Int = 3
    @Published var waitTime: Int = 2
    @Published var repeatRound: Int = 1
    
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
    }
    
    func pauseTimer(){
//        self.cancellable?.cancel()
//        self.cancellable = nil
        self.currentTimePublisher.upstream.connect().cancel()
    }
    
    func stopTimer(){
//        print(timeRemaining)
        self.currentTimePublisher.upstream.connect().cancel()
        self.roundTimeRemaining = self.roundTime
        self.intervalTimeRemaining = self.intervalTime
        self.repeatRoundRemaining = self.repeatRound
        self.waitTimeRemaining = self.waitTime
        self.currentTimerStage = timerStage.Wait
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
                self.repeatRoundRemaining -= 1
                
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

class SoundManager: ObservableObject {
    var audioPlayer: AVAudioPlayer? = nil
    var audioSession: AVAudioSession
    var volume: Float = 1
    var numberOfLoops: Int = 1
    
    init(){
        audioSession = AVAudioSession.sharedInstance()
        do {
            // Set the audio session category, mode, and options.
            try audioSession.setCategory(.playback, mode: .default, options: [.mixWithOthers, .duckOthers])
        } catch {
            print("Failed to set audio session category.")
        }
    }
    
    
    func playSound(name: String = "service-bell-ring", type: String = "m4a"){
//        let path = Bundle.main.path(forResource: name, ofType: nil)
//        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else { return }
        guard let url = Bundle.main.url(forResource: name, withExtension: type) else { return }
        
//        print("Path: \(path)")
//        let url = URL(fileURLWithPath: path!)
//        print("Play URL from name: \(name)")
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.volume = self.volume
            audioPlayer?.numberOfLoops = self.numberOfLoops
            audioPlayer?.play()
            print("Played sound")
        } catch {
            print("Error playing \(name) sound")
        }
    }
}
