//
//  PostCell.swift
//  Cars
//
//  Created by Oleg Samoylov on 02.04.2022.
//

import RxSwift
import UIKit

final class PostCell: UITableViewCell {

    // MARK: Private Types

    private enum Constants {
        static let duration: CGFloat = 0.25
    }

    // MARK: Public Properties

    var post: Post? {
        didSet {
            guard let post = post else { return }
            set(imageURL: post.imageURL)
            ingressLabel.text = post.ingress
            titleLabel.text = post.title
            dateTimeLabel.text = post.date
        }
    }

    // MARK: Private Properties

    @IBOutlet private weak var pictureView: UIImageView!
    @IBOutlet private weak var ingressLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var dateTimeLabel: UILabel!

    private var disposable: Disposable?

    // MARK: Lifecycle

    override func prepareForReuse() {
        super.prepareForReuse()

        disposable?.dispose()
        pictureView.image = nil
    }
}

// MARK: Private

private extension PostCell {

    func set(imageURL: URL?) {
        guard let imageURL = imageURL else { return }

        disposable = loadImage(url: imageURL)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak pictureView] in
                pictureView?.image = $0

                let transition = CATransition()
                transition.duration = Constants.duration
                transition.timingFunction = CAMediaTimingFunction.init(name: .easeInEaseOut)
                transition.type = .fade

                pictureView?.layer.add(transition, forKey: nil)
            })
    }

    func loadImage(url: URL) -> Observable<UIImage?> {
        Observable<UIImage?>.create { emitter in
            let task = URLSession.shared.dataTask(with: url) { data, _, _ in
                guard let data = data else {
                    emitter.onNext(nil)
                    emitter.onCompleted()
                    return
                }

                let image = UIImage(data: data)
                emitter.onNext(image)
                emitter.onCompleted()
            }

            task.resume()
            return Disposables.create { task.cancel() }
        }
    }
}
