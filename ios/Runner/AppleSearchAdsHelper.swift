import Foundation
import AdServices
import AppTrackingTransparency

@objc class AppleSearchAdsHelper: NSObject {
    
    @objc static func getAttributionToken() -> String? {
        if #available(iOS 14.3, *) {
            do {
                let token = try AAAttribution.attributionToken()
                return token
            } catch {
                print("Error getting Apple Search Ads attribution token: \(error)")
                return nil
            }
        } else {
            print("Apple Search Ads attribution requires iOS 14.3 or later")
            return nil
        }
    }
    
    @objc static func requestTrackingAuthorization(completion: @escaping (Bool) -> Void) {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                DispatchQueue.main.async {
                    completion(status == .authorized)
                }
            }
        } else {
            completion(true)
        }
    }
}
