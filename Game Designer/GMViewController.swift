//
//  GMViewController.swift
//  Game Designer
//
//  Created by jhp on 2018-09-01.
//  Copyright © 2018 Papaya. All rights reserved.
//

import UIKit

class GMViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        status = "GMMode"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func gmUnwind(for unwindSegue: UIStoryboardSegue) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        status = "GMMode"
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
