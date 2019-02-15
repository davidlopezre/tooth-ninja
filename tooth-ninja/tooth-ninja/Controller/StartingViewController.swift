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
    deinit {
        print ("StartingView deinited")
    }
    
    @IBOutlet weak var toothNinja: UIImageView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.toothNinja.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        tap.numberOfTapsRequired = 10
        toothNinja.addGestureRecognizer(tap)
    }
    
    @objc func tapped() {
        print("10 times tapped")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let settingsController = storyboard.instantiateViewController(withIdentifier: "ConfigurationController") as! ConfigurationController
        self.navigationController?.pushViewController(settingsController, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func goToInfoScreen(_ sender: Any) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let swipingController = SwipingController(collectionViewLayout: layout)
        self.navigationController?.pushViewController(swipingController, animated: true)
    }
}
