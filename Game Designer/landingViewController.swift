//
//  landingViewController.swift
//  Game Designer
//
//  Created by jhp on 2018-08-28.
//  Copyright © 2018 Papaya. All rights reserved.
//

import UIKit
import UserNotifications

class landingViewController: UIViewController {

    @IBOutlet weak var cashAmount: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        status = "landing"
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound], completionHandler: {didAllow, error in})
        loadData()
        cashAmount.text = String(userInventory[0].amount[0])
        // Do any additional setup after loading the view.
    }
    
    @IBAction func unwind(for unwindSegue: UIStoryboardSegue) {
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        status = "landing"
        cashAmount.text = String(userInventory[0].amount[0])
    }
    
    @IBAction func taxButton(_ sender: UIButton) {
        status = "tax"
        //performSegue(withIdentifier: "landingToBank", sender: nil)
    }
    
    
    @IBAction func bankButton(_ sender: UIButton) {
        status = "bank"
        performSegue(withIdentifier: "landingToBank", sender: nil)
    }
    
    @IBAction func adjustButton(_ sender: UIButton) {
        status = "adjust"
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
