//
//  ContentView.swift
//  Boxing Timer Mix Sound
//
//  Created by Len Lin on 2022/8/20.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @EnvironmentObject var timerManager: TimerManager
    
    var body: some View {
        ZStack(){
            Color.black.ignoresSafeArea()
            ControlView()
        }
        .onAppear { UIApplication.shared.isIdleTimerDisabled = timerManager.isTiming }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(TimerManager())
    }
}

