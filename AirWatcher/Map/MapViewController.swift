//
//  MapViewController.swift
//  AirWatcher
//
//  Created by Daniel Łachacz on 25/02/2021.
//  Copyright © 2021 Daniel Łachacz. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {
    
    lazy var chartView: ChartView = {
       let chartView = ChartView()
       chartView.frame = view.frame
       return chartView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
//       chartView.dataEntries =
//           [
//              BarEntry(score: 45, title: "Stark"),
//              BarEntry(score: 35, title: "Thor"),
//              BarEntry(score: 55, title: "Evans"),
//              BarEntry(score: 3, title: "Vision"),
//              BarEntry(score: 10, title: "Thanos"),
//              BarEntry(score: 100, title: "Boczek")
//           ]
//        view.addSubview(chartView)
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
