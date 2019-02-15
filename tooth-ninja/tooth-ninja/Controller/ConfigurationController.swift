//
//  ConfigurationController.swift
//  tooth-ninja
//
//  Created by David Lopez and Kushagra Vashisht on 2/9/18.
//  Copyright © 2018 Kushagra Vashisht. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class ConfigurationController : UIViewController
{
    var audioPlayer = AVAudioPlayer()
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    deinit {
        print ("ConfigurationController deinited")
    }
    
    
    var speedValue = 0.0
    var sizeValue = 0.0
    
    override func viewWillAppear(_ animated: Bool) {
        let speedVal = queryDefaults(type: DefaultTypes.Speed)
        speedLabel.text = "Speed = \((speedVal/4).rounded(toPlaces: 1))"
        speedSlider.setValue(Float(speedVal), animated: false)
        
        let sizeVal = queryDefaults(type: DefaultTypes.BacteriaSize)
        sizeLabel.text = "Size = \((sizeVal/4).rounded(toPlaces: 1))"
        sizeSlider.setValue(Float(sizeVal), animated: false)
        super.viewWillAppear(true)
    }
    
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var sizeSlider: UISlider!
    @IBOutlet weak var speedSlider: UISlider!
    @IBAction func speedSlider(_ sender: UISlider)
    {
        speedValue = (Double(sender.value))
        speedLabel.text = "Speed = \((speedValue/4).rounded(toPlaces: 1))"
        setDefaults(type: DefaultTypes.Speed, value: Double(speedValue))
        print(speedValue)
//        setDefaults(type: DefaultTypes.Speed, value: 2)

    }
    @IBAction func sizeSlider(_ sender: UISlider)
    {
        sizeValue = (Double(sender.value))
        sizeLabel.text = "Size = \((sizeValue/4).rounded(toPlaces: 1))"
        setDefaults(type: DefaultTypes.BacteriaSize, value: Double(sizeValue))
    }
    @IBOutlet weak var backButton: UIButton!
    @IBAction func goBack(button: UIButton)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "StartingViewController")
        self.present(controller, animated: true, completion: nil)
    }
}
