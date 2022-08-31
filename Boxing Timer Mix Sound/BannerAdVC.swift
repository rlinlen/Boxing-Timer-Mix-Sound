//https://stackoverflow.com/questions/67870764/google-admob-banner-ads-are-not-working-in-swiftui

import UIKit
import SwiftUI
import GoogleMobileAds
import AppTrackingTransparency

//final class BannerVC: UIViewControllerRepresentable  {
//    init(size: CGSize, adUnitId: String) {
//            self.size = size
//            self.adUnitId = adUnitId
//        }
//        var size: CGSize
//        var adUnitId: String
//
//        func makeUIViewController(context: Context) -> UIViewController {
//            let view = GADBannerView(adSize: GADAdSizeFromCGSize(size))
//            let viewController = UIViewController()
//            view.adUnitID = adUnitId
//            view.rootViewController = viewController
//            viewController.view.addSubview(view)
//            viewController.view.frame = CGRect(origin: .zero, size: size)
//
//
//            ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
//                let gadRequest = GADRequest()
//                DispatchQueue.main.async {
//                    gadRequest.scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
//                }
//                view.load(gadRequest)
//            })
//            return viewController
//        }
//        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
//    }

final class BannerAd: UIViewControllerRepresentable {
    let adUnitId: String
    
    init(adUnitId: String) {
        self.adUnitId = adUnitId
    }
    
    
    func makeUIViewController(context: Context) -> BannerAdVC {
        return BannerAdVC(adUnitId: adUnitId)
    }

    func updateUIViewController(_ uiViewController: BannerAdVC, context: Context) {
        
    }
}


class BannerAdVC: UIViewController {
    let adUnitId: String
    
    //Initialize variable
    init(adUnitId: String) {
        self.adUnitId = adUnitId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var bannerView: GADBannerView = GADBannerView() //Creates your BannerView
    override func viewDidLoad() {
        bannerView.adUnitID = adUnitId
        bannerView.rootViewController = self
      
        //Add our BannerView to the VC
        view.addSubview(bannerView)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadBannerAd()
    }

    //Allows the banner to resize when transition from portrait to landscape orientation
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate { _ in
            self.bannerView.isHidden = true //So banner doesn't disappear in middle of animation
        } completion: { _ in
            self.bannerView.isHidden = false
            self.loadBannerAd()
        }
    }

    func loadBannerAd() {
        let frame = view.frame.inset(by: view.safeAreaInsets)
        let viewWidth = frame.size.width

        //Updates the BannerView size relative to the current safe area of device (This creates the adaptive banner)
        bannerView.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)

        bannerView.load(GADRequest())
    }
}
