//
//  InstrumentViewController.swift
//  InstrumentTransposer
//
//  Created by Alex Wong on 8/9/18.
//  Copyright © 2018 Kids Can Code. All rights reserved.
//

import UIKit
import StoreKit

let appFont = "Bodoni 72"

var backgroundColor1 = UIColor(red: 170 / 255, green: 240 / 255, blue: 220 / 255, alpha: 1)
var backgroundColor2 = UIColor(red: 179 / 255, green: 255 / 255, blue: 179 / 255, alpha: 1)
var tableColor1 = UIColor(red: 255 / 255, green: 180 / 255, blue: 180 / 255, alpha: 1)
var tableColor2 = UIColor(red: 255 / 255, green: 220 / 255, blue: 220 / 255, alpha: 1)

enum Key: Int, CustomStringConvertible {
    case c = 0, d_flat, d, e_flat, e, f, g_flat, g, a_flat, a, b_flat, b

    var description: String {
        switch self {
            
        case .c: return "C"
        case .d_flat: return "D♭"
        case .d: return "D"
        case .e_flat: return "E♭"
        case .e: return "E"
        case .f: return "F"
        case .g_flat: return "G♭"
        case .g: return "G"
        case .a_flat: return "A♭"
        case .a: return "A"
        case .b_flat: return "B♭"
        case .b: return "B"
        }
    }
}

var coreInstruments: [Instrument] = [
    Instrument(name: "Piano", key: .c),
    Instrument(name: "Guitar", key: .c),
    Instrument(name: "Violin", key: .c),
    Instrument(name: "Viola", key: .c),
    Instrument(name: "Cello", key: .c),
    Instrument(name: "Double Bass", key: .c),
    Instrument(name: "Piccolo", key: .c),
    Instrument(name: "Flute", key: .c),
    Instrument(name: "Clarinet", key: .e_flat),
    Instrument(name: "Clarinet", key: .b_flat),
    Instrument(name: "Oboe", key: .c),
    Instrument(name: "English Horn", key: .f),
    Instrument(name: "Bassoon", key: .c),
    Instrument(name: "Alto Sax", key: .e_flat),
    Instrument(name: "Tenor Sax", key: .b_flat),
    Instrument(name: "French Horn", key: .f),
    Instrument(name: "French Horn", key: .e_flat),
    Instrument(name: "French Horn", key: .d),
    Instrument(name: "Mellophone", key: .f),
    Instrument(name: "Trumpet", key: .c),
    Instrument(name: "Trumpet", key: .b_flat),
    Instrument(name: "Cornet", key: .b_flat),
    Instrument(name: "Trombone", key: .c),
    Instrument(name: "Tuba", key: .c),
    Instrument(name: "Tuba", key: .e_flat),
    Instrument(name: "Tuba", key: .f),
    Instrument(name: "Tuba", key: .b_flat),
    Instrument(name: "Baritone", key: .b_flat),
    Instrument(name: "Euphonium", key: .b_flat)
]

let notes = ["C", "C♯/D♭", "D", "D♯/E♭", "E", "F", "F♯/G♭", "G", "G♯/A♭", "A", "A♯/B♭", "B"]

class InstrumentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var gradientLayer: CAGradientLayer!
    
    var instruments: [Instrument] = []
    
    var fromInstrument: Instrument?
    var toInstrument: Instrument?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pickerViewsView: UIView!
    @IBOutlet weak var helpView: UIView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var fromPickerView: UIPickerView!
    @IBOutlet weak var toPickerView: UIPickerView!
    @IBOutlet weak var fromTableView: UITableView!
    @IBOutlet weak var toTableView: UITableView!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var favorite1Button: UIButton!
    @IBOutlet weak var favorite2Button: UIButton!
    @IBOutlet weak var favorite3Button: UIButton!
    
    var tableViewRuntimeHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        
        // get instruments in language
        
        switch Locale.current.languageCode {
        case "es":
            coreInstruments = [
                Instrument(name: "Piano", key: .c),
                Instrument(name: "Guitarra", key: .c),
                Instrument(name: "Violín", key: .c),
                Instrument(name: "Viola", key: .c),
                Instrument(name: "Violonchelo", key: .c),
                Instrument(name: "Contrabajo", key: .c),
                Instrument(name: "Flautín", key: .c),
                Instrument(name: "Flauta", key: .c),
                Instrument(name: "Clarinete", key: .e_flat),
                Instrument(name: "Clarinete", key: .b_flat),
                Instrument(name: "Oboe", key: .c),
                Instrument(name: "Corno inglés", key: .f),
                Instrument(name: "Fagot", key: .c),
                Instrument(name: "Saxo de alto", key: .e_flat),
                Instrument(name: "Saxo de tenor", key: .b_flat),
                Instrument(name: "Corno francés", key: .f),
                Instrument(name: "Corno francés", key: .e_flat),
                Instrument(name: "Corno francés", key: .d),
                Instrument(name: "Melófono", key: .f),
                Instrument(name: "Trompeta", key: .c),
                Instrument(name: "Trompeta", key: .b_flat),
                Instrument(name: "Corneta", key: .b_flat),
                Instrument(name: "Trombón", key: .c),
                Instrument(name: "Tuba", key: .c),
                Instrument(name: "Tuba", key: .e_flat),
                Instrument(name: "Tuba", key: .f),
                Instrument(name: "Tuba", key: .b_flat),
                Instrument(name: "Barítono", key: .b_flat),
                Instrument(name: "Eufonio", key: .b_flat)
            ]
        default:
            print("English")
        }
        
        // favorites
        
        favorite1Button.titleLabel?.adjustsFontSizeToFitWidth = true
        favorite2Button.titleLabel?.adjustsFontSizeToFitWidth = true
        favorite3Button.titleLabel?.adjustsFontSizeToFitWidth = true
        favorite1Button.titleLabel?.baselineAdjustment = .alignCenters
        favorite2Button.titleLabel?.baselineAdjustment = .alignCenters
        favorite3Button.titleLabel?.baselineAdjustment = .alignCenters
        
        // localization
        
        let titleText = NSLocalizedString("transposeByInstrument", comment: "Transpose by Instrument")
        let attributedText1 = NSMutableAttributedString(string: titleText)
        titleLabel!.attributedText = attributedText1
        makeAdjustableFont(label: titleLabel)
        
        let toText = NSLocalizedString("to", comment: "to")
        let attributedText2 = NSMutableAttributedString(string: toText)
        toLabel!.attributedText = attributedText2
        makeAdjustableFont(label: toLabel)
        
        // reviews
        
        let timesOpened = UserDefaults.standard.integer(forKey: "timesOpened") + 1
        UserDefaults.standard.set(timesOpened, forKey: "timesOpened")
        
        if !UserDefaults.standard.bool(forKey: "hasAskedForReview") {
            if timesOpened >= 5 {
                if #available(iOS 10.3, *) {
                    SKStoreReviewController.requestReview()
                    UserDefaults.standard.set(true, forKey: "hasAskedForReview")
                }
            }
        }
        
        // other
        
        instruments.removeAll()
        instruments.append(contentsOf: getCustomInstruments())
        instruments.append(contentsOf: coreInstruments)
        
        fromPickerView.reloadAllComponents()
        toPickerView.reloadAllComponents()
        
        fromTableView.reloadData()
        toTableView.reloadData()
        
        fromPickerView.selectRow(0, inComponent: 0, animated: true)
        toPickerView.selectRow(0, inComponent: 0, animated: true)
        
        fromInstrument = instruments[0]
        toInstrument = instruments[0]
        
        toLabel.font = UIFont(name: appFont, size: smallDevice() ? 17 : 25)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if !setBackground() {
            let defaults = UserDefaults.standard
            
            backgroundColor1 = UIColor(
                red: CGFloat(defaults.float(forKey: "b1r")),
                green: CGFloat(defaults.float(forKey: "b1g")),
                blue: CGFloat(defaults.float(forKey: "b1b")),
                alpha: 1)
            backgroundColor2 = UIColor(
                red: CGFloat(defaults.float(forKey: "b2r")),
                green: CGFloat(defaults.float(forKey: "b2g")),
                blue: CGFloat(defaults.float(forKey: "b2b")),
                alpha: 1)
            tableColor1 = UIColor(
                red: CGFloat(defaults.float(forKey: "t1r")),
                green: CGFloat(defaults.float(forKey: "t1g")),
                blue: CGFloat(defaults.float(forKey: "t1b")),
                alpha: 1)
            tableColor2 = UIColor(
                red: CGFloat(defaults.float(forKey: "t2r")),
                green: CGFloat(defaults.float(forKey: "t2g")),
                blue: CGFloat(defaults.float(forKey: "t2b")),
                alpha: 1)
        }
        
        instruments.removeAll()
        instruments.append(contentsOf: getCustomInstruments())
        instruments.append(contentsOf: coreInstruments)
        
        fromPickerView.reloadAllComponents()
        toPickerView.reloadAllComponents()
        
        fromInstrument = instruments[fromPickerView.selectedRow(inComponent: 0)]
        toInstrument = instruments[toPickerView.selectedRow(inComponent: 0)]
        
        fromTableView.reloadData()
        toTableView.reloadData()
        
        updateFavorites()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        createGradientLayer(view: gradientView)
        
        let defaults = UserDefaults.standard
        if firstLaunch() {
            
            var r: CGFloat = 0
            var g: CGFloat = 0
            var b: CGFloat = 0
            var a: CGFloat = 0
            
            backgroundColor1.getRed(&r, green: &g, blue: &b, alpha: &a)
            defaults.set(Float(r), forKey: "b1r")
            defaults.set(Float(g), forKey: "b1g")
            defaults.set(Float(b), forKey: "b1b")
            
            backgroundColor2.getRed(&r, green: &g, blue: &b, alpha: &a)
            defaults.set(Float(r), forKey: "b2r")
            defaults.set(Float(g), forKey: "b2g")
            defaults.set(Float(b), forKey: "b2b")
            
            tableColor1.getRed(&r, green: &g, blue: &b, alpha: &a)
            defaults.set(Float(r), forKey: "t1r")
            defaults.set(Float(g), forKey: "t1g")
            defaults.set(Float(b), forKey: "t1b")
            
            tableColor2.getRed(&r, green: &g, blue: &b, alpha: &a)
            defaults.set(Float(r), forKey: "t2r")
            defaults.set(Float(g), forKey: "t2g")
            defaults.set(Float(b), forKey: "t2b")
            
            createHole(inView: helpView, aroundView: pickerViewsView)
            helpView.isHidden = false
            
            defaults.set("", forKey: "customInstrumentNames")
            defaults.set("", forKey: "customInstrumentKeys")
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableViewRuntimeHeight = fromTableView.frame.height
    }
    
    // MARK: help view
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !helpView.isHidden {
            helpView.isHidden = true
        }
    }
    
    // MARK: picker view
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return instruments.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView.tag == 0 { // from
            fromInstrument = instruments[row]
        } else {
            toInstrument = instruments[row]
        }
        fromTableView.reloadData()
        toTableView.reloadData()
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: appFont, size: hasTraits(view: self.view, width: .regular, height: .regular) ? 20 : 17)
            pickerLabel?.textAlignment = .center
            makeAdjustableFont(label: pickerLabel!)
        }
        pickerLabel?.text = instruments[row].description
        
        return pickerLabel!
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return hasTraits(view: self.view, width: .regular, height: .regular) ? 30 : 25
    }
    
    // MARK: table view
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell?
        
        if tableView.tag == 0 { // from
            cell = UITableViewCell(style: .default, reuseIdentifier: "instrumentFromCell")
            cell?.textLabel?.text = notes[(indexPath.row + 12 - (fromInstrument?.key.rawValue)!) % notes.count]
        } else { // to
            cell = UITableViewCell(style: .default, reuseIdentifier: "instrumentToCell")
            cell?.textLabel?.text = notes[(indexPath.row + 12 - (toInstrument?.key.rawValue)!) % notes.count]
        }
        
        if indexPath.row % 2 == 0 {
            cell?.backgroundColor = tableColor1
        } else {
            cell?.backgroundColor = tableColor2
        }
        
        cell?.textLabel?.font = UIFont(name: appFont, size: smallDevice() ? 15 : hasTraits(view: self.view, width: .regular, height: .regular) ? 25 : 17)
        cell?.textLabel?.textAlignment = .center
        return cell!
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.tag == 0 { // from
            toTableView.contentOffset = scrollView.contentOffset
        } else {
            fromTableView.contentOffset = scrollView.contentOffset
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableViewRuntimeHeight / CGFloat(notes.count)
    }
    
    // MARK: view
    
    func createGradientLayer(view: UIView) {
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [backgroundColor1.cgColor, backgroundColor2.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        view.layer.addSublayer(gradientLayer)
    }
    
    func createHole(inView: UIView, aroundView: UIView) {
        let path = CGMutablePath()
        path.addRect(CGRect(x: aroundView.frame.origin.x, y: aroundView.frame.origin.y, width: aroundView.frame.width, height: aroundView.frame.height))
        path.addRect(CGRect(origin: .zero, size: inView.frame.size))
        
        let maskLayer = CAShapeLayer()
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.path = path
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        
        inView.layer.mask = maskLayer
        inView.clipsToBounds = true
    }
    
    func firstLaunch() -> Bool {
        let alreadyLaunched = UserDefaults.standard.bool(forKey: "alreadyLaunched")
        if alreadyLaunched {
            return false
        } else {
            UserDefaults.standard.set(true, forKey: "alreadyLaunched")
            return true
        }
    }
    
    func setBackground() -> Bool {
        let alreadyLaunched = UserDefaults.standard.bool(forKey: "setBackground")
        if alreadyLaunched {
            return false
        } else {
            UserDefaults.standard.set(true, forKey: "setBackground")
            return true
        }
    }
    
    // MARK: favorites
    
    func getFavorites() -> [String] {
        return [UserDefaults.standard.string(forKey: "instrument1From")!,
                UserDefaults.standard.string(forKey: "instrument1To")!,
                UserDefaults.standard.string(forKey: "instrument2From")!,
                UserDefaults.standard.string(forKey: "instrument2To")!,
                UserDefaults.standard.string(forKey: "instrument3From")!,
                UserDefaults.standard.string(forKey: "instrument3To")!]
    }
    
    func updateFavorites() {
        let favorites = getFavorites()
        if favorites[0] != "" && favorites[1] != "" {
            favorite1Button.setTitle("\(favorites[0]) to \(favorites[1])", for: .normal)
            favorite1Button.setTitle("\(favorites[0]) to \(favorites[1])", for: .selected)
        } else {
            favorite1Button.setTitle("Save Favorite", for: .normal)
            favorite1Button.setTitle("Save Favorite", for: .selected)
        }
        if favorites[2] != "" && favorites[3] != "" {
            favorite2Button.setTitle("\(favorites[2]) to \(favorites[3])", for: .normal)
            favorite2Button.setTitle("\(favorites[2]) to \(favorites[3])", for: .selected)
        } else {
            favorite2Button.setTitle("Save Favorite", for: .normal)
            favorite2Button.setTitle("Save Favorite", for: .selected)
        }
        if favorites[4] != "" && favorites[5] != "" {
            favorite3Button.setTitle("\(favorites[4]) to \(favorites[5])", for: .normal)
            favorite3Button.setTitle("\(favorites[4]) to \(favorites[5])", for: .selected)
        } else {
            favorite3Button.setTitle("Save Favorite", for: .normal)
            favorite3Button.setTitle("Save Favorite", for: .selected)
        }
    }
    
    @IBAction func saveFavorite(_ sender: UIButton) {
        if sender.titleLabel?.text == "Save Favorite" {
            if !proPaid {
                self.present(createBasicAlert(title: "PRO Feature", message: "Purchase PRO from the Settings tab to save favorites!"), animated: true)
            } else {
                UserDefaults.standard.set(instruments[fromPickerView.selectedRow(inComponent: 0)].description, forKey: "instrument\(sender.tag + 1)From")
                UserDefaults.standard.set(instruments[toPickerView.selectedRow(inComponent: 0)].description, forKey: "instrument\(sender.tag + 1)To")
                updateFavorites()
            }
        } else {
            let from = instruments.firstIndex { $0.description == UserDefaults.standard.string(forKey: "instrument\(sender.tag + 1)From")! }
            let to = instruments.firstIndex { $0.description == UserDefaults.standard.string(forKey: "instrument\(sender.tag + 1)To")! }
            fromPickerView.selectRow(from!, inComponent: 0, animated: true)
            toPickerView.selectRow(to!, inComponent: 0, animated: true)
            fromInstrument = instruments[from!]
            toInstrument = instruments[to!]
            fromTableView.reloadData()
            toTableView.reloadData()
        }
    }
    
    // defaults
    
    func getCustomInstruments() -> [Instrument] {
        let defaults = UserDefaults.standard
        
        let names = defaults.string(forKey: "customInstrumentNames")
        let keys = defaults.string(forKey: "customInstrumentKeys")
        
        let nameArray = names?.components(separatedBy: "\n")
        let keyArray = keys?.components(separatedBy: "\n")
        
        var ret: [Instrument] = []
        
        if(names != nil && names != "") {
            for i in 0..<nameArray!.count {
                var key: Key = Key.c // tmp value
                
                switch(keyArray![i]) {
                    
                case "C": key = Key.c; break
                case "D♭": key = Key.d_flat; break
                case "D": key = Key.d; break
                case "E♭": key = Key.e_flat; break
                case "E": key = Key.e; break
                case "F": key = Key.f; break
                case "G♭": key = Key.g_flat; break
                case "G": key = Key.g; break
                case "A♭": key = Key.a_flat; break
                case "A": key = Key.a; break
                case "B♭": key = Key.b_flat; break
                case "B": key = Key.b; break
                default: key = Key.c; break
                    
                }
                
                ret.append(Instrument(name: nameArray![i], key: key))
            }
        } else {
            ret = []
        }
        
        return ret
    }
}

class Instrument: CustomStringConvertible {
    var name: String
    var key: Key
    
    init(name: String, key: Key) {
        self.name = name
        self.key = key
    }
    
    var description: String {
        return "\(name) (\(key))"
    }
}

func makeAdjustableFont(label: UILabel) {
    label.numberOfLines = 1
    label.adjustsFontSizeToFitWidth = true
    label.lineBreakMode = .byClipping
}

// MARK: hardware

// iphone se, 5, etc
func smallDevice() -> Bool {
    if UIDevice().userInterfaceIdiom == .phone {
        if UIScreen.main.nativeBounds.height <= 1136 { // iphone 5, 5s, 5c, se
            return true
        } else if UIScreen.main.nativeBounds.size.height == 1334 && UIScreen.main.nativeScale > UIScreen.main.scale { // zoomed iphone 6/6s/7/8
            return true
        }
    }
    return false
}

func hasTraits(view: UIView, width: UIUserInterfaceSizeClass, height: UIUserInterfaceSizeClass) -> Bool {
    return view.traitCollection.horizontalSizeClass == width && view.traitCollection.verticalSizeClass == height
}
