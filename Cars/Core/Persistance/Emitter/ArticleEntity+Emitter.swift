//
//  ArticleEntity+Emitter.swift
//  Cars
//
//  Created by Oleg Samoylov on 04.04.2022.
//

import CoreData

extension ArticleEntity: Emitter {

    func emit() -> Article {
        let defaultDate = Date()
        return Article(
            identifier: identifier,
            title: title ?? "",
            ingress: ingress ?? "",
            imageURL: imageURL,
            publishDate: publishDate ?? defaultDate,
            tags: [],
            items: [],
            creationDate: creationDate ?? defaultDate,
            lastModifiedDate: lastModifiedDate ?? defaultDate
        )
    }
}
