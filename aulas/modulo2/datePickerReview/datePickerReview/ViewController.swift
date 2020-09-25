//
//  ViewController.swift
//  datePickerReview
//
//  Created by Elder Alcantara on 13/09/20.
//  Copyright © 2020 Digital House. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var myDatePicker: UIDatePicker!
    @IBOutlet weak var myLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        myDatePicker.maximumDate = Calendar.current.date(byAdding: .day, value: 0, to: Date())
        
    }
    
    @IBAction func setDate(_ sender: UIDatePicker) {
        
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.short
        formatter.timeStyle = DateFormatter.Style.short
        
        
        let birthday = formatter.date(from: formatter.string(from: self.myDatePicker.date))
        let timeInterval = birthday?.timeIntervalSinceNow
        let age = abs(Int(timeInterval! / 31556926.0))
        
        print(age)
        
        
        if age > 1 {
            self.myLabel.text = String(age) + " anos"
        } else if age == 1 {
            self.myLabel.text = String(age) + " ano"
        } else{
            self.myLabel.text = "Menos de 1 ano"
        }
        
        
        
        
    }
    
    
    
    
}
