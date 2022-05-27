//
//  ResetViewController.swift
//  Game Designer
//
//  Created by jhp on 2018-09-02.
//  Copyright © 2018 Papaya. All rights reserved.
//

import UIKit

class ResetViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func reset(_ sender: UIButton) {
        userLimitQuests  = []
        userMainQuests  = []
        userDailyQuests = []
        userItems  = []
        userShop = []
        userInventory  = [cash]
        saveData()
        performSegue(withIdentifier: "resetToLanding", sender: nil)
        
    }
    
    
    @IBAction func save(_ sender: UIButton) {
        if let encodedDailyQuests = try? JSONEncoder().encode(userDailyQuests) {
            UserDefaults.standard.set(encodedDailyQuests, forKey: "dailyQuestsB")
        }
        if let encodedItems = try? JSONEncoder().encode(userItems) {
            UserDefaults.standard.set(encodedItems, forKey: "itemsB")
        }
        if let encodedItems = try? JSONEncoder().encode(userShop) {
            UserDefaults.standard.set(encodedItems, forKey: "shopB")
        }
        performSegue(withIdentifier: "resetToLanding", sender: nil)
    }
    
    @IBAction func revert(_ sender: UIButton) {
        if let y = UserDefaults.standard.data(forKey: "dailyQuestsB") {
            userDailyQuests = try! JSONDecoder().decode([Quest].self, from: y)
        }
        if let i = UserDefaults.standard.data(forKey: "itemsB") {
            userItems = try! JSONDecoder().decode([Item].self, from: i)
        }
        if let j = UserDefaults.standard.data(forKey: "shopB") {
            userShop = try! JSONDecoder().decode([Item].self, from: j)
        }
        saveData()
        performSegue(withIdentifier: "resetToLanding", sender: nil)
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
