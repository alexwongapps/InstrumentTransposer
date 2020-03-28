//
//  ColorChangeViewController.swift
//  InstrumentTransposer
//
//  Created by Alex Wong on 8/9/18.
//  Copyright © 2018 Kids Can Code. All rights reserved.
//

import UIKit

class ColorChangeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let commonColors = [
        UIColor.red,
        UIColor.orange,
        UIColor.yellow,
        UIColor.green,
        UIColor.cyan,
        UIColor.magenta,
        UIColor.white,
        UIColor.lightGray
    ]
    
    var colorNames = [
        UIColor.red: "Red",
        UIColor.orange: "Orange",
        UIColor.yellow: "Yellow",
        UIColor.green: "Green",
        UIColor.cyan: "Blue",
        UIColor.magenta: "Magenta",
        UIColor.white: "White",
        UIColor.lightGray: "Gray"
    ]

    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var commonColorsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // localization
        
        switch Locale.current.languageCode {
        case "es":
            colorNames = [
                UIColor.red: "Rojo",
                UIColor.orange: "Anaranjado",
                UIColor.yellow: "Amarillo",
                UIColor.green: "Verde",
                UIColor.cyan: "Azul",
                UIColor.magenta: "Magenta",
                UIColor.white: "Blanco",
                UIColor.lightGray: "Gris"
            ]
        default:
            print("English")
        }
        
        // other
        
        let currentColor: UIColor?
        self.title = colorSenderText

        // Do any additional setup after loading the view.
        switch colorSender {
        case 0:
            currentColor = backgroundColor1
        case 1:
            currentColor = backgroundColor2
        case 2:
            currentColor = tableColor1
        case 3:
            currentColor = tableColor2
        default:
            currentColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
        }
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        currentColor?.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        redSlider.value = Float(r)
        greenSlider.value = Float(g)
        blueSlider.value = Float(b)
        self.view.backgroundColor = currentColor
    
        self.commonColorsTableView.layer.cornerRadius = 10
        self.commonColorsTableView.layer.masksToBounds = true
    }
    
    @IBAction func colorChanged(_ sender: Any) {
        self.view.backgroundColor = UIColor(red: CGFloat(redSlider.value), green: CGFloat(greenSlider.value), blue: CGFloat(blueSlider.value), alpha: 1)
    }

    @IBAction func setColor(_ sender: Any) {
        let r = CGFloat(redSlider.value)
        let g = CGFloat(greenSlider.value)
        let b = CGFloat(blueSlider.value)
        
        let newColor = UIColor(red: r, green: g, blue: b, alpha: 1)
        let defaults = UserDefaults.standard
        
        switch colorSender {
        case 0:
            backgroundColor1 = newColor
            defaults.set(Float(r), forKey: "b1r")
            defaults.set(Float(g), forKey: "b1g")
            defaults.set(Float(b), forKey: "b1b")
        case 1:
            backgroundColor2 = newColor
            defaults.set(Float(r), forKey: "b2r")
            defaults.set(Float(g), forKey: "b2g")
            defaults.set(Float(b), forKey: "b2b")
        case 2:
            tableColor1 = newColor
            defaults.set(Float(r), forKey: "t1r")
            defaults.set(Float(g), forKey: "t1g")
            defaults.set(Float(b), forKey: "t1b")
        case 3:
            tableColor2 = newColor
            defaults.set(Float(r), forKey: "t2r")
            defaults.set(Float(g), forKey: "t2g")
            defaults.set(Float(b), forKey: "t2b")
        default:
            print("No color")
        }
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    // MARK: table view
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commonColors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "colorCell")
        cell.textLabel?.text = colorNames[commonColors[indexPath.row]]
        cell.textLabel?.font = UIFont(name: appFont, size: 17)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newColor = commonColors[indexPath.row]
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        newColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        redSlider.value = Float(r)
        greenSlider.value = Float(g)
        blueSlider.value = Float(b)
        
        self.view.backgroundColor = newColor
    }
}
