//
//  Boxing_Timer_Mix_SoundApp.swift
//  Boxing Timer Mix Sound
//
//  Created by Len Lin on 2022/8/20.
//

import SwiftUI
import AppTrackingTransparency
import GoogleMobileAds
import AdSupport

@main
struct Boxing_Timer_Mix_SoundApp: App {
    @StateObject var timerManager: TimerManager = TimerManager()
    
    //Use init() in place of ApplicationDidFinishLaunchWithOptions in App Delegate
    init() {
        
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(timerManager)
        }
    }
    
}

//TODO: Add background play
//TODO: Fix Rotate auto play bug
//TODO: add more music
