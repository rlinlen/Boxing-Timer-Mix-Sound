//
//  Boxing_Timer_Mix_SoundApp.swift
//  Boxing Timer Mix Sound
//
//  Created by Len Lin on 2022/8/20.
//

import SwiftUI
//import AppTrackingTransparency
//import GoogleMobileAds

@main
struct Boxing_Timer_Mix_SoundApp: App {
    @StateObject var timerManager: TimerManager = TimerManager()
    
    //Use init() in place of ApplicationDidFinishLaunchWithOptions in App Delegate
//    init() {
//        ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
//            // Tracking authorization completed. Start loading ads here.
//            // loadAd()
//            GADMobileAds.sharedInstance().start(completionHandler: nil)
//          })
//    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(timerManager)
        }
    }
}

//TODO: customzed ending sound behaviour
//TODO: add more music
