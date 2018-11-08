//
//  ConfigurationController.swift
//  tooth-ninja
//
//  Created by David Lopez and Kushagra Vashisht on 2/9/18.
//  Copyright © 2018 Kushagra Vashisht. All rights reserved.
//

import Foundation
import UIKit

class ConfigurationController : UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    var speedValue = "0"
    var sizeValue = "0"
    
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBAction func speedSlider(_ sender: UISlider)
    {
        speedValue = String((sender.value))
        speedLabel.text = "Speed = " + speedValue
//        setDefaults(type: DefaultTypes.Speed, value: Double(speedValue)! * 1000)
        setDefaults(type: DefaultTypes.Speed, value: 2)

    }
    @IBAction func sizeSlider(_ sender: UISlider)
    {
        sizeValue = String((sender.value))
        sizeLabel.text = "Size = " + sizeValue
        setDefaults(type: DefaultTypes.BacteriaSize, value: Double(sizeValue)! * 1000)
    }
    @IBOutlet weak var backButton: UIButton!
    @IBAction func goBack(button: UIButton)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "StartingViewController")
        self.present(controller, animated: true, completion: nil)
    }
}
    
//    @IBOutlet weak var speedController: UISegmentedControl!
//    @IBOutlet weak var sizeController: UISegmentedControl!
//
//    @IBAction func speedChanged(_ sender: Any) {
//        switch speedController.selectedSegmentIndex {
//            case 0:
//                setDefaults(type: DefaultTypes.Speed, value: 2)
//            case 1:
//                setDefaults(type: DefaultTypes.Speed, value: 1)
//            case 2:
//                setDefaults(type: DefaultTypes.Speed, value: 0.25)
//            default:
//                break
//        }
//    }
//
//    @IBAction func sizeChanged(_ sender: Any) {
//        switch sizeController.selectedSegmentIndex {
//        case 0:
//            setDefaults(type: DefaultTypes.BacteriaSize, value: 0.5)
//        case 1:
//            setDefaults(type: DefaultTypes.BacteriaSize, value: 1)
//        case 2:
//             setDefaults(type: DefaultTypes.BacteriaSize, value: 1.5)
//        default:
//            break
//        }
//    }
//
//
