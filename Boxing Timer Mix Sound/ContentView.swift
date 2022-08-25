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
            
            
            
//            SwiftUIBannerAd(adPosition: .top, adUnitId: K.Ad.bannerId)
            
            
            Color.black.ignoresSafeArea()
            ControlView()
            
        }
//        .onAppear { UIApplication.shared.isIdleTimerDisabled = timerManager.isTiming }
        
        BannerVC(size: CGSize(width: UIScreen.main.bounds.width, height: 60),  adUnitId: K.Ad.bannerId)
                .frame(width: UIScreen.main.bounds.width,
                       height: 60,
                       alignment: .center)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(TimerManager())
    }
}

