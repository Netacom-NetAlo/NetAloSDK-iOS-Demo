//
//  AppDelegate.swift
//  TestProject
//
//  Created by Tran Phong on 4/15/21.
//

import UIKit
import NetaloUISDK

struct NetAloSDKConfig {
  let env: NetaloEnviroment
  let appId: Int64
  let appKey:  String
  let accountKey: String
  let appGroupIdentifier: String
  
  // Config for development
  // appId, appKey, accountKey: Provide by NetAlo
  // appGroupIdentifier: Create from apple developer portal
  static let dev = NetAloSDKConfig(env: .testing,
                                   appId: 0,
                                   appKey: "YOUR-APP-KEY",
                                   accountKey: "YOUR-ACCOUNT-KEY",
                                   appGroupIdentifier: "YOUR-APP-GROUP"
  )
  
  // Config for production
  static let prod = NetAloSDKConfig(env: .production,
                                    appId: 1,
                                    appKey: "YOUR-APP-KEY",
                                    accountKey: "YOUR-ACCOUNT-KEY",
                                    appGroupIdentifier: "YOUR-APP-GROUP"
  )
}

// Implement user
class UserMock: NetaloUser {
  var id: Int64
  var phoneNumber: String
  var email: String
  var fullName: String
  var avatarUrl: String
  var session: String
  
  init(id: Int64,
       phoneNumber: String,
       email: String,
       fullName: String,
       avatarUrl: String,
       session: String
  ) {
    self.id = id
    self.phoneNumber = phoneNumber
    self.email = email
    self.fullName = fullName
    self.avatarUrl = avatarUrl
    self.session = session
  }
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  private lazy var netaloSDK: NetaloUISDK = {
    let preConfig = NetAloSDKConfig.dev
    var authorizationType = AuthorizationType.phoneNumber("")
    if let user = NetaloUISDK.authorizedUser() {
      authorizationType = AuthorizationType.user(user)
    }
    
    let config = NetaloConfiguration(
      authorizationType: authorizationType,
      enviroment: preConfig.env,
      appId: preConfig.appId,
      appKey: preConfig.appKey,
      accountKey:preConfig.accountKey,
      appGroupIdentifier: preConfig.appGroupIdentifier,
      analytics: [],
      featureConfig: FeatureConfig(
        user: FeatureConfig.UserConfig(
          forceUpdateProfile: true
          // hidePhone = true, //Hide number phone
          // hideCreateGroup = true, //Hide button create group in list conversasion
          // hideAddInfo = true, //Hide button add contact in list chat
          // hideInfo = true, //Hide click in info user
        )
      )
    )
    
    return NetaloUISDK(config: config)
  }()
  
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    netaloSDK.add(delegate: self)
    return netaloSDK.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  func applicationDidBecomeActive(_ application: UIApplication) {
    netaloSDK.applicationDidBecomeActive(application)
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
    netaloSDK.applicationWillTerminate(application)
  }
  
  func applicationWillResignActive(_ application: UIApplication) {
    netaloSDK.applicationWillResignActive(application)
  }
  
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    netaloSDK.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
  }
  
  func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
    netaloSDK.application(application, continue: userActivity, restorationHandler: restorationHandler)
  }
  
  // MARK: - Demo optional methods
  
  func handleBlockUnblockUser() {
    netaloSDK.block(useId: "USER_ID") { (success) in
      
    }
    netaloSDK.unBlock(useId: "USER_ID") { (success) in
      
    }
  }
  
  func handleGetContacts() {
    netaloSDK.getContacts(searchText: "SEARCH_TEXT", sortType: .sortByName, page: 1, pageSize: 20)
  }
  
  func openGallery() {
    let vc = MultiImagePickerVC.instance(
      with: self,
      config: MultiImagePickerVC.Config(
        resultType: .raw,
        autoDismiss: false,
        maxSelections: 9,
        autoDismissOnMaxSelections: false,
        showDoneButton: true
      )
    )
    self.topMostViewController()?.present(vc, animated: true, completion: nil)
  }
  
  func configEndPoint() {
//    netaloSDK.initSetting(
//      userAvatarEndPoint: AVATAR_ENDPOINT
//    )
  }
}

extension AppDelegate: MultiImagePickerDelegate {
  func multiImagePickerVC(_ viewController: MultiImagePickerVC, didSelect images: [UIImage], videos: [VideoAsset]) {
  }
  func didTapCloseButton() {
  }
}


//MARK: -NetaloUIDelegate
extension AppDelegate: NetaloUIDelegate {
  
  // [Optional] Request pop to viewControlller
  func pop(to viewController: UIViewController) {
  }
  
  // [Optional] Request conversation view controller
  func getConversationViewController() -> UIViewController? {
    return nil
  }
  
  // [Optional] Handle when user session had expired
  func sessionExpired() {}
  
  // [Optional] Handle when user had logout
  func userDidLogout() {}
  
  // Request present a view controller
  func present(viewController: UIViewController) {
    self.topMostViewController()?.present(viewController, animated: false, completion: nil)
  }
  
  // Request push a view controller
  func push(viewController: UIViewController) {
    self.topMostViewController()?.present(viewController, animated: false, completion: nil)
  }
  
  // [Optional] Request open contact
  func openContact() {}
  
  // [Optional] Request switch to main screen
  func switchToMainScreen() {}
  
  // Request return top most view controller
  func topMostViewController() -> UIViewController? {
    if let topController = UIApplication.topViewController() {
      return topController
    }
    return nil
  }
  
  // [Optional] Request return contact view controller
  func getContactViewController() -> UIViewController? {
    return nil
  }
  
  // [Optional] Request update the status bar style
  func updateStatusBar(style: UIStatusBarStyle) {}
  
  // [Optional] Request change theme
  func updateThemeColor(_ themeColor: Int) {}
}

//MARK: -UIApplication
extension UIApplication {
  class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
    if let navigationController = controller as? UINavigationController {
      return topViewController(controller: navigationController.visibleViewController)
    }
    if let tabController = controller as? UITabBarController {
      if let selected = tabController.selectedViewController {
        return topViewController(controller: selected)
      }
    }
    if let presented = controller?.presentedViewController {
      return topViewController(controller: presented)
    }
    return controller
  }
}
