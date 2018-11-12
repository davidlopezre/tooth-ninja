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
        do
        {
            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "Off Limits", ofType: "wav")!))
            audioPlayer.prepareToPlay()
            audioPlayer.pause()
            print("Music Player Paused in ConfigurationController")
        }
        catch
        {
            print(error)
        }
//        if(audioPlayer.isPlaying)
//        {
//            audioPlayer.pause()
//            print("Music Player Paused in ConfigurationController")
//        }
    }
    
    @IBOutlet weak var speedController: UISegmentedControl!
    @IBOutlet weak var sizeController: UISegmentedControl!
    
    @IBAction func speedChanged(_ sender: Any) {
        switch speedController.selectedSegmentIndex {
            case 0:
                setDefaults(type: DefaultTypes.Speed, value: 2)
            case 1:
                setDefaults(type: DefaultTypes.Speed, value: 1)
            case 2:
                setDefaults(type: DefaultTypes.Speed, value: 0.25)
            default:
                break
        }
    }
    
    @IBAction func sizeChanged(_ sender: Any) {
        switch sizeController.selectedSegmentIndex {
        case 0:
            setDefaults(type: DefaultTypes.BacteriaSize, value: 0.5)
        case 1:
            setDefaults(type: DefaultTypes.BacteriaSize, value: 1)
        case 2:
             setDefaults(type: DefaultTypes.BacteriaSize, value: 1.5)
        default:
            break
        }
    }
    
    @IBOutlet weak var backButton: UIButton!
    @IBAction func goBack(button: UIButton)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "StartingViewController")
        self.present(controller, animated: true, completion: nil)
    }
}
