//
//  SceneDelegate.swift
//  UnsplashCollectionWaF
//
//  Created by Виталий Подшибякин on 14.09.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = TabBarController()
        self.window = window
        self.window?.makeKeyAndVisible()
    }
    
}
