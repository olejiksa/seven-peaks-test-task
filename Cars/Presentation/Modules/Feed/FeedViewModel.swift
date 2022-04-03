//
//  FeedViewModel.swift
//  Cars
//
//  Created by Oleg Samoylov on 03.04.2022.
//

import RxCocoa
import RxSwift

final class FeedViewModel {

    // MARK: Public Properties

    var items: Observable<[Post]> {
        posts.asObservable()
    }

    let onShowError = BehaviorRelay<String?>(value: nil)

    var onShowLoading: Observable<Bool> {
        loadInProgress
            .asObservable()
            .distinctUntilChanged()
    }

    // MARK: Private Properties

    private let loadInProgress = BehaviorRelay(value: false)
    private let posts = BehaviorRelay(value: [Post]())

    private lazy var dateFormatter = FeedDateFormatter()

    // MARK: Dependency Injection

    private let articlesService: ArticlesService

    init(articlesService: ArticlesService) {
        self.articlesService = articlesService
    }

    // MARK: Public

    func getPosts() {
        DispatchQueue.main.async {
            self.loadInProgress.accept(true)
        }

        if #available(iOS 15, *) {
            Task(priority: .background) {
                let result = await articlesService.getAll()
                DispatchQueue.main.async {
                    self.complete(to: result)
                }
            }
        } else {
            articlesService.getAll(completion: complete)
        }
    }
}

// MARK: - Private

private extension FeedViewModel {

    func complete(to result: Result<[Article], RequestError>) {
        loadInProgress.accept(false)

        switch result {
        case .success(let articles):
            posts.accept(articles.map(post))
        case .failure(let error):
            onShowError.accept(error.description)
        }
    }

    func post(from article: Article) -> Post {
        let date = dateFormatter.string(from: article.publishDate)
        return Post(imageURL: article.imageURL, ingress: article.ingress, title: article.title, date: date)
    }
}
