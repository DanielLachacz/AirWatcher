//
//  ChartView.swift
//  AirWatcher
//
//  Created by Daniel Łachacz on 25/02/2021.
//  Copyright © 2021 Daniel Łachacz. All rights reserved.
//

import UIKit

class ChartView: UIView {
    
    private let mainLayer: CALayer = CALayer()
    private let stackView: UIView = UIView()
    
    
    let space: CGFloat = 15.0
    let barHeight: CGFloat = 15.0
    //let contentSpace: CGFloat = 70.0
    
    var dataEntries: [FavoriteData] = [] {
        
    
    didSet {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: 8).isActive = true
        stackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: 50).isActive = true
        //stackView.layer.addSublayer(mainLayer)
        //mainLayer.sublayers?.forEach({$0.removeFromSuperlayer()})
       // mainLayer.frame = stackView.bounds
        stackView.layoutIfNeeded()
        print("stackView width: \(stackView.bounds)")

       // stackView.sizeThatFits(CGSize(width: frame.size.width, height: barHeight + space * CGFloat(dataEntries.count) + contentSpace))
        mainLayer.frame = CGRect(x: 0, y: 0, width: stackView.bounds.width.rounded(), height: stackView.intrinsicContentSize.height)
        
       // print("data: \(dataEntries.compactMap{$0.values.first}.map{$0.value})")
        let entries = dataEntries.compactMap{$0.values.first}.map{$0.value}
        
        //tutaj trzeba powalczyc zeby pozbyc sie pustych paskow
        for i in 0..<dataEntries.count {
       // print("entries: \(entries)")
         //   print("i: \(i)")
        showEntry(index: i, data: dataEntries[i])
       }
     }
    }
    
    override init(frame: CGRect) {
       super.init(frame: frame)
       setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
       stackView.layer.addSublayer(mainLayer)
       addSubview(stackView)
    }
    
    override func layoutSubviews() {
       stackView.frame = CGRect(x: 0, y: 0, width: frame.size.width,
       height: frame.size.height)
    }
    
    private func showEntry(index: Int, data: FavoriteData) {
        if data.values.first?.value ?? 0.0 > 0.0 {
            let xPos: CGFloat = translateWidthValueToXPosition(value: Float(data.values.first?.value ?? 0.0) / Float(100.0)) // długość paska
            let yPos: CGFloat = space + CGFloat(index) * (barHeight + space)
            let value = data.values.first?.value ?? 0.0 //pokombinuj z wartoscia ponad 100, to moze ustawic maksymalna dlugosc paska
            drawBar(xPos: xPos, yPos: yPos, key: data.key, value: data.values.first?.value ?? 0.0)
            let roundedValue = (value * 100).rounded() / 100
            drawTextValue(xPos: xPos + 30.0, yPos: yPos + 4.0, textValue: "\(roundedValue)") //pozycja wartosci na pasku
            drawTitle(xPos: 16.0, yPos: yPos + 2.0, width: 80.0, height: 40.0, title: data.key)
        }
    }
    
    private func drawBar(xPos: CGFloat, yPos: CGFloat, key: String, value: Double) {
        let barLayer = CALayer()
        barLayer.frame = CGRect(x: 65.0, y: yPos, width: xPos, height: 20.0)
       // barLayer.frame = CGRect(x: 65.0, y: yPos, width: xPos, height: 20.0) //zainteresowac sie width
        //colors
        let green = UIColor(red: 52/255, green: 220/255, blue: 89/255, alpha: 1.0)
        let brightGreen = UIColor(red: 173/255, green: 255/255, blue:47/255, alpha: 1.0)
        let yellow = UIColor(red: 255/255, green: 204/255, blue: 0/255, alpha: 1.0)
        let orange = UIColor(red: 255/255, green: 149/255, blue: 0/255, alpha: 1.0)
        let red = UIColor(red: 255/255, green: 59/255, blue: 48/255, alpha: 1.0)
        let darkRed = UIColor(red: 153/255, green: 0/255, blue: 0/255, alpha: 1.0)
        var color: CGColor?
        
        if key == "PM10" {
            if value <= 20 {
                color = green.cgColor
            }
            else if value <= 50 {
                color = brightGreen.cgColor
            }
            else if value <= 80 {
                color = yellow.cgColor
            }
            else if value <= 110 {
                color = orange.cgColor
            }
            else if value <= 150 {
                color = red.cgColor
            }
            else if value > 150 {
                color = darkRed.cgColor
            }
        }
        else if key == "PM2.5" {
            if value <= 13 {
                color = green.cgColor
            }
            else if value <= 35 {
                color = brightGreen.cgColor
            }
            else if value <= 55 {
                color = yellow.cgColor
            }
            else if value <= 75 {
                color = orange.cgColor
            }
            else if value <= 110 {
                color = red.cgColor
            }
            else if value > 110 {
                color = darkRed.cgColor
            }
        }
        else if key == "O3" {
            if value <= 70 {
                color = green.cgColor
            }
            else if value <= 120 {
                color = brightGreen.cgColor
            }
            else if value <= 150 {
                color = yellow.cgColor
            }
            else if value <= 180 {
                color = orange.cgColor
            }
            else if value <= 240 {
                color = red.cgColor
            }
            else if value > 240 {
                color = darkRed.cgColor
            }
        }
        else if key == "NO2" {
            if value <= 40 {
                color = green.cgColor
            }
            else if value <= 100 {
                color = brightGreen.cgColor
            }
            else if value <= 150 {
                color = yellow.cgColor
            }
            else if value <= 200 {
                color = orange.cgColor
            }
            else if value <= 400 {
                color = red.cgColor
            }
            else if value > 400 {
                color = darkRed.cgColor
            }
            
        }
        else if key == "SO2" {
            if value <= 50 {
                color = green.cgColor
            }
            if value <= 100 {
                color = brightGreen.cgColor
            }
            if value <= 200 {
                color = yellow.cgColor
            }
            if value <= 350 {
                color = orange.cgColor
            }
            if value <= 500 {
                color = red.cgColor
            }
            if value > 400 {
                color = darkRed.cgColor
            }
        }
        else if key == "C6H6" {
            if value <= 6 {
                color = green.cgColor
            }
            if value <= 11 {
                color = brightGreen.cgColor
            }
            if value <= 16 {
                color = yellow.cgColor
            }
            if value <= 21 {
                color = orange.cgColor
            }
            if value <= 51 {
                color = red.cgColor
            }
            if value > 51 {
                color = darkRed.cgColor
            }
        }
        else if key == "CO" {
            if value <= 3 {
                color = green.cgColor
            }
            if value <= 7 {
                color = brightGreen.cgColor
            }
            if value <= 11 {
                color = yellow.cgColor
            }
            if value <= 15 {
                color = orange.cgColor
            }
            if value <= 21 {
                color = red.cgColor
            }
            if value > 21 {
                color = darkRed.cgColor
            }
        }
        
        barLayer.backgroundColor = color //kolor paska
        mainLayer.addSublayer(barLayer)
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
       // CTFontCreateUIFontForLanguage(.label, 15 as CGFloat, CFString)
       textLayer.fontSize = 15
       textLayer.string = title
       mainLayer.addSublayer(textLayer)
    }
    
    private func translateWidthValueToXPosition(value: Float) -> CGFloat
    {
        //print("value: \(value)")
        var width = CGFloat()
        if value > 1 {
            width = CGFloat(1) * (mainLayer.frame.width - space)
           // print("value > 100: \(value)")
        }
        else {
             width = CGFloat(value) * (mainLayer.frame.width - space)
           // print("value < 100: \(value)")
        }
        
        return abs(width)
    }
}
