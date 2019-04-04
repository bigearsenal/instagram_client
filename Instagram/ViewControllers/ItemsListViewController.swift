//
//  ItemsListViewController.swift
//  Instagram
//
//  Created by Chung Tran on 03/04/2019.
//  Copyright © 2019 Chung Tran. All rights reserved.
//

import UIKit
import RealmSwift
import Unbox
import RxSwift
import JGProgressHUD

class ItemsListViewController<T>: UIViewController where T: Object, T: Unboxable {
    // For inheritance
    var router: String! {
        return nil
    }
    
    var predicate: NSPredicate? {
        return nil
    }
    
    var viewModel: ItemsListViewModel<T>!
    
    // dispose bag
    internal let bag = DisposeBag()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        createViewModel()
        bindUI()
    }
    
    func createViewModel() {
        guard let router = router else {
            fatalError("router must be defined")
        }
        viewModel = ItemsListViewModel<T>(router: router, predicate: predicate)
    }
    
    func bindUI() {
        // for inheritting
    }
    
    func fetchNext() {
        self.viewModel.fetchNext()
            .subscribe(
                onCompleted: {
                    self.endRefreshing()
                },
                onError: { [weak self] _ in
                    self?.endRefreshing()
                    guard let self = self else {return}
                    let hud = JGProgressHUD(style: .dark)
                    hud.textLabel.text = "Can not retrieve items.\nPlease check your internet connection"
                    hud.indicatorView = JGProgressHUDErrorIndicatorView()
                    hud.isUserInteractionEnabled = true
                    hud.show(in: self.view)
                    hud.dismiss(afterDelay: 3)
            })
            .disposed(by: self.bag)
    }
    
    @objc func refresh() {
        self.viewModel.refreshFetcher()
        fetchNext()
    }
    
    func endRefreshing() {
        // for inheriting
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
