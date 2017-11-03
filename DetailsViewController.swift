//
//  DetailsViewController.swift
//  Orbit Sim
//
//  Created by jason kim on 2/5/17.
//  Copyright © 2017 jason kim. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController, UITextFieldDelegate {

    var aText: String?
    var eText: String?
    var oText: String?
    var iText: String?
    var wText: String?
    var mText: String?
    var currentPlanet: Int?
    
    
    @IBOutlet weak var iSlider: UISlider!
    @IBOutlet weak var wSlider: UISlider!
    @IBOutlet weak var mSlider: UISlider!
    @IBOutlet weak var oSlider: UISlider!
    @IBOutlet weak var mField: UITextField!
    @IBOutlet weak var wField: UITextField!
    @IBOutlet weak var iField: UITextField!
    @IBOutlet weak var oField: UITextField!
    @IBOutlet weak var eSlider: UISlider!
    @IBOutlet weak var eField: UITextField!
    @IBOutlet weak var aSlider: UISlider!
    @IBOutlet weak var aField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let aText = aText {
            aField.text = aText
        }
        if let eText = eText {
            eField.text = eText
        }
        if let oText = oText {
            oField.text = oText
        }
        if let iText = iText {
            iField.text = iText
        }
        if let wText = wText {
            wField.text = wText
        }
        if let mText = mText {
            mField.text = mText
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tap(gesture:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    func tap(gesture: UITapGestureRecognizer) {
        aField.resignFirstResponder()
        eField.resignFirstResponder()
        oField.resignFirstResponder()
        iField.resignFirstResponder()
        wField.resignFirstResponder()
        mField.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
