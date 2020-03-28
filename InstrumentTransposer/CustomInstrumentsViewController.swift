//
//  CustomInstrumentsViewController.swift
//  InstrumentTransposer
//
//  Created by Alex Wong on 12/23/18.
//  Copyright © 2018 Kids Can Code. All rights reserved.
//

import UIKit

class CustomInstrumentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var gradientLayer: CAGradientLayer!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var instrumentTextField: UITextField!
    @IBOutlet weak var keyPickerView: UIPickerView!
    @IBOutlet weak var instrumentsTableView: UITableView!
    
    var instruments: [Instrument] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        instruments = getCustomInstruments()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        createGradientLayer(view: gradientView)
    }
    
    func createGradientLayer(view: UIView) {
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [backgroundColor1.cgColor, backgroundColor2.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        view.layer.addSublayer(gradientLayer)
    }
    
    @IBAction func addInstrument(_ sender: Any) {
        if(instrumentTextField.text != "") {
            instruments.append(Instrument(name: instrumentTextField.text!, key: Key(rawValue: keyPickerView.selectedRow(inComponent: 0))!))
            
            instrumentTextField.text = ""
            keyPickerView.selectRow(0, inComponent: 0, animated: true)
            
            view.endEditing(true)
            
            setCustomInstruments(instruments: instruments)
            instrumentsTableView.reloadData()
        }
    }
    
    // table view
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return instruments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "customInstrumentCell")
        cell.textLabel?.text = "\(instruments[indexPath.row].name) (\(instruments[indexPath.row].key.description))"
        cell.textLabel?.font = UIFont(name: appFont, size: smallDevice() ? 15 : hasTraits(view: self.view, width: .regular, height: .regular) ? 25 : 17)
        
        return(cell)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete) {
            instruments.remove(at: indexPath.row)
            instrumentsTableView.beginUpdates()
            instrumentsTableView.deleteRows(at: [indexPath], with: .automatic)
            instrumentsTableView.endUpdates()
            
            setCustomInstruments(instruments: instruments)
        }
    }
    
    // picker view
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return notes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return notes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: appFont, size: hasTraits(view: self.view, width: .regular, height: .regular) ? 20 : 17)
            pickerLabel?.textAlignment = .center
            makeAdjustableFont(label: pickerLabel!)
        }
        pickerLabel?.text = notes[row]
        
        return pickerLabel!
    }
    
    // keyboard
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    // defaults
    
    func getCustomInstruments() -> [Instrument] {
        let defaults = UserDefaults.standard
        
        let names = defaults.string(forKey: "customInstrumentNames")
        let keys = defaults.string(forKey: "customInstrumentKeys")
        
        let nameArray = names?.components(separatedBy: "\n")
        let keyArray = keys?.components(separatedBy: "\n")
        
        var ret: [Instrument] = []
        
        if(names != "") {
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
    
    func setCustomInstruments(instruments: [Instrument]) {
        let defaults = UserDefaults.standard
        
        var names = ""
        var keys = ""
        
        for i in 0..<instruments.count {
            if(i != instruments.count - 1) {
                names += "\(instruments[i].name)\n"
                keys += "\(instruments[i].key.description)\n"
            } else {
                names += "\(instruments[i].name)"
                keys += "\(instruments[i].key.description)"
            }
        }
        
        defaults.set(names, forKey: "customInstrumentNames")
        defaults.set(keys, forKey: "customInstrumentKeys")
    }
}
