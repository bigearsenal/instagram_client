//
//  ReposListViewModel.swift
//  github
//
//  Created by Chung Tran on 26/03/2019.
//  Copyright © 2019 Chung Tran. All rights reserved.
//

import Foundation

import RealmSwift
import RxSwift
import RxRealm
import RxCocoa

import Unbox

class ItemsListViewModel<T> where T: Object, T: Unboxable {
    internal let bag = DisposeBag()
    let fetcher: ItemsFetcher<T>
    
    private(set) var items: Observable<(AnyRealmCollection<T>, RealmChangeset?)>!
    var realm: Realm?
    
    private var predicate: NSPredicate?
    
    init(router: String, predicate: NSPredicate? = nil) {
        self.predicate = predicate
        
        fetcher = ItemsFetcher<T>(router: router)
        
        // fetch and store
        bindOutput()
    }
    
    // MARK: - Methods
    private func bindOutput() {
        //bind posts
        guard let realm = try? Realm() else {
            return
        }
        var query = realm.objects(T.self)
        if let predicate = predicate {query = query.filter(predicate)}
        items = Observable.changeset(from: query).share()
    }
    
    internal func save(_ newItems: [T]) {
        if realm == nil {
            realm = try? Realm()
        }
        guard let realm = realm else {return}
        do {
            try realm.write {
                realm.add(newItems, update: true)
            }
        } catch let e {
            print(e)
        }
        
    }
    
    func fetchNext() -> Completable {
        return Completable.create {completable in
            let disposable = Disposables.create()
            self.fetcher.requestNext()
                .subscribe(onSuccess: { newItems in
                    self.save(newItems)
                    completable(.completed)
                }, onError: { (error) in
                    completable(.error(error))
                })
                .disposed(by: self.bag)
            return disposable
        }
    }
    
    @objc func refreshFetcher() {
        fetcher.refresh()
    }
}
