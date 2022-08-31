//
//  ContentView.swift
//  Boxing Timer Mix Sound
//
//  Created by Len Lin on 2022/8/20.
//

import SwiftUI
import AVFoundation

import AppTrackingTransparency
import GoogleMobileAds
import AdSupport

struct ContentView: View {
    @EnvironmentObject var timerManager: TimerManager
    
    @State var height: CGFloat = 0 //Height of ad
    @State var width: CGFloat = 0 //Width of ad
    
    var body: some View {
        ZStack(){
            
            
            
            //            SwiftUIBannerAd(adPosition: .top, adUnitId: K.Ad.bannerId)
            
            
            Color.black.ignoresSafeArea()
            ControlView()
            
        }
        //        .onAppear { UIApplication.shared.isIdleTimerDisabled = timerManager.isTiming }
        
//        BannerVC(size: CGSize(width: UIScreen.main.bounds.width, height: 60),  adUnitId: K.Ad.bannerId)
//            .frame(width: UIScreen.main.bounds.width,
//                   height: 60,
//                   alignment: .center)
//            .onAppear{
//                requestPermission()
//            }
        BannerAd(adUnitId: K.Ad.bannerId)
            .frame(width: width, height: height)
                            .onAppear {
                                requestPermission()
                                //Call this in .onAppear() b/c need to load the initial frame size
                                //.onReceive() will not be called on initial load
                                setFrame()
                            }
//            .body(width: 320, peak: 50, alignment: .heart)
        
    }
    
    func setFrame() {
          
            //Get the frame of the safe area
            let safeAreaInsets = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.safeAreaInsets ?? .zero
            let frame = UIScreen.main.bounds.inset(by: safeAreaInsets)
            
            //Use the frame to determine the size of the ad
            let adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(frame.width)
            
            //Set the ads frame
            self.width = adSize.size.width
            self.height = adSize.size.height
        }
    
    func requestPermission() {
//        print("")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if #available(iOS 14, *) {
                
                ATTrackingManager.requestTrackingAuthorization { status in
                    switch status {
                    case .authorized:
                        // Tracking authorization dialog was shown
                        // and we are authorized
                        print("Authorized")
                        
                        // Now that we are authorized we can get the IDFA
                        print(ASIdentifierManager.shared().advertisingIdentifier)
                    case .denied:
                        // Tracking authorization dialog was
                        // shown and permission is denied
                        print("Denied")
                    case .notDetermined:
                        // Tracking authorization dialog has not been shown
                        print("Not Determined")
                    case .restricted:
                        print("Restricted")
                    @unknown default:
                        print("Unknown")
                    }
                    
                    GADMobileAds.sharedInstance().start(completionHandler: nil)
                }
            }
            
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
//            .previewInterfaceOrientation(.landscapeLeft)
            .environmentObject(TimerManager())
    }
}
    
