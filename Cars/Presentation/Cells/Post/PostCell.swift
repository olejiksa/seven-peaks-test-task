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
        static let dateTimeLabelLineHeight: CGFloat = 21
    }

    // MARK: Private Properties

    @IBOutlet private weak var pictureView: UIImageView!
    @IBOutlet private weak var shadingView: UIView!
    @IBOutlet private weak var ingressLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var dateTimeLabel: UILabel!

    // MARK: Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()

        
    }

    // MARK: Public Methods

    func setup(article: Article) {
        if let url = article.imageURL, let data = try? Data(contentsOf: url) {
            pictureView.image = UIImage(data: data)
        }

        ingressLabel.text = article.ingress
        titleLabel.text = article.title
        dateTimeLabel.text = "\(article.date)"
    }
}
