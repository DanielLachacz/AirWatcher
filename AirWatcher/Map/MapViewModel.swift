//
//  MapViewModel.swift
//  AirWatcher
//
//  Created by Daniel Łachacz on 08/04/2021.
//  Copyright © 2021 Daniel Łachacz. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import MapKit

class MapViewModel: ObservableObject {
    
    let disposeBag = DisposeBag()
    private var apiService : APIServiceProtocol
    private var persistenceService: PersistenceServiceProtocol
    let stations = PublishSubject<[Station]>()
    var stationArray = [Station]()
    var airQualityIndexArray = [AirQualityIndex]()
    var mapItemArray = [MapItem]()
    public let mapItemArrayBS = BehaviorSubject<[MapItem]>(value: [])
    public let error = BehaviorSubject<Bool>(value: true)
    
    init (apiService: APIServiceProtocol = APIService(), persistenceService: PersistenceServiceProtocol =
    PersistenceService()) {
        self.apiService = apiService
        self.persistenceService = persistenceService
        fetchSavedStations()
    }
    
    func fetchSavedStations() {
           do {
               stationArray += try persistenceService.fetchStations()
               self.stations.onNext(stationArray)
           } catch {
               print("ERROR fetchSavedStations AddViewModel")
           }
        fetchSavedAirQualityIndex()
    }
    
    func fetchSavedAirQualityIndex() {
        do {
            airQualityIndexArray += try persistenceService.fetchAirQualityIndex()
         if airQualityIndexArray.count > 0 {
         }
        } catch {
            print("ERROR fetchSavedStations AddViewModel")
        }
        setMapItem()
    }
    
    func setMapItem() {
        let stations = stationArray
        let airs = airQualityIndexArray
        
        airs.forEach { air in
            guard let station = stations.first(where: { $0.id == air.id}) else {
                print("The Stations could not be found for the AirQualityIndex")
                return
            }
            let mapItem = MapItem(
                id: air.id, name: station.stationName, coordinate: CLLocationCoordinate2D(
                    latitude: Double(station.gegrLat) ?? 0.0,
                    longitude: Double(station.gegrLon) ?? 0.0))
            
            mapItemArray.append(mapItem)
            print("mapItemArray: \(mapItemArray.count)")
        }
        if (mapItemArray.count > 0) {
            print("bigger than 0")
            self.mapItemArrayBS.onNext(mapItemArray)
            error.onNext(false)
        } else {
            print("zero")
            self.error.onNext(true)
        }
        self.mapItemArrayBS.onNext(mapItemArray)
        
    }

    
}
