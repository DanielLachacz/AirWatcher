//
//  AddViewController.swift
//  AirWatcher
//
//  Created by Daniel Łachacz on 25/11/2020.
//  Copyright © 2020 Daniel Łachacz. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class AddViewController: UIViewController {
    
    @IBOutlet weak var addTableView: UITableView!
    private let disposeBag = DisposeBag()
    var viewModel = AddViewModel()
    var confirmation = Bool()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        addTableView.rx.setDelegate(self).disposed(by: disposeBag)
        bindTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        confirmation = false
    }
    
    func bindTableView() {
        viewModel.addItems.bind(to: addTableView.rx.items(cellIdentifier: "addCell", cellType: AddTableViewCell.self)) { (row, item, cell)
            in
            cell.cellAdd = item
            
        }.disposed(by: disposeBag)
        
        addTableView.rx.modelSelected(AddItem.self)
            .flatMap { [unowned self] item in
                self.presentAlert(title: "Dodaj Stację", message: "Chcesz dodać stację do ulubionych?")
                    .map { item }
        }
        .bind { [viewModel] in

            viewModel.addStationItem(addItem: $0)
        }
        .disposed(by: disposeBag)
        
        viewModel.fetchSavedStations()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let favoriteViewController = segue.destination as! FavoriteViewController
        if confirmation == true {
            favoriteViewController.confirmation = true
        }
        else {
            favoriteViewController.confirmation = false
        }
       
    }
    
}

extension AddViewController: UITableViewDelegate {

func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
}

}

extension AddViewController {
    func presentAlert(title: String?, message: String?) -> Observable<Void> {
        let result = PublishSubject<Void>()
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Dodaj", style: .default, handler: { _ in
            result.onNext(())
            result.onCompleted()
            self.confirmation = true
        })
        let cancel = UIAlertAction(title: "Anuluj", style: .cancel) { _ in
            result.onCompleted()
        }
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true)
        return result
    }
}
