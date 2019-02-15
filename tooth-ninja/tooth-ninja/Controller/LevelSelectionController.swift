//
//  LevelSelectionController.swift
//  tooth-ninja
//
//  Created by David Lopez on 5/1/19.
//  Copyright © 2019 Kushagra Vashisht. All rights reserved.
//

import Foundation
import UIKit

class LevelSelectionController : UIViewController
{
    @IBOutlet weak var level2Button: UIButton!
    @IBOutlet weak var level3Button: UIButton!
    
    private let blueColor = UIColor(red: 24/255, green: 67/255, blue: 140/255, alpha: 1)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshLevelButtons()
    }
    
    func refreshLevelButtons() {
        let levelsUnlocked = queryLevelsUnlocked()
        if (!levelsUnlocked.contains(2)) {
            level2Button.isEnabled = false
            level2Button.backgroundColor = UIColor.gray
        } else {
            level2Button.isEnabled = true
            level2Button.backgroundColor = blueColor
        }
        
        if (!levelsUnlocked.contains(3)) {
            level3Button.isEnabled = false
            level3Button.backgroundColor = UIColor.gray
        } else {
            level3Button.isEnabled = true
            level3Button.backgroundColor = blueColor
        }
    }
    
    @IBAction func goToLevel1() {
        let controller = storyboard!.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
        controller.levelId = 1
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func goToLevel2(_ sender: Any) {
        let controller = storyboard!.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
        controller.levelId = 2
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func goToLevel3(_ sender: Any) {
        let controller = storyboard!.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
        controller.levelId = 3
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    deinit {
        print("LevelSelection deinited")
    }
}
