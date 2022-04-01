//
//  TypographyExtensions.swift
//  Cars
//
//  Created by Oleg Samoylov on 02.04.2022.
//

import UIKit

protocol Typography: UILabel {

    var lineHeight: CGFloat { get set }
}

// MARK: - TypographyExtensions

extension UILabel: Typography {

    @IBInspectable
    var lineHeight: CGFloat {
        get {
            paragraphStyle?.maximumLineHeight ?? 0
        }
        set {
            let lineHeight = newValue
            let baselineOffset = (lineHeight - font.lineHeight) / 2.0 / 2.0
            addAttribute(.baselineOffset, value: baselineOffset)
            addAttribute(
                .paragraphStyle,
                value: (paragraphStyle ?? NSParagraphStyle())
                    .mutable
                    .withProperty(lineHeight, for: \.minimumLineHeight)
                    .withProperty(lineHeight, for: \.maximumLineHeight)
            )
        }
    }
}

// MARK: - Private

private extension UILabel {

    var attributes: [NSAttributedString.Key: Any]? {
        if let attributedText = attributedText, attributedText.length > 0 {
            return attributedText.attributes(at: 0, effectiveRange: nil)
        } else {
            return nil
        }
    }

    func getAttribute<AttributeType>( _ key: NSAttributedString.Key) -> AttributeType? where AttributeType: Any {
        attributes?[key] as? AttributeType
    }

    func setAttribute<AttributeType>(
        _ key: NSAttributedString.Key,
        value: AttributeType?
    ) where AttributeType: Any  {
        if let value = value {
            addAttribute(key, value: value)
        } else {
            removeAttribute(key)
        }
    }

    func addAttribute(_ key: NSAttributedString.Key, value: Any) {
        attributedText = attributedText?.stringByAddingAttribute(key, value: value)
    }

    func removeAttribute(_ key: NSAttributedString.Key) {
        attributedText = attributedText?.stringByRemovingAttribute(key)
    }

    var paragraphStyle: NSParagraphStyle? {
        getAttribute(.paragraphStyle)
    }
}

private extension NSAttributedString {

    var entireRange: NSRange {
        NSRange(location: 0, length: self.length)
    }

    func stringByAddingAttribute(_ key: NSAttributedString.Key, value: Any) -> NSAttributedString {
        let changedString = NSMutableAttributedString(attributedString: self)
        changedString.addAttribute(key, value: value, range: entireRange)
        return changedString
    }

    func stringByRemovingAttribute(_ key: NSAttributedString.Key) -> NSAttributedString {
        let changedString = NSMutableAttributedString(attributedString: self)
        changedString.removeAttribute(key, range: entireRange)
        return changedString
    }
}

private extension NSParagraphStyle {

    var mutable: NSMutableParagraphStyle {
        let mutable = NSMutableParagraphStyle()
        mutable.setParagraphStyle(self)
        return mutable
    }
}

private extension NSMutableParagraphStyle {

    func withProperty<ValueType>(
        _ value: ValueType,
        for keyPath: ReferenceWritableKeyPath<NSMutableParagraphStyle, ValueType>
    ) -> NSMutableParagraphStyle {
        self[keyPath: keyPath] = value
        return self
    }
}
