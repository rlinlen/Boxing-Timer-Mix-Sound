//
//  Boxing_Timer_Mix_SoundApp.swift
//  Boxing Timer Mix Sound
//
//  Created by Len Lin on 2022/8/20.
//

import SwiftUI

@main
struct Boxing_Timer_Mix_SoundApp: App {
    @StateObject var timerManager: TimerManager = TimerManager()
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(timerManager)
        }
    }
}

//TODO: save settings
//TODO: customzed ending sound behaviour
//TODO: add more music
