//
//  URLRequest+Extension.swift
//  News App
//
//  Created by Jhoan Mauricio Vivas Rubiano on 18/05/20.
//  Copyright © 2020 Sennin. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct Resource<T:Decodable> {
    let url:URL
}

extension ArticlesList{
    static var all: Resource<ArticlesList> = {
        let url = URL(string: "http://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=0e053ba3521a4dd0972f013e7835e70a")!
        return Resource(url: url)
    }()
}

extension URLRequest {
    
    static func load <T> (resource: Resource<T> ) -> Observable<T?> {
        return Observable.just(resource.url).flatMap { url -> Observable<Data> in
            let request = URLRequest(url: url)
            return URLSession.shared.rx.data(request: request)
        }.map { (data) -> T? in
            return try? JSONDecoder().decode(T.self, from: data)
        }.asObservable()
    }
}
