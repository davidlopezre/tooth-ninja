//
//  ViewController.swift
//  testing_screen
//
//  Created by Kushagra Vashisht on 7/8/18.
//  Copyright © 2018 Kush. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    var button = dropDownButton()
    var button2 = dropDownButton()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        button = dropDownButton.init(frame: CGRect(x:0, y: 0, width: 0, height: 0))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Speed", for: .normal)
        self.view.addSubview(button)
        
        button2 = dropDownButton.init(frame: CGRect(x:0, y: 0, width: 0, height: 0))
        button2.translatesAutoresizingMaskIntoConstraints = false
        button2.setTitle("Size", for: .normal)
        self.view.addSubview(button2)
        
        button.leftAnchor.constraint(equalTo: self.view.leftAnchor,constant: 100).isActive = true
        button.rightAnchor.constraint(equalTo: self.view.rightAnchor,constant: -100).isActive = true
        button.topAnchor.constraint(equalTo: self.view.topAnchor,constant: 200).isActive = true
        button.widthAnchor.constraint(equalToConstant: 130).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        button2.leftAnchor.constraint(equalTo: self.view.leftAnchor,constant: 100).isActive = true
        button2.rightAnchor.constraint(equalTo: self.view.rightAnchor,constant: -100).isActive = true
        button2.topAnchor.constraint(equalTo: self.view.topAnchor,constant: 500).isActive = true
        button2.widthAnchor.constraint(equalToConstant: 130).isActive = true
        button2.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        button.dropView.dropDownOptions = ["Very Slow","Slow","Fast"]
        button2.dropView.dropDownOptions = ["Very Small","Small","Large"]
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
protocol dropDownProtocol
{
    func dropDownPressed(string : String)
}

class dropDownButton: UIButton, dropDownProtocol
{
    
    func dropDownPressed(string: String)
    {
        self.setTitle(string, for: .normal)
        self.dismissDropDown()
    }
    
    var dropView = dropDownView()
    var height = NSLayoutConstraint()
    var isOpen = false
    
    override init(frame: CGRect)
    {
        super.init(frame:frame)
        self.backgroundColor = UIColor.darkGray
        dropView = dropDownView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        dropView.delegate = self
        dropView.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    override func didMoveToSuperview()
    {
        self.superview?.addSubview(dropView)
        self.superview?.bringSubview(toFront: dropView)
        
        dropView.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        dropView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        dropView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        height = dropView.heightAnchor.constraint(equalToConstant: 0)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if isOpen == false
        {
            isOpen = true
            NSLayoutConstraint.deactivate([self.height])
            
            if self.dropView.tableView.contentSize.height > 150
            {
                self.height.constant = 150
            }
            else
            {
                self.height.constant = self.dropView.tableView.contentSize.height
            }
            NSLayoutConstraint.activate([self.height])
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.dropView.layoutIfNeeded()
                self.dropView.center.y += self.dropView.frame.height/2
            }, completion: nil)
        }
        else
        {
            isOpen = false
            NSLayoutConstraint.deactivate([self.height])
            self.height.constant = 0
            NSLayoutConstraint.activate([self.height])
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.dropView.center.y -= self.dropView.frame.height/2
                self.dropView.layoutIfNeeded()
            }, completion: nil)
        }
        
    }
    
    func dismissDropDown()
    {
        isOpen = false
        NSLayoutConstraint.deactivate([self.height])
        self.height.constant = 0
        NSLayoutConstraint.activate([self.height])
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.dropView.center.y -= self.dropView.frame.height / 2
            self.dropView.layoutIfNeeded()
        }, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}

class dropDownView: UIView, UITableViewDelegate, UITableViewDataSource
{
    var dropDownOptions = [String]()
    var tableView = UITableView()
    var delegate: dropDownProtocol!
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.darkGray
        self.backgroundColor = UIColor.darkGray
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(tableView)
        
        tableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return dropDownOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell()
        cell.textLabel?.text = dropDownOptions[indexPath.row]
        cell.backgroundColor = UIColor.darkGray
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.delegate.dropDownPressed(string: dropDownOptions[indexPath.row])
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}
