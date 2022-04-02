//
//  FeedViewController.swift
//  Cars
//
//  Created by Oleg Samoylov on 01.04.2022.
//

import RxSwift
import UIKit

final class FeedViewController: UIViewController {

    // MARK: Private Types

    private enum Constants {
        static let error = "Error"
        static let title = "Cars"
        static let ok = "OK"
    }

    // MARK: Private Properties

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = nil
        tableView.dataSource = nil

        tableView.allowsSelection = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = .init()

        let cellID = "\(PostCell.self)"
        let nib = UINib(nibName: cellID, bundle: .main)
        tableView.register(nib, forCellReuseIdentifier: cellID)

        return tableView
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        if #available(iOS 13.0, *) {
            activityIndicator.style = .large
        } else {
            activityIndicator.style = .whiteLarge
        }
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()

    private let disposeBag = DisposeBag()

    // MARK: Dependency Injection

    private let viewModel: FeedViewModel

    init(viewModel: FeedViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
        setupUI()
        setupConstaints()

        viewModel.getPosts()
    }
}

// MARK: - Private

private extension FeedViewController {

    func bindViewModel() {
        let cellType = PostCell.self

        viewModel
            .items
            .bind(to: tableView.rx.items(cellIdentifier: "\(cellType)", cellType: cellType)) { $2.post = $1 }
            .disposed(by: disposeBag)

        viewModel
            .onShowLoading
            .map { [weak activityIndicator] stopped in
                if stopped {
                    activityIndicator?.startAnimating()
                } else {
                    activityIndicator?.stopAnimating()
                }
            }
            .subscribe()
            .disposed(by: disposeBag)

        viewModel
            .onShowError
            .map { [weak self] in
                guard let message = $0 else { return }
                self?.showModal(title: Constants.error, message: message)
            }
            .subscribe()
            .disposed(by: disposeBag)
    }

    func setupUI() {
        title = Constants.title
        view.backgroundColor = .black
        UINavigationBar.configureAppearance()
    }

    func setupConstaints() {
        [tableView, activityIndicator].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    func showModal(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: Constants.ok, style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}
