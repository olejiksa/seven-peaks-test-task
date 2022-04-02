//
//  PostCell.swift
//  Cars
//
//  Created by Oleg Samoylov on 02.04.2022.
//

import UIKit

final class PostCell: UITableViewCell {

    // MARK: Private Types

    private enum Constants {
        static let duration: CGFloat = 0.25
    }

    // MARK: Private Properties

    @IBOutlet private weak var pictureView: UIImageView!
    @IBOutlet private weak var ingressLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var dateTimeLabel: UILabel!

    // MARK: Lifecycle

    override func prepareForReuse() {
        super.prepareForReuse()

        pictureView.image = nil
    }

    // MARK: Public Methods

    func set(image: UIImage?, animated: Bool) {
        pictureView.image = image

        guard animated else { return }

        let transition = CATransition()
        transition.duration = Constants.duration
        transition.timingFunction = CAMediaTimingFunction.init(name: .easeInEaseOut)
        transition.type = .fade

        pictureView.layer.add(transition, forKey: nil)
    }

    func set(post: Post) {
        ingressLabel.text = post.ingress
        titleLabel.text = post.title
        dateTimeLabel.text = post.date
    }
}
