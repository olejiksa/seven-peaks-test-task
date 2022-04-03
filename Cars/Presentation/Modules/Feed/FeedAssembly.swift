//
//  FeedAssembly.swift
//  Cars
//
//  Created by Oleg Samoylov on 03.04.2022.
//

import UIKit

struct FeedAssembly: Assembly {

    let viewController: UIViewController

    init() {
        let storage = Storage()
        let articlesService = ArticlesService(storage: storage)
        let viewModel = FeedViewModel(articlesService: articlesService)
        viewController = FeedViewController(viewModel: viewModel)
    }
}
