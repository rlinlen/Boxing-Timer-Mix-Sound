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
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    var body: some View {
        VStack {
            
            Spacer()
            
            if verticalSizeClass != .compact {
            ClockDisplayView()
                .environmentObject(timerManager)
            } else {
                ClockDisplayView()
                    .padding(.top, 50)
                    .environmentObject(timerManager)
            }
            
            
            
            
            Spacer()
            
            if verticalSizeClass != .compact {
                PlayBarView()
                
                //            Spacer()
                
                SettingView()
                    .environmentObject(timerManager)
                    .disabled(timerManager.isTiming)
            }
            
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
    @State var waitTimerOpacity = 1.0
    
    private let roundRemainingTimeFontSize : CGFloat = 140
    //    @State var timerText = "00:00"
    //    @State var timerIntervalText = "00:00"
    //    @State var timerText = getTimerText(by: timerManager.timeRemaining)
    
    private var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.fixed(30)), GridItem(.flexible()), GridItem(.flexible())]
    
    init(){
        //        self.timerText = getTimerText(by: timerManager.timeRemaining)
    }
    //
    var body: some View {
        VStack{
            HStack(alignment: .bottom){
                VStack(alignment: .leading){
                    HStack(alignment: .bottom){
                        Text("\(getCurrentRound())")//CurrentRound
                            .foregroundColor(.white)
                        //                        .padding(40)
                        //                            .background(.cyan)
                            .font(.system(size: 70))
                        //                            .bold()
                        //                        .frame(maxWidth: .infinity, alignment: .leading)
                        Text("/")//CurrentRound
                            .foregroundColor(.white)
                            .padding(.bottom, 2)
                            .font(.system(size: 30))
                        Text(" \(self.timerManager.repeatRound)")//CurrentRound
                            .foregroundColor(.white)
                            .font(.system(size: 30))
                            .bold()
                        //                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    //                    .frame(width: 300, alignment: .bottom)
                    
                    Text("Round")
                        .foregroundColor(.white)
                    //                        .padding(40)
                    //                        .background(.cyan)
                        .font(.system(size: 20))
                    //                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                //                .background(.blue)
                .padding(.leading, 10)
                //                Divider().foregroundColor(.white)
                
                Spacer()
                
                VStack(alignment: .trailing){
                    Text("\(formatSecondsToMinSec(by: self.timerManager.intervalTimeRemaining))")
                        .foregroundColor(.white)
                    //                    .background(.blue)
                    //                        .padding(.leading, 50)
                    //                        .padding(.trailing, 50)
                        .font(.system(size: 60))
                    //                        .minimumScaleFactor(0.01)
                    Text("Interval Time")
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                    
                }
                //                .background(.brown)
                .padding(.trailing, 10)
            }
            
            if #available(iOS 15, *) {
                Divider()
                    .background(.white)
            } else {
                Divider()
            }
            
            //                    .frame(width: 3000)
            //            }
            LazyVGrid(columns: gridItemLayout, spacing: 0) {
                Text("\(String(formatSecondsToMinSec(by: self.timerManager.roundTimeRemaining)[0]))")
                    .foregroundColor(.white)
                //                    .frame(maxWidth: .infinity)
                //                    .background(.blue)
                    .font(.system(size: roundRemainingTimeFontSize))
                    .minimumScaleFactor(0.01)
                    .padding(.leading, 10)
                //                    .padding(.trailing, 10)
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
                Text("\(String(formatSecondsToMinSec(by: self.timerManager.roundTimeRemaining)[1]))")
                    .foregroundColor(.white)
                //                    .frame(maxWidth: .infinity)
                //                    .background(.blue)
                    .font(.system(size: roundRemainingTimeFontSize))
                    .minimumScaleFactor(0.01)
                Text("\(String(formatSecondsToMinSec(by: self.timerManager.roundTimeRemaining)[2]))")
                    .foregroundColor(.white)
                //                    .frame(maxWidth: .infinity)
                //                    .background(.blue)
                    .font(.system(size: roundRemainingTimeFontSize))
                    .minimumScaleFactor(0.01)
                Text("\(String(formatSecondsToMinSec(by: self.timerManager.roundTimeRemaining)[3]))")
                    .foregroundColor(.white)
                //                    .frame(maxWidth: .infinity)
                //                    .background(.blue)
                    .font(.system(size: roundRemainingTimeFontSize))
                    .minimumScaleFactor(0.01)
                Text("\(String(formatSecondsToMinSec(by: self.timerManager.roundTimeRemaining)[4]))")
                    .foregroundColor(.white)
                //                    .frame(maxWidth: .infinity)
                //                    .background(.blue)
                    .font(.system(size: roundRemainingTimeFontSize))
                    .minimumScaleFactor(0.01)
            }.frame(maxWidth: 600)
            //            .background(Color.teal)
            
            if #available(iOS 15, *) {
                Divider()
                    .background(.white)
            } else {
                Divider()
            }
            
            
            Text("\(formatSecondsToMinSec(by: self.timerManager.waitTimeRemaining))")
                .foregroundColor(.white)
                .font(.system(size: 30))
                .opacity(self.shouldWaitDisappear(by: self.timerManager.waitTimeRemaining))
                .animation(Animation.easeInOut(duration: 0.5), value: self.shouldWaitDisappear(by: self.timerManager.waitTimeRemaining))
            Text("Warm Up")
                .foregroundColor(.white)
                .font(.system(size: 20))
                .opacity(self.shouldWaitDisappear( by: self.timerManager.waitTimeRemaining))
                .animation(Animation.easeInOut(duration: 0.5), value: self.shouldWaitDisappear(by: self.timerManager.waitTimeRemaining))
        }
    }
    
    func shouldWaitDisappear(by timeRemaining: Int) -> Double{
        if (timeRemaining == 0){
            return 0.0
        }else{
            return 1.0
        }
    }
    func getCurrentRound() -> Int {
        return self.timerManager.repeatRound - self.timerManager.repeatRoundRemaining + 1
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
                in: 0...10
            )
            Text("\(String(format: "%.1f", volume))")
                .foregroundColor(.white)
        }
        
    }
}

struct ControlBarView: View {
    @EnvironmentObject var timerManager: TimerManager
    
    var body: some View {
        HStack {
            ControlButton(systemIconName: "stop.circle", action: {
                //                print("Stop Button Pressed")
                //                self.soundManager.playSound(name: "service-bell-ring-14610")
                self.timerManager.manualStopTimer()
            })
            if (self.timerManager.isTiming){
                ControlButton(systemIconName: "pause.circle", action: {
                    //                    print("Pause Button Pressed")
                    //                self.soundManager.playSound(name: "service-bell-ring-14610")
                    self.timerManager.pauseTimer()
                })
            } else {
                ControlButton(systemIconName: "play.circle", action: {
                    //                    print("Start Button Pressed")
                    //                self.soundManager.playSound(name: "service-bell-ring-14610")
                    self.timerManager.startTimer()
                })
            }
            
            
        }
        .padding(20)
        .onAppear {
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
                .font(.system(size: 70))
                .foregroundColor(.white)
                .buttonStyle(PlainButtonStyle())
        }
        //        .frame(width: 50, height: 50)
    }
}



