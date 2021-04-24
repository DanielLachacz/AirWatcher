//
//  FavoriteViewController.swift
//  AirWatcher
//
//  Created by Daniel Łachacz on 15/11/2020.
//  Copyright © 2020 Daniel Łachacz. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD

class FavoriteViewController: UIViewController {
   
    @IBOutlet weak var stationsTableView: UITableView!
    private var disposeBag = DisposeBag()
    private var viewModel = FavoriteViewModel()
    var confirmation = Bool()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        stationsTableView.estimatedRowHeight = UITableView.automaticDimension
        stationsTableView.estimatedRowHeight = 280
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hidesBottomBarWhenPushed = true
        stationsTableView.rx.setDelegate(self).disposed(by: disposeBag)
        setProgressHud()
        
        if confirmation == true {
            viewModel.fetchStations()
            self.viewModel.saveingError.observeOn(MainScheduler.instance)
            .subscribe(onNext: { (error) in
                if error == false {
                   SVProgressHUD.dismiss()
                    print("error false: \(error)")

                } else if error == true {
                    print("ERROR fetchData FavoriteViewController: \(error)")
                    print("error true: \(error)")
                }
                },
                           onError: { (error) in
                            print(error)
                },
                           onCompleted: {
                            print("Completed")
                }, onDisposed: {
                    print("Disposed")
                }).disposed(by: self.disposeBag)
            
        } else {
            viewModel.fetchSavedAddItemsAndData()
        }
        bindTableView()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.hidesBottomBarWhenPushed = false
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
       disposeBag = DisposeBag()
    }
    
    @IBAction func unwindToFavorite(_ sender: UIStoryboardSegue) {}
        
    func bindTableView() {
        self.viewModel.favoriteItemArrayBS.bind(to: stationsTableView.rx.items(cellIdentifier: "favoriteCell", cellType: FavoriteTableViewCell.self)) { (row,item,cell) in
            cell.cellStation = item
        }.disposed(by: disposeBag)
        
//        stationsTableView.rx.modelSelected(AddItem.self).subscribe(onNext: { item in
//            //print("SelectedItem: \(item.sensors)")
//        }).disposed(by: disposeBag)
        
        deleteStation()
    }
    
    
    func deleteStation() {
        stationsTableView.rx.itemDeleted
        .subscribe (onNext: { item in
            self.viewModel.deleteAddItem(indexPath: item)
            self.stationsTableView.reloadData()
            
            //Refresh itemsList in the ViewModel to remove right object
           // self.viewModel.fetchSavedAddItemsAndData()
        })
        .disposed(by: disposeBag)
    }
    
    func setProgressHud() {
                SVProgressHUD.setDefaultStyle(.custom)
                SVProgressHUD.setForegroundColor(UIColor.black)
                SVProgressHUD.setRingRadius(20.0)
    }
    
}

extension FavoriteViewController: UITableViewDelegate {
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 310
        }
//        else if indexPath.section == 8 {
//            return 260
//        }
//        else if indexPath.section == 9 {
//            return 240
//        }
        else {
            return UITableView.automaticDimension
        }
    }
}



