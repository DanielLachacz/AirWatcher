//
//  FavoriteTableViewCell.swift
//  AirWatcher
//
//  Created by Daniel Łachacz on 15/11/2020.
//  Copyright © 2020 Daniel Łachacz. All rights reserved.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var dataView: UIView!
    
    private let mainLayer: CALayer = CALayer()
    let space: CGFloat = 15.0
    let barHeight: CGFloat = 15.0
    var valueList: [Double] = []
    
    var dataEntries: [FavoriteData] = [] {
        didSet {
            setLayersAndAnchors()
            addShadow()

            for i in 0..<dataEntries.count {
                showEntry(index: i, data: dataEntries[i])
        }
            
        }
    }
    
    var cellStation : FavoriteItem! {
            didSet {
                contentView.addSubview(dataView)
                dataView.frame = contentView.frame
                setupView()
                setFavoriteData()
            }
    }
    
    func addShadow() {
        dataView.layer.shadowColor = UIColor.black.cgColor
        dataView.layer.shadowOffset = CGSize.zero
        dataView.layer.shadowOpacity = 1
        dataView.layer.shadowRadius = 1
        dataView.layer.masksToBounds = false
        dataView.layer.shouldRasterize = true
        dataView.layer.rasterizationScale = UIScreen.main.scale
    }
    
    func setLayersAndAnchors() {
        mainLayer.sublayers?.forEach({$0.removeFromSuperlayer()})
        dataView.translatesAutoresizingMaskIntoConstraints = false
        dataView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        dataView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        dataView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 60).isActive = true
        dataView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        mainLayer.frame = dataView.bounds
    }
        
    private func setFavoriteData() {
        self.streetLabel.text = cellStation?.addressStreet ?? ""
        self.cityLabel.text = cellStation?.cityName ?? ""
        
        dataEntries =
        cellStation.sensors.compactMap{$0.data}
        dataEntries.removeAll{$0.values.first?.value == 0.0}
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupView() {
       dataView.layer.addSublayer(mainLayer)
       addSubview(dataView)
        dataView.clipsToBounds = true
    }
    
    override func layoutSubviews() {
       dataView.frame = CGRect(x: 0, y: 0, width: frame.size.width,
       height: frame.size.height)
    }
    
    private func showEntry(index: Int, data: FavoriteData) {
        let value = data.values.first?.value ?? 0.0
        
        let frameWidth = frame.size.width
        let frameWidthDevided = frameWidth / 3.3
        
        var xPos = CGFloat()
        
        if value <= 100.0 {
            xPos = translateWidthValueToXPosition(value: Float(value) / Float(frameWidthDevided))
        }
        else if value > 100.0 {
            xPos = translateWidthValueToXPosition(value: Float(100) / Float(frameWidthDevided))
        }
        
        let xPosMax: CGFloat = translateWidthValueToXPosition(value: Float(100) / Float(frameWidthDevided))
        let yPos: CGFloat = space + CGFloat(index) * (barHeight + space)
        drawBar(xPos: xPos, xPosMax: xPosMax, yPos: yPos, key: data.key, value: value)
        let roundedValue = (value * 100).rounded() / 100 //round to two decimal places
        drawTextValue(xPos: xPosMax + 17.0, yPos: yPos + 4.0, textValue: "\(roundedValue)")
        drawTitle(xPos: 3.0, yPos: yPos + 2.0, width: 80.0, height: 40.0, title: data.key)
    }
    
    private func drawBar(xPos: CGFloat, xPosMax: CGFloat, yPos: CGFloat, key: String, value: Double) {
        let barLayer = CALayer()
        let barLayer2 = CALayer()
        barLayer.frame = CGRect(x: 50.0, y: yPos, width: xPosMax, height: 20.0)
        barLayer2.frame = CGRect(x: 50.0, y: yPos, width: xPos, height: 20.0)
        //colors
        let green = UIColor(red: 52/255, green: 220/255, blue: 89/255, alpha: 1.0)
        let lime = UIColor(red: 173/255, green: 255/255, blue:47/255, alpha: 1.0)
        let yellow = UIColor(red: 255/255, green: 204/255, blue: 0/255, alpha: 1.0)
        let orange = UIColor(red: 255/255, green: 149/255, blue: 0/255, alpha: 1.0)
        let red = UIColor(red: 255/255, green: 59/255, blue: 48/255, alpha: 1.0)
        let darkRed = UIColor(red: 153/255, green: 0/255, blue: 0/255, alpha: 1.0)
        let brightGreen = UIColor(red: 204/255, green: 255/255, blue: 204/255, alpha: 1.0)
        let brightLime = UIColor(red: 229/255, green: 255/255, blue:204/255, alpha: 1.0)
        let brightYellow = UIColor(red: 255/255, green: 255/255, blue: 204/255, alpha: 1.0)
        let brightOrange = UIColor(red: 255/255, green: 229/255, blue: 204/255, alpha: 1.0)
        let brightRed = UIColor(red: 255/255, green: 204/255, blue: 204/255, alpha: 1.0)
        let brightDarkRed = UIColor(red: 153/255, green: 133/255, blue: 153/255, alpha: 1.0)
        
        var color: CGColor?
        var color2: CGColor?
        switch key {
        case "PM10":
            switch value {
            case 0...20:
                color = brightGreen.cgColor
                color2 = green.cgColor
            
            case 20.1...50:
                color = brightLime.cgColor
                color2 = lime.cgColor
            
            case 50.1...80:
                color = brightYellow.cgColor
                color2 = yellow.cgColor
            
            case 80.1...110:
                color = brightOrange.cgColor
                color2 = orange.cgColor
            
            case 110.1...150:
                color = brightRed.cgColor
                color2 = red.cgColor
            
           default:
                color = brightDarkRed.cgColor
                color2 = darkRed.cgColor
            
            }
    
        case "PM2.5":
            switch value {
            case 0...13:
                color = brightGreen.cgColor
                color2 = green.cgColor
            
                case 13.1...35:
                color = brightLime.cgColor
                color2 = lime.cgColor
            
                case 35.1...55:
                color = brightYellow.cgColor
                color2 = yellow.cgColor
            
                case 55.1...75:
                color = brightOrange.cgColor
                color2 = orange.cgColor
            
                case 75.1...110:
                color = brightRed.cgColor
                color2 = red.cgColor
            
                default:
                color = brightDarkRed.cgColor
                color2 = darkRed.cgColor
            
            }
        
        case "O3":
            switch value {
            case 0...70:
                color = brightGreen.cgColor
                color2 = green.cgColor
            
            case 70.1...120:
                color = brightLime.cgColor
                color2 = lime.cgColor
            
            case 120.1...150:
                color = brightYellow.cgColor
                color2 = yellow.cgColor
            
            case 150.1...180:
                color = brightOrange.cgColor
                color2 = orange.cgColor
            
            case 180.1...240:
                color = brightRed.cgColor
                color2 = red.cgColor
            
            default:
                color = brightDarkRed.cgColor
                color2 = darkRed.cgColor
            }
        
        case "NO2":
            switch value {
            case 0...40:
                color = brightGreen.cgColor
                color2 = green.cgColor
            
            case 40.1...100:
                color = brightLime.cgColor
                color2 = lime.cgColor
            
            case 100.1...150:
                color = brightYellow.cgColor
                color2 = yellow.cgColor
            
            case 150.1...200:
                color = brightOrange.cgColor
                color2 = orange.cgColor
            
            case 200.1...400:
                color = brightRed.cgColor
                color2 = red.cgColor
            
            default:
                color = brightDarkRed.cgColor
                color2 = darkRed.cgColor
        }
        case "SO2":
            switch value {
            case 0...50:
                color = brightGreen.cgColor
                color2 = green.cgColor
            
            case 50.1...100:
                color = brightLime.cgColor
                color2 = lime.cgColor
            
            case 100.1...200:
                color = brightYellow.cgColor
                color2 = yellow.cgColor
            
            case 200.1...350:
                color = brightOrange.cgColor
                color2 = orange.cgColor
            
            case 350.1...500:
               color = brightRed.cgColor
               color2 = red.cgColor
            
            default:
                color = brightDarkRed.cgColor
                color2 = darkRed.cgColor
        }
        case "C6H6":
            switch value {
            case 0...6.00:
                color = brightGreen.cgColor
                color2 = green.cgColor
            
            case 6.1...11:
                color = brightLime.cgColor
                color2 = lime.cgColor
            
            case 11.1...16:
                color = brightYellow.cgColor
                color2 = yellow.cgColor
            
            case 16.1...21:
                color = brightOrange.cgColor
                color2 = orange.cgColor
            
            case 21.1...51:
                color = brightRed.cgColor
                color2 = red.cgColor
            
            default:
               color = brightDarkRed.cgColor
                color2 = darkRed.cgColor
        }
        case "CO":
            switch value {
            case 0...3:
                color = brightGreen.cgColor
                color2 = green.cgColor
            
            case 3.1...7:
                color = brightLime.cgColor
                color2 = lime.cgColor
            
            case 7.1...11:
                color = brightYellow.cgColor
                color2 = yellow.cgColor
            
            case 11.1...15:
                color = brightOrange.cgColor
                color2 = orange.cgColor
            
            case 15.1...21:
                color = brightRed.cgColor
                color2 = red.cgColor
            
            default:
                color = brightDarkRed.cgColor
                color2 = darkRed.cgColor
            }
        
        default:
        print("default value color")
        }
        
        
        barLayer.backgroundColor = color
        barLayer2.backgroundColor = color2
        mainLayer.addSublayer(barLayer)
        mainLayer.addSublayer(barLayer2)
    }
    
    private func drawTextValue(xPos: CGFloat, yPos: CGFloat, textValue: String) {
       let textLayer = CATextLayer()
       textLayer.frame = CGRect(x: xPos, y: yPos, width: 33, height: 70.0)
       textLayer.foregroundColor = UIColor.black.cgColor
       textLayer.backgroundColor = UIColor.clear.cgColor
       textLayer.alignmentMode = CATextLayerAlignmentMode.center
       textLayer.contentsScale = UIScreen.main.scale
       textLayer.font = CTFontCreateWithName(UIFont.systemFont(ofSize: 14.0).fontName as CFString, 0, nil)
       textLayer.fontSize = 15
       textLayer.string = textValue
       mainLayer.addSublayer(textLayer)
    }
    
    private func drawTitle(xPos: CGFloat, yPos: CGFloat, width: CGFloat, height: CGFloat, title: String) {
       let textLayer = CATextLayer()
       textLayer.frame = CGRect(x: xPos, y: yPos, width: width, height: height)
       textLayer.foregroundColor = UIColor.black.cgColor
       textLayer.backgroundColor = UIColor.clear.cgColor
       textLayer.alignmentMode = CATextLayerAlignmentMode.left
       textLayer.contentsScale = UIScreen.main.scale
       textLayer.font = CTFontCreateWithName(UIFont.boldSystemFont(ofSize: 15.0).fontName as CFString, 0, nil)
       textLayer.fontSize = 15
       textLayer.string = title
       mainLayer.addSublayer(textLayer)
    }
    
    private func translateWidthValueToXPosition(value: Float) -> CGFloat
    {
        let width = CGFloat(value) * (mainLayer.frame.width - space)
    
        return abs(width)
    }

}
