//
//  StartingViewController.swift
//  tooth-ninja
//
//  Created by David Lopez and Kushagra Vashisht on 2/9/18.
//  Copyright © 2018 Kushagra Vashisht. All rights reserved.
//
import UIKit
import Foundation
import AVFoundation

class StartingViewController: UIViewController
{
    var audioPlayer = AVAudioPlayer()
    static var musicPlaying = 0
    
    
    //    Calling the audioPlayer created in the App Delegate to solve the bug wherein two streams of audio are created when transitioning from one view controller to the other or back
    var audioPlayerAD : AVAudioPlayer? {
        get {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            return appDelegate.audioPlayerAD
        }
        set {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.audioPlayerAD = newValue
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        do
        {
            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "Off Limits", ofType: "wav")!))
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            StartingViewController.musicPlaying += 1
            audioPlayer.numberOfLoops = -1
            print("Started")
            print("musicPlayer variable count = ",StartingViewController.musicPlaying)
        }
        catch
        {
            print(error)
        }
        if(StartingViewController.musicPlaying > 1)
        {
            audioPlayer.pause()
            print("Audio Player stopped in Starting View Controller")
        }
    }
    
    @IBAction func goToGame(button: UIButton)
    {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "GameViewController")
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func goToConfiguration(button: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ConfigurationController")
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func goToInstructions(button: UIButton) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let swipingController = SwipingController(collectionViewLayout: layout)
        self.present(swipingController, animated: true, completion: nil)
    }
}
