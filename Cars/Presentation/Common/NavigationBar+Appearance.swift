//
//  NavigationBarAppearance.swift
//  Cars
//
//  Created by Oleg Samoylov on 03.04.2022.
//

import UIKit

extension UINavigationBar {

    // MARK: Public Types

    enum Constants {
        private static let titleFont: UIFont = .systemFont(ofSize: 17, weight: .medium)
        private static let titleColor: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        private static let titleLetterSpacing: CGFloat = -0.41

        static let titleTextAttributes: [NSAttributedString.Key: Any] = [.font: titleFont,
                                                                         .foregroundColor: titleColor,
                                                                         .kern: titleLetterSpacing]
    }

    // MARK: Public

    static func configureAppearance() {
        if #available(iOS 15, *) {
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.configureWithDefaultBackground()

            navigationBarAppearance.backgroundColor = #colorLiteral(red: 0.2980392157, green: 0.2980392157, blue: 0.2980392157, alpha: 1)
            navigationBarAppearance.titleTextAttributes = UINavigationBar.Constants.titleTextAttributes

            let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
            navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

            let appearance = UINavigationBar.appearance()
            appearance.scrollEdgeAppearance = navigationBarAppearance
            appearance.standardAppearance = navigationBarAppearance
            appearance.compactAppearance = navigationBarAppearance
        } else {
            let navigationBarAppearance = UINavigationBar.appearance()
            navigationBarAppearance.barTintColor = #colorLiteral(red: 0.2980392157, green: 0.2980392157, blue: 0.2980392157, alpha: 1)
            navigationBarAppearance.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            navigationBarAppearance.barStyle = .black
            navigationBarAppearance.titleTextAttributes = Constants.titleTextAttributes
        }
    }
}
