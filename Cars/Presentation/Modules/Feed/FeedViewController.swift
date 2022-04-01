//
//  FeedViewController.swift
//  Cars
//
//  Created by Oleg Samoylov on 01.04.2022.
//

import RxCocoa
import RxSwift
import UIKit

final class FeedViewController: UITableViewController {

    // MARK: Private Types

    private enum Constants {
        static let error = "Error"
        static let title = "Cars"
        static let ok = "OK"
    }

    // MARK: Private Properties

    private let disposeBag = DisposeBag()

    // MARK: Dependency Injection

    private let service: ArticlesService

    init(service: ArticlesService) {
        self.service = service
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTitle()
        setupTableView()
        setupData()
    }
}

// MARK: - Private

private extension FeedViewController {

    func setupTitle() {
        title = Constants.title
    }

    func setupTableView() {
        tableView.delegate = nil
        tableView.dataSource = nil

        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()

        let cellID = "\(PostCell.self)"
        let nib = UINib(nibName: cellID, bundle: .main)
        tableView.register(nib, forCellReuseIdentifier: cellID)
    }

    func setupData() {
        let completion: (Result<Response<Article>, RequestError>) -> Void = { [weak self] result in
            guard let self = self else { return }

            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    let items = Observable.just(response.items)
                    self.bind(items: items)
                case .failure(let error):
                    self.showModal(title: Constants.error, message: error.description)
                }
            }
        }

        if #available(iOS 15, *) {
            Task(priority: .background) {
                let result = await service.getAll()
                completion(result)
            }
        } else {
            service.getAll(completion: completion)
        }
    }

    func bind(items: Observable<[Article]>) {
        let cellType = PostCell.self
        let bindedItems = items.bind(to: tableView.rx.items(cellIdentifier: "\(cellType)",
                                                            cellType: cellType)) { row, article, cell in
            cell.setup(article: article)
        }

        bindedItems.disposed(by: disposeBag)
    }

    func showModal(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: Constants.ok, style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}
