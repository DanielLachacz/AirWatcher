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

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var viewModel = MapViewModel()
    private let disposeBag = DisposeBag()
    private let colors = Colors()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        view.addSubview(mapView)
        _ = CLLocation(latitude: 52.069349, longitude: 19.480456) //Start map in the center of the country (Poland)
        
        mapView.rx.willStartLoadingMap
        .asDriver()
        .drive(onNext: { print("map started loading")})
        .disposed(by: disposeBag)
        
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.viewModel.error.observeOn(MainScheduler.instance)
            .subscribe(onNext: { (error) in
                if error == false {
                    self.requestForAnnotations()
                }
                else {
                    print("MapViewController: MapItem Error ")
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
        let observable = viewModel.mapItemArrayBS
        
        observable.subscribe(
            onNext: { (response) in
                for i in response.indices {
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = response[i].coordinate
                    annotation.title = response[i].name
                    annotation.subtitle = response[i].indexLevel
                    self.mapView.addAnnotation(annotation)
                }
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
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "MyMarker")
        
        annotationView.markerTintColor = UIColor.blue
        annotationView.glyphText = ""
        
        switch annotation.subtitle {
            
        case "Bardzo zły":
            annotationView.markerTintColor = colors.darkRed
        case "Zły":
            annotationView.markerTintColor = colors.red
        case "Dostateczny":
            annotationView.markerTintColor = colors.orange
        case "Umiarkowany":
            annotationView.markerTintColor = colors.yellow
        case "Dobry":
            annotationView.markerTintColor = colors.lime
        case "Bardzo dobry":
            annotationView.markerTintColor = colors.green
        default :
            annotationView.markerTintColor = colors.gray
        }
        
        return annotationView
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

