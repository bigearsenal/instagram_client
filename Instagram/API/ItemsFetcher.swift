//
//  RepositoryFetcher.swift
//  github
//
//  Created by Chung Tran on 26/03/2019.
//  Copyright © 2019 Chung Tran. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

import Unbox

class ItemsFetcher<T> where T: Unboxable {
    enum FetcherError: Error {
        case createRequestFailed, requestFailed, canceled
    }
    
    // MARK: - Init
    private var router: String
    init(router: String) {
        self.router = router
    }
    
    // MARK: - Subjects
    let list = BehaviorRelay<[T]>(value: [])
    let bag = DisposeBag()
    
    // MARK: - Methods
    var isFetching = false
    var reachedTheEnd = false
    var maxId: String?
    
    func refresh() {
        reachedTheEnd = false
        isFetching = false
        maxId = nil
    }
    
    func requestNext() -> Single<[T]> {
        return Single.create { single in
            let disposable = Disposables.create()
            
            // check if request is dupplicated or reached the end
            if self.isFetching || self.reachedTheEnd {
                single(.error(FetcherError.canceled))
                return disposable
            }
            
            // mark as fetching
            self.isFetching = true
            
            // create query base on maxId
            var query = "\(self.router)?count=6"
            if let maxId = self.maxId {
                query += "&max_id=\(maxId)"
            }
            
            // send request
            InstagramAPI.standard.requestWithToken(router: query, method: .get, parameters: nil)
                .subscribe(
                    onNext: { [weak self] (r, json) in
                        // mark as fetched
                        self?.isFetching = false
                        
                        // handle data
                        if let json = json as? [String: Any],
                            let data = json["data"] as? Array<[String: Any]>,
                            let pagination = json["pagination"] as? [String: Any]{
                            let nextValue = data.compactMap({ (dict) -> T? in
                                return try? T(unboxer: Unboxer(dictionary: dict))
                            })
                            let nextArray = (self?.list.value ?? []) + nextValue
                            self?.list.accept(nextArray)
                            single(.success(nextValue))
                            
                            if let next_max_id = pagination["next_max_id"] as? String {
                                self?.maxId = next_max_id
                            } else {
                                self?.reachedTheEnd = true
                                single(.error(FetcherError.canceled))
                            }
                        } else {
                            single(.error(FetcherError.canceled))
                        }
                    },
                    onError: {[weak self] (error) in
                        self?.isFetching = false
                        single(.error(FetcherError.requestFailed))
                    }
                )
                .disposed(by: self.bag)
            
            return disposable
        }
        
    }
}
