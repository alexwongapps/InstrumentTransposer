//
//  SecondViewController.swift
//  InstrumentTransposer
//
//  Created by Alex Wong on 8/9/18.
//  Copyright © 2018 Kids Can Code. All rights reserved.
//

import UIKit

class KeyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var gradientLayer: CAGradientLayer!
    
    var fromKey: Key?
    var toKey: Key?

    @IBOutlet weak var titleLabel: UILabel!
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
        
        // localization
        
        let titleText = NSLocalizedString("transposeByKey", comment: "Transpose by Key")
        let attributedText1 = NSMutableAttributedString(string: titleText)
        titleLabel!.attributedText = attributedText1
        makeAdjustableFont(label: titleLabel)
        
        let toText = NSLocalizedString("to", comment: "to")
        let attributedText2 = NSMutableAttributedString(string: toText)
        toLabel!.attributedText = attributedText2
        makeAdjustableFont(label: toLabel)
        
        // favorites
        
        favorite1Button.titleLabel?.adjustsFontSizeToFitWidth = true
        favorite2Button.titleLabel?.adjustsFontSizeToFitWidth = true
        favorite3Button.titleLabel?.adjustsFontSizeToFitWidth = true
        favorite1Button.titleLabel?.baselineAdjustment = .alignCenters
        favorite2Button.titleLabel?.baselineAdjustment = .alignCenters
        favorite3Button.titleLabel?.baselineAdjustment = .alignCenters
        
        // other
        
        fromPickerView.selectRow(0, inComponent: 0, animated: true)
        toPickerView.selectRow(0, inComponent: 0, animated: true)
        
        fromKey = Key(rawValue: 0)
        toKey = Key(rawValue: 0)
        
        toLabel.font = UIFont(name: appFont, size: smallDevice() ? 17 : 25)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
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
        
        fromTableView.reloadData()
        toTableView.reloadData()
        
        updateFavorites()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        createGradientLayer(view: gradientView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableViewRuntimeHeight = fromTableView.frame.height
    }
    
    // MARK: picker view
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return notes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0 { // from
            fromKey = Key(rawValue: row)
        } else {
            toKey = Key(rawValue: row)
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
        }
        pickerLabel?.text = notes[row]
        
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
            cell = UITableViewCell(style: .default, reuseIdentifier: "keyFromCell")
            cell?.textLabel?.text = notes[(indexPath.row + (fromKey?.rawValue)!) % notes.count]
        } else { // to
            cell = UITableViewCell(style: .default, reuseIdentifier: "keyToCell")
            cell?.textLabel?.text = notes[(indexPath.row + (toKey?.rawValue)!) % notes.count]
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
    
    // MARK: favorites
    
    @IBAction func saveFavorite(_ sender: UIButton) {
        if sender.titleLabel?.text == "Save Favorite" {
            if !proPaid {
                self.present(createBasicAlert(title: "PRO Feature", message: "Purchase PRO from the Settings tab to save favorites!"), animated: true)
            } else {
                UserDefaults.standard.set(notes[fromPickerView.selectedRow(inComponent: 0)], forKey: "key\(sender.tag + 1)From")
                UserDefaults.standard.set(notes[toPickerView.selectedRow(inComponent: 0)], forKey: "key\(sender.tag + 1)To")
                updateFavorites()
            }
        } else {
            let from = notes.firstIndex(of: UserDefaults.standard.string(forKey: "key\(sender.tag + 1)From")!)!
            let to = notes.firstIndex(of: UserDefaults.standard.string(forKey: "key\(sender.tag + 1)To")!)!
            fromPickerView.selectRow(from, inComponent: 0, animated: true)
            toPickerView.selectRow(to, inComponent: 0, animated: true)
            fromKey = Key(rawValue: from)
            toKey = Key(rawValue: to)
            fromTableView.reloadData()
            toTableView.reloadData()
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
    
    func getFavorites() -> [String] {
        return [UserDefaults.standard.string(forKey: "key1From")!,
                UserDefaults.standard.string(forKey: "key1To")!,
                UserDefaults.standard.string(forKey: "key2From")!,
                UserDefaults.standard.string(forKey: "key2To")!,
                UserDefaults.standard.string(forKey: "key3From")!,
                UserDefaults.standard.string(forKey: "key3To")!]
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
    
    // MARK: gradient
    
    func createGradientLayer(view: UIView) {
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [backgroundColor1.cgColor, backgroundColor2.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        view.layer.addSublayer(gradientLayer)
    }
}

