//
//  NewsfeedViewController.swift
//  Instagram
//
//  Created by Chung Tran on 03/04/2019.
//  Copyright © 2019 Chung Tran. All rights reserved.
//

import UIKit
import RxRealmDataSources
import RxCocoa

class NewsfeedViewController: ItemsListViewController<Post> {
    override var router: String! {
        return "/v1/users/self/media/recent"
    }
    
    var dataSource = RxCollectionViewRealmDataSource<Post>(cellIdentifier: "PostCell", cellType: PostCell.self) {cell, ip, post in
        cell.update(with: post)
    }

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        // initialize refreshControl
        refreshControl = UIRefreshControl()
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Newsfeed"
    }
    
    override func bindUI() {
        super.bindUI()
        // bind refreshControll to collectionView
        collectionView.refreshControl = refreshControl
        
        // bind viewModel
        viewModel.items
            .bind(to: collectionView.rx.realmChanges(dataSource))
            .disposed(by: bag)
        
        // fetchNext when reach last 20 point to the bottom
        collectionView.rx.contentOffset
            .filter {$0.y + self.collectionView.frame.size.height + 20 > self.collectionView.contentSize.height}
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] (_) in
                self?.fetchNext()
            })
            .disposed(by: bag)
        
    }
}
