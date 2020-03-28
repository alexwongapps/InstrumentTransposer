//
//  SettingsViewController.swift
//  InstrumentTransposer
//
//  Created by Alex Wong on 8/9/18.
//  Copyright © 2018 Kids Can Code. All rights reserved.
//

import UIKit

var colorSender: Int = 0
var colorSenderText: String = ""

class SettingsViewController: UIViewController {

    var gradientLayer: CAGradientLayer!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var versionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // localization
        
        let titleText = NSLocalizedString("version", comment: "InsTranspose Version ")
        let attributedText = NSMutableAttributedString(string: titleText)
        versionLabel!.attributedText = attributedText

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: appFont, size: 20)!]
        
        let nsObject: AnyObject? = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as AnyObject
        let version = nsObject as! String
        versionLabel.text?.append("\(version)")
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        createGradientLayer(view: gradientView)
    }

    @IBAction func changeColor(_ sender: UIButton) {
        colorSender = sender.tag
        colorSenderText = (sender.titleLabel?.text)!
        performSegue(withIdentifier: "colorSegue", sender: nil)
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
