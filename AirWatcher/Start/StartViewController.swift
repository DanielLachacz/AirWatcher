//
//  ViewController.swift
//  AirWatcher
//
//  Created by Daniel Łachacz on 15/11/2020.
//  Copyright © 2020 Daniel Łachacz. All rights reserved.
//

import UIKit
import SVProgressHUD
import RxSwift

class StartViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    var viewModel = StartViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.show()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setProgressHud()
        fetchData()
    }
    
    //check if data exists and go to the another view
    func fetchData() {
        self.viewModel.saveingError.observeOn(MainScheduler.instance)
        .subscribe(onNext: { (error) in
            if error == false {
                SVProgressHUD.dismiss()
                self.showTabBarController()
                print("START FALSE")
            } else if error == true {
                print("ERROR fetchData StartViewController: \(error)")
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
    }
    
    func showTabBarController() {
        guard let tabBarController = self.storyboard?.instantiateViewController(identifier: "TabBarController")
            as? UITabBarController else {
                return
        }
        tabBarController.modalPresentationStyle = .fullScreen
        tabBarController.selectedIndex = 0
        self.show(tabBarController, sender: nil)
    }
    
    func setProgressHud() {
                SVProgressHUD.setDefaultStyle(.custom)
                SVProgressHUD.setForegroundColor(UIColor.red)
                SVProgressHUD.setRingRadius(20.0)
    }


}

