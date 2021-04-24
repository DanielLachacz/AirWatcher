//
//  AddTableViewCell.swift
//  AirWatcher
//
//  Created by Daniel Łachacz on 02/12/2020.
//  Copyright © 2020 Daniel Łachacz. All rights reserved.
//

import UIKit
import RealmSwift

class AddTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var parameterLabel: UILabel!
    @IBOutlet weak var starImageView: UIImageView!
    let falseValue = RealmOptional<Bool>(false)
    let trueValue = RealmOptional<Bool>(true)
    
    
    var cellAdd : AddItem! {
        didSet {
            setData()
        }
    }
    
    private func setData() {
        self.cityLabel.text = cellAdd?.cityName ?? ""
        self.streetLabel.text = cellAdd?.addressStreet ?? ""
        let array = cellAdd?.sensors.map({(sensorItem: SensorItem) -> String in
            (sensorItem.param?.paramCode) ?? ""}).joined(separator: ", ")
        self.parameterLabel.text = String(describing: array!)
        if cellAdd?.added.value == false {
            self.starImageView.isHidden = true
        } else {
            self.starImageView.isHidden = false
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
