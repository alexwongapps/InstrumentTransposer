//
//  TunerViewController.swift
//  InstrumentTransposer
//
//  Created by Alex Wong on 6/4/19.
//  Copyright © 2019 Kids Can Code. All rights reserved.
//
//  Beethoven Copyright (c) 2015 Vadym Markov
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import UIKit

class TunerViewController: UIViewController, PitchEngineDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    var gradientLayer: CAGradientLayer!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var tunerLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var centsLabel: UILabel!
    @IBOutlet weak var instrument1PickerView: UIPickerView!
    @IBOutlet weak var instrument1Label: UILabel!
    @IBOutlet weak var instrument2PickerView: UIPickerView!
    @IBOutlet weak var instrument2Label: UILabel!
    @IBOutlet weak var barView: UIView!
    
    var centerConstraint: NSLayoutConstraint?
    var barCenterConstraint: NSLayoutConstraint?
    
    var instrument1: Instrument?
    var instrument2: Instrument?
    var instruments: [Instrument] = []
    
    // Beethoven
    let config = Config()
    let pitchEngine = PitchEngine()
    
    var pitchQueue = ["", "", "", "", ""]
    var note: Key?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        
        // localization
        
        let titleText = NSLocalizedString("tuner", comment: "Tuner")
        let attributedText = NSMutableAttributedString(string: titleText)
        tunerLabel!.attributedText = attributedText
        makeAdjustableFont(label: tunerLabel)
        
        let playText = NSLocalizedString("playANote", comment: "Play a note")
        let attributedTextPlay = NSMutableAttributedString(string: playText)
        noteLabel!.attributedText = attributedTextPlay
        makeAdjustableFont(label: noteLabel)

        // Do any additional setup after loading the view.
        pitchEngine.delegate = self
        pitchEngine.start()
        
        // labels
        centsLabel.text = ""
        centsLabel.backgroundColor = .clear
        centsLabel.layer.masksToBounds = true
        instrument1Label.text = ""
        instrument2Label.text = ""
        barView.backgroundColor = .clear
        
        // picker view
        
        instruments.removeAll()
        instruments.append(contentsOf: getCustomInstruments())
        instruments.append(contentsOf: coreInstruments)
        
        instrument1PickerView.reloadAllComponents()
        instrument2PickerView.reloadAllComponents()
        
        instrument1PickerView.selectRow(0, inComponent: 0, animated: true)
        instrument2PickerView.selectRow(0, inComponent: 0, animated: true)
        
        instrument1 = instruments[0]
        instrument2 = instruments[0]
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
        
        instruments.removeAll()
        instruments.append(contentsOf: getCustomInstruments())
        instruments.append(contentsOf: coreInstruments)
        
        instrument1PickerView.reloadAllComponents()
        instrument2PickerView.reloadAllComponents()
        
        instrument1 = instruments[instrument1PickerView.selectedRow(inComponent: 0)]
        instrument2 = instruments[instrument2PickerView.selectedRow(inComponent: 0)]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        createGradientLayer(view: gradientView)
    }
    
    // MARK: picker view
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return instruments.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView.tag == 0 { // instrument1
            instrument1 = instruments[row]
        } else {
            instrument2 = instruments[row]
        }
        
        if let setNote = note {
            instrument1Label.text = Key(rawValue: (setNote.rawValue + 12 - (instrument1!.key.rawValue)) % notes.count)?.description
            instrument2Label.text = Key(rawValue: (setNote.rawValue + 12 - (instrument2!.key.rawValue)) % notes.count)?.description
        }
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
    
    // MARK: Beethoven
    
    func pitchEngine(_ pitchEngine: PitchEngine, didReceivePitch pitch: Pitch) {
        print("\(pitch.note.string)")
        print("\(pitch.frequency)")
        pitchQueue[4] = pitchQueue[3]
        pitchQueue[3] = pitchQueue[2]
        pitchQueue[2] = pitchQueue[1]
        pitchQueue[1] = pitchQueue[0]
        pitchQueue[0] = pitch.note.letter.rawValue
        
        // good note
        if pitchQueue[0] == pitchQueue[1] &&
            pitchQueue[1] == pitchQueue[2] &&
            pitchQueue[2] == pitchQueue[3] &&
            pitchQueue[3] == pitchQueue[4] {
            
            let cents = round(number: pitch.closestOffset.cents, places: 1)
            
            var barColor = UIColor.clear
            
            if abs(cents) < 10.0 {
                barColor = UIColor(red: 0, green: 0.7, blue: 0, alpha: 1)
                centsLabel.text = "  \(cents)  "
            } else if abs(cents) < 20.0 {
                barColor = UIColor(red: 0.8, green: 0.8, blue: 0, alpha: 1)
                centsLabel.text = " \(cents) "
            } else {
                barColor = UIColor(red: 0.8, green: 0, blue: 0, alpha: 1)
                centsLabel.text = " \(cents) "
            }
            
            barView.backgroundColor = barColor
            
            if let constraint = centerConstraint {
                centsLabel.superview!.removeConstraint(constraint)
            }
            centerConstraint = NSLayoutConstraint(item: centsLabel.superview!, attribute: .centerX, relatedBy: .equal, toItem: centsLabel!, attribute: .centerX, multiplier: 1, constant: -(CGFloat(cents) * 2))
            centsLabel.superview!.addConstraint(centerConstraint!)
            
            if let barConstraint = barCenterConstraint {
                barView.superview!.removeConstraint(barConstraint)
            }
            barCenterConstraint = NSLayoutConstraint(item: barView.superview!, attribute: .centerX, relatedBy: .equal, toItem: barView, attribute: .centerX, multiplier: 1, constant: -(CGFloat(cents) * 2))
            barView.superview!.addConstraint(centerConstraint!)
            
            switch(pitchQueue[0]) {
                
            case "C": note = Key.c; break
            case "C#": note = Key.d_flat; break
            case "D": note = Key.d; break
            case "D#": note = Key.e_flat; break
            case "E": note = Key.e; break
            case "F": note = Key.f; break
            case "F#": note = Key.g_flat; break
            case "G": note = Key.g; break
            case "G#": note = Key.a_flat; break
            case "A": note = Key.a; break
            case "A#": note = Key.b_flat; break
            case "B": note = Key.b; break
            default: note = Key.c; break
                
            }
            
            noteLabel.text = note?.description
            instrument1Label.text = Key(rawValue: (note!.rawValue + 12 - (instrument1!.key.rawValue)) % notes.count)?.description
            instrument2Label.text = Key(rawValue: (note!.rawValue + 12 - (instrument2!.key.rawValue)) % notes.count)?.description
        } 
    }
    
    func pitchEngine(_ pitchEngine: PitchEngine, didReceiveError error: Error) {
        print("error")
    }
    
    func pitchEngineWentBelowLevelThreshold(_ pitchEngine: PitchEngine) {
        print("too low")
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

func round(number: Double, places: Int) -> Double {
    let multiplier: Double = Double(truncating: pow(10, places) as NSNumber)
    
    return Double(round(number * multiplier) / multiplier)
}
