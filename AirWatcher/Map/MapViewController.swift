//
//  MapViewController.swift
//  AirWatcher
//
//  Created by Daniel Łachacz on 25/02/2021.
//  Copyright © 2021 Daniel Łachacz. All rights reserved.
//

import UIKit
import MapKit
import RxSwift
import RxCocoa
import RxMKMapView

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    var viewModel = MapViewModel()
    private let disposeBag = DisposeBag()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(mapView)
        _ = CLLocation(latitude: 52.069349, longitude: 19.480456)
        //mapView.centerToLocation(initialLocations)

        setAnnotation()
        //to na gorze dziala, wiec teraz pozostaje stworzenie listy MapItem, customowych adnotacji itd.
        
        mapView.rx.willStartLoadingMap
        .asDriver()
        .drive(onNext: { print("map started loading")})
        .disposed(by: disposeBag)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.viewModel.error.observeOn(MainScheduler.instance)
            .subscribe(onNext: { (error) in
                if error == false {
                    print("MAP FALSE")
                    self.requestForAnnotations()
                }
                else {
                    print("ViewModel Error = TRUE")
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
    
    func requestForAnnotations() {
        let observable = viewModel.mapItemArrayBS //Observable.of(viewModel.mapItemArrayBS)
        
        observable.subscribe(
            onNext: { (response) in
                print("RESPONSE: \(response.count)")
        
        },
            onError: { (error) in
                print("MapViewModel Error: fetchSensor \(error)")
        },
            onCompleted: {
                print("MapViewModel Completed: fetchSensor")
        },
            onDisposed: {
                print( "MapViewModel Disposed: fetchSensor")
        }).disposed(by: disposeBag)
        
    }
    
    func setAnnotation() {
        let mapItem = MapItem(id: 0, name: "Roentgena", coordinate: CLLocationCoordinate2D(latitude: 52.146547, longitude: 21.028379))
        mapView.addAnnotation(mapItem)
    }

}

private extension MKMapView {
    func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 1000) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
}
