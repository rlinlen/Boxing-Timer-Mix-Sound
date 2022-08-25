//https://stackoverflow.com/questions/67870764/google-admob-banner-ads-are-not-working-in-swiftui

import UIKit
import SwiftUI
import GoogleMobileAds
import AppTrackingTransparency

final class BannerVC: UIViewControllerRepresentable  {
    
    
    init(size: CGSize, adUnitId: String) {
            self.size = size
            self.adUnitId = adUnitId
        }
        var size: CGSize
        var adUnitId: String

        func makeUIViewController(context: Context) -> UIViewController {
            let view = GADBannerView(adSize: GADAdSizeFromCGSize(size))
            let viewController = UIViewController()
            view.adUnitID = adUnitId
            view.rootViewController = viewController
            viewController.view.addSubview(view)
            viewController.view.frame = CGRect(origin: .zero, size: size)
            
            
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                let gadRequest = GADRequest()
                DispatchQueue.main.async {
                    gadRequest.scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                }
                view.load(gadRequest)
            })
            return viewController
        }
        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
    }
