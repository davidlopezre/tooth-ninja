//
//  StartingViewController.swift
//  tooth-ninja
//
//  Created by David Lopez on 2/9/18.
//  Copyright © 2018 Kushagra Vashisht. All rights reserved.
//
import UIKit
import Foundation
import AVFoundation

class StartingViewController: UIViewController
{
    var audioPlayer = AVAudioPlayer()
    var count = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        do
        {
            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "Off Limits", ofType: "wav")!))
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            audioPlayer.numberOfLoops = -1
            print("Started")
        }
        catch
        {
            print(error)
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
    
    @IBAction func playAudio(_ sender: Any) {
        if audioPlayer.isPlaying
        {
            audioPlayer.pause()
        }
    }
}
