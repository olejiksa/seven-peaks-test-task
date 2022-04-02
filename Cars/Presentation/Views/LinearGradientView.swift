//
//  LinearGradientView.swift
//  Cars
//
//  Created by Oleg Samoylov on 02.04.2022.
//

import UIKit

@IBDesignable final class LinearGradientView: UIView {

    // MARK: Public Properties

    override public class var layerClass: AnyClass {
        CAGradientLayer.classForCoder()
    }

    @IBInspectable var startPoint: CGPoint = .zero {
        didSet { gradientLayer?.startPoint = startPoint }
    }

    @IBInspectable var endPoint: CGPoint = .zero {
        didSet { gradientLayer?.endPoint = endPoint }
    }

    @IBInspectable var topColor: UIColor? {
        didSet { gradientLayer?.colors = cgColorGradient }
    }

    @IBInspectable var centerColor: UIColor? {
        didSet { gradientLayer?.colors = cgColorGradient }
    }

    @IBInspectable var bottomColor: UIColor? {
        didSet { gradientLayer?.colors = cgColorGradient }
    }

    // MARK: Private Properties

    private var gradientLayer: CAGradientLayer? {
        layer as? CAGradientLayer
    }

    private var cgColorGradient: [CGColor]? {
        guard let topColor = topColor,
              let centerColor = centerColor,
              let bottomColor = bottomColor else { return nil }

        return [topColor.cgColor, centerColor.cgColor, bottomColor.cgColor]
    }
}
