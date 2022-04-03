//
//  ArticleEntity+Absorber.swift
//  Cars
//
//  Created by Oleg Samoylov on 04.04.2022.
//

import CoreData

extension ArticleEntity: Absorber {

    func absorb(_ object: Article) {
        identifier = object.identifier
        creationDate = object.creationDate
        publishDate = object.publishDate
        lastModifiedDate = object.lastModifiedDate
        title = object.title
        ingress = object.ingress
        imageURL = object.imageURL
    }
}
