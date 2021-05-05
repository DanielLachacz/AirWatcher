//
//  APIService.swift
//  AirWatcher
//
//  Created by Daniel Łachacz on 15/11/2020.
//  Copyright © 2020 Daniel Łachacz. All rights reserved.
//

import Foundation
import RxSwift

protocol APIServiceProtocol {

    func fetchStations(url: URL) -> Observable<[Station]>
    func fetchSensors(url: URL) -> Observable<[Sensor]>
    func fetchData(url: URL) -> Observable<AirData>
    func fetchAirQualityIndex(url: URL) -> Observable<AirQualityIndex>
}

final class APIService: APIServiceProtocol {
    
    
    func fetchStations(url: URL) -> Observable<[Station]> {
        
        return Observable.create { observer -> Disposable in
        
        let task = URLSession.shared.dataTask(with: url)
        { data, _, _ in
        
        guard let data = data else {
            observer.onError(NSError(domain: "", code: -1, userInfo: nil))
            return
        }
            
            do {
                let stations = try JSONDecoder().decode([Station].self, from: data)
                observer.onNext(stations)
            } catch {
                observer.onError(error)
            }
        }
            task.resume()
            
            return Disposables.create {
                    task.cancel()
                }
            }
    }
    
    func fetchSensors(url: URL) -> Observable<[Sensor]> {
        
        return Observable.create { observer -> Disposable in
        
        let task = URLSession.shared.dataTask(with: url)
        { data, _, _ in
        
        guard let data = data else {
            observer.onError(NSError(domain: "", code: -1, userInfo: nil))
            return
        }
            
            do {
                let sensors = try JSONDecoder().decode([Sensor].self, from: data)
                observer.onNext(sensors)
            } catch {
                observer.onError(error)
            }
        }
            task.resume()
            
            return Disposables.create {
                    task.cancel()
                }
            }
    }
    
    func fetchData(url: URL) -> Observable<AirData> {
        
        return Observable.create { observer -> Disposable in
        
        let task = URLSession.shared.dataTask(with: url)
        { data, _, _ in
        
        guard let data = data else {
            observer.onError(NSError(domain: "", code: -1, userInfo: nil))
            return
        }
            
            do {
                let data = try JSONDecoder().decode(AirData.self, from: data)
                observer.onNext(data)
            } catch {
                observer.onError(error)
            }
        }
            task.resume()
            
            return Disposables.create {
                    task.cancel()
                }
            }
    }
    
    func fetchAirQualityIndex(url: URL) -> Observable<AirQualityIndex> {
        
        return Observable.create { observer -> Disposable in
        
        let task = URLSession.shared.dataTask(with: url)
        { data, _, _ in
        
        guard let data = data else {
            observer.onError(NSError(domain: "", code: -1, userInfo: nil))
            return
        }
            
            do {
                let data = try JSONDecoder().decode(AirQualityIndex.self, from: data)
                observer.onNext(data)
            } catch {
                observer.onError(error)
            }
        }
            task.resume()
            
            return Disposables.create {
                    task.cancel()
                }
            }
    }
    
    
}
