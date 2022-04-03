//
//  AppDelegate.swift
//  Cars
//
//  Created by Oleg Samoylov on 31.03.2022.
//

import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupWindow()
        setupNavigationBar()
        return true
    }
}

// MARK: - Private

private extension AppDelegate {

    func setupWindow() {
        let window = UIWindow()
        let viewController = FeedAssembly().viewController
        let navigationController = UINavigationController(rootViewController: viewController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
    }

    func setupNavigationBar() {
        let director = NavigationBarDirector()
        director.setupAppearance()
    }
}
