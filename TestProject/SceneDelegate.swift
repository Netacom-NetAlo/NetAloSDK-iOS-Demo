//
//  SceneDelegate.swift
//  TestProject
//
//  Created by Tran Phong on 5/26/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    @available(iOS 13.0, *)
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        if let windowScene = scene as? UIWindowScene {
            let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController")
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = viewController
            self.window = window
            window.makeKeyAndVisible()
        }
    }

}
