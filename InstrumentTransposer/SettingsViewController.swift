//
//  SettingsViewController.swift
//  InstrumentTransposer
//
//  Created by Alex Wong on 8/9/18.
//  Copyright © 2018 Kids Can Code. All rights reserved.
//

import UIKit
import StoreKit

var colorSender: Int = 0
var colorSenderText: String = ""

class SettingsViewController: UIViewController {

    var gradientLayer: CAGradientLayer!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var proButton: UIButton!
    @IBOutlet weak var restoreButton: UIButton!
    @IBOutlet weak var proFeaturesLabel: UILabel!
    @IBOutlet weak var customInstrumentsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        
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
        
        refresh()
        

        /* Class = "UILabel"; text = "PRO Features"; ObjectID = "94D-CS-kU9"; */
        // "94D-CS-kU9.text" = "PRO"

        /* Class = "UIButton"; text = "Get PRO"; ObjectID = "t1J-zO-0pU"; */
        // "t1J-zO-0pU.title" = "Comprar PRO"

        /* Class = "UIButton"; text = "Restore"; ObjectID = "ZlN-NZ-rqm"; */
        // "ZlN-NZ-rqm.title" = "Restaurar"

        /* Class = "UIButton"; text = "Manage Custom Instruments"; ObjectID = "Jqz-KO-yzo"; */
        // "Jqz-KO-yzo.title" = "Dirigir instrumentos a medida"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        createGradientLayer(view: gradientView)
        refresh()
    }

    @IBAction func changeColor(_ sender: UIButton) {
        colorSender = sender.tag
        colorSenderText = (sender.titleLabel?.text)!
        performSegue(withIdentifier: "colorSegue", sender: nil)
    }
    
    @IBAction func getPRO(_ sender: Any) {
        activityIndicator.startAnimating()
        IAPManager.shared.startObserving()
        
        IAPManager.shared.getProducts { (result) in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                switch result {
                case .success(let products):
                    var product: SKProduct?
                    for p in products {
                        if p.productIdentifier == IAP_PRO {
                            product = p
                        }
                    }
                    if product != nil {
                        self.proAlert(product: product!)
                    } else {
                        self.present(createBasicAlert(title: "Error", message: "Could not access in-app purchase."), animated: true)
                    }
                case .failure(let error):
                    self.present(createBasicAlert(title: "Error", message: error.errorDescription ?? ""), animated: true)
                    IAPManager.shared.stopObserving()
                }
            }
        }
    }
    
    func proAlert(product: SKProduct) {
        guard let price = IAPManager.shared.getPriceFormatted(for: product) else { return }
        
        let alert = UIAlertController(title: "Get PRO", message: "This one-time purchase for \(price) will give you access to all current and future PRO features, including creating custom instruments.\n\nTo restore a previous purchase, click Restore.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Buy Now", style: .default, handler: { (action) in
            if !self.purchase(product: product) {
                self.present(createBasicAlert(title: "Error", message: "In-App Purchases are not allowed in this device."), animated: true)
                IAPManager.shared.stopObserving()
            }
        }))
        self.present(alert, animated: true)
    }
    
    func purchase(product: SKProduct) -> Bool {
        if !IAPManager.shared.canMakePayments() {
            return false
        } else {
            activityIndicator.startAnimating()
            IAPManager.shared.buy(product: product) { (result) in
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    switch result {
                    case .success(_):
                        print("success")
                        self.present(createBasicAlert(title: "Purchase Complete", message: "You can now access PRO features."), animated: true)
                        self.refresh()
                    case .failure(let error):
                        self.present(createBasicAlert(title: "Error", message: error.localizedDescription), animated: true)
                    }
                    IAPManager.shared.stopObserving()
                }
            }
        }
     
        return true
    }
    
    @IBAction func restore(_ sender: Any) {
        let alert = UIAlertController(title: "Restore Purchases", message: "This will restore any purchases made by this device's Apple ID", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Restore", style: .default, handler: { (action) in
            self.activityIndicator.startAnimating()
            IAPManager.shared.startObserving()
            IAPManager.shared.restorePurchases { (result) in
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                 
                    switch result {
                    case .success(let success):
                        if success {
                            self.present(createBasicAlert(title: "Success", message: "PRO: \(proPaid ? "Purchased" : "Not Purchased")"), animated: true)
                            self.refresh()
                        } else {
                           self.present(createBasicAlert(title: "Error", message: "Unable to restore purchases"), animated: true)
                        }
                        IAPManager.shared.stopObserving()
                    case .failure(let error):
                        self.present(createBasicAlert(title: "Error", message: error.localizedDescription), animated: true)
                        IAPManager.shared.stopObserving()
                    }
                }
            }
        }))
        self.present(alert, animated: true)
    }
    
    func refresh() {
        proButton.isHidden = proPaid
        restoreButton.isHidden = proPaid
        proFeaturesLabel.isHidden = !proPaid
    }
    
    @IBAction func customInstruments(_ sender: Any) {
        if proPaid {
            performSegue(withIdentifier: "customInstrumentsSegue", sender: nil)
        } else {
            self.present(createBasicAlert(title: "PRO Feature", message: "Get PRO to create custom instruments!"), animated: true)
        }
    }
    
    @IBAction func clearFavorite(_ sender: Any) {
        if proPaid {
            let alert = UIAlertController(title: "Delete Favorite", message: nil, preferredStyle: .alert)
            for i in 1..<4 {
                alert.addAction(UIAlertAction(title: "Instrument Favorite \(i)", style: .default, handler: { (action) in
                    UserDefaults.standard.set("", forKey: "instrument\(i)From")
                    UserDefaults.standard.set("", forKey: "instrument\(i)To")
                }))
            }
            for i in 1..<4 {
                alert.addAction(UIAlertAction(title: "Key Favorite \(i)", style: .default, handler: { (action) in
                    UserDefaults.standard.set("", forKey: "key\(i)From")
                    UserDefaults.standard.set("", forKey: "key\(i)To")
                }))
            }
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        } else {
            self.present(createBasicAlert(title: "PRO Feature", message: "Get PRO to save favorites!"), animated: true)
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

func createBasicAlert(title: String, message: String) -> UIAlertController {
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
    
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in
        alert.dismiss(animated: true, completion: nil)
    }))
    
    return alert
}
