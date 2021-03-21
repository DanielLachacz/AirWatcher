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
        viewModel.fetchSavedAddItemsAndData()
        bindTableView()
        
//        stationsTableView.rx.setDelegate(self).disposed(by: disposeBag)
//     //   if confirmation == true {
//            bindTableView()
//     //   }
//        print(confirmation)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.hidesBottomBarWhenPushed = false
        //stationsTableView.dataSource = nil
        //stationsTableView.delegate = nil
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
       disposeBag = DisposeBag()
    }
    
    @IBAction func unwindToFavorite(_ sender: UIStoryboardSegue) {}
        
    func bindTableView() {
        self.viewModel.favoriteList.bind(to: stationsTableView.rx.items(cellIdentifier: "favoriteCell", cellType: FavoriteTableViewCell.self)) { (row,item,cell) in
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
            print("deleteStation: \(item.row)")
            self.viewModel.deleteStationItem(indexPath: item)
            
            //Refresh itemsList in the ViewModel to remove right object
            self.viewModel.fetchSavedAddItemsAndData()
        })
        .disposed(by: disposeBag)
    }
    
}

extension FavoriteViewController: UITableViewDelegate {
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //print("indexPath.section: \(indexPath.section)")
        if indexPath.section == 0 {
            return 310
        }
//        else if indexPath.section == 1 {
//            return 200
//        }
//        else if indexPath.section == 2 {
//            return 220
//        }
//        else if indexPath.section == 3 {
//            return 340
//        }
//        else if indexPath.section == 4 {
//            return 260
//        }
//        else if indexPath.section == 5 {
//            return 260
//        }
//        else if indexPath.section == 6 {
//            return 260
//        }
//        else if indexPath.section == 7 {
//            return 260
//        }
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


