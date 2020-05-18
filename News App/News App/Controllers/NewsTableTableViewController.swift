//
//  NewsTableTableViewController.swift
//  News App
//
//  Created by Jhoan Mauricio Vivas Rubiano on 18/05/20.
//  Copyright © 2020 Sennin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class NewsTableTableViewController: UITableViewController {
    
    var diposeBag = DisposeBag()
    private var articles = [Article]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        } else {
            // Fallback on earlier versions
        }
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(NewsTableTableViewController.handleRefresh(_:)), for: .valueChanged)
        self.refreshControl?.tintColor = UIColor.red
        self.tableView.addSubview(self.refreshControl!)
        
        
        
        populateNews()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return articles.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleTableViewCell", for: indexPath) as? ArticleTableViewCell else{
            fatalError("ArticleTableViewCell not found")
        }
        cell.titleLabel.text = self.articles[indexPath.row].title
        cell.descriptionLabel.text = self.articles[indexPath.row].description
        
        return cell
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl){
        populateNews()
    }
    
    private func populateNews(){
        
        URLRequest.load(resource: ArticlesList.all).subscribe(onNext: { [weak self](result) in
            if let result = result {
                self?.articles = result.articles
                self?.updateUIdata()
                self?.stopRefreshControl()
            }
        }).disposed(by: diposeBag);
        
        
        /* Using plain implementation of RxSwift to get data from URLRequest class
         
         let url = URL(string: "http://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=0e053ba3521a4dd0972f013e7835e70a")!
         
         Observable.just(url).flatMap { url -> Observable<Data> in
         let request = URLRequest(url: url)
         return URLSession.shared.rx.data(request: request)
         }.map { data -> [Article]? in
         return try? JSONDecoder().decode(ArticlesList.self, from: data).articles
         }.subscribe(onNext: { [weak self] articles in
         if let articles = articles {
         self?.articles = articles
         self?.updateUIdata()
         }
         self?.stopRefreshControl()
         }).disposed(by: diposeBag)
         
         */
        
    }
    
    private func updateUIdata(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func stopRefreshControl(){
        DispatchQueue.main.async {
            if let refreshControl = self.refreshControl, refreshControl.isRefreshing {
                self.refreshControl?.endRefreshing()
            }
        }
    }
    
}
