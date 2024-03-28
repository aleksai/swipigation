//
//  AppDelegate.swift
//  Swipigation
//
//  Created by Alek Sai on 3/28/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let items = [
            MenuItem(id: UUID().uuidString, title: "The Shawshank Redemption", color: .systemRed),
            MenuItem(id: UUID().uuidString, title: "The Godfather", color: .systemBlue),
            MenuItem(id: UUID().uuidString, title: "The Dark Knight", color: .systemYellow),
            MenuItem(id: UUID().uuidString, title: "12 Angry Men", color: .systemGreen),
            MenuItem(id: UUID().uuidString, title: "Schindler's List", color: .systemTeal),
            MenuItem(id: UUID().uuidString, title: "Pulp Fiction", color: .systemGray),
            MenuItem(id: UUID().uuidString, title: "Forrest Gump", color: .systemBrown),
            MenuItem(id: UUID().uuidString, title: "Fight Club", color: .systemGray2),
            MenuItem(id: UUID().uuidString, title: "Inception", color: .systemIndigo),
            MenuItem(id: UUID().uuidString, title: "Dune: Part Two", color: .systemGray3),
            MenuItem(id: UUID().uuidString, title: "The Matrix", color: .systemPurple),
            MenuItem(id: UUID().uuidString, title: "GoodFellas", color: .systemGray4),
            MenuItem(id: UUID().uuidString, title: "Seven", color: .systemOrange)
        ]
        
        let swipeNavigationController = SwipeNavigationController(menuItems: items)
        
        window?.backgroundColor = .white
        window?.rootViewController = swipeNavigationController
        window?.makeKeyAndVisible()
        
        return true
    }

}
