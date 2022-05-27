//
//  NewItemViewController.swift
//  Game Designer
//
//  Created by jhp on 2018-08-20.
//  Copyright © 2018 Papaya. All rights reserved.
//

import UIKit

class NewItemViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var chooseAnIcon: UILabel!
    
    var itemIcons: [UIImageView] = []
    
    @IBOutlet weak var itemName: UILabel!
    
    @IBOutlet weak var createItemButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var itemField: UITextField!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionField: UITextView!
    
    @IBOutlet weak var iconView: UIView!
    
    
    @IBOutlet weak var iconStackView2: UIScrollView!
    @IBOutlet weak var nameView: UIView!
    
    
    var icon : String?
    var iconSelected = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionField.delegate = self as? UITextViewDelegate
        self.iconView.alpha = 0
        self.createItemButton.alpha = 0
        self.iconView.isUserInteractionEnabled = false
        self.createItemButton.isUserInteractionEnabled = false
        self.nextButton.alpha = 1
        self.nameView.alpha = 1
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        var count = 1
        var iconx = iconStackView2.frame.width/2 - 143
        var icony :CGFloat = 10
        for i in 0..<images.count {
            
            
            
            let iconSlot = UIImageView (image: UIImage(named: images[i]))
            iconSlot.frame = CGRect(x: iconx, y: icony, width: 64, height: 64)
            iconx += 74
            if count == 4 {
                icony += 74
                iconx = iconStackView2.frame.width/2 - 143
                count = 0
            }
            itemIcons += [iconSlot]
            iconSlot.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(selectIcon(_:))))
            iconSlot.isUserInteractionEnabled = true
            iconStackView2.addSubview(iconSlot)
            
            count += 1
        }
        iconStackView2.contentSize = CGSize(width: iconStackView2.frame.width, height: icony)
    }
    @objc func selectIcon(_ sender: UITapGestureRecognizer) {
        for i in itemIcons {
            i.transform = CGAffineTransform.identity.scaledBy(x: 1, y: 1)
        }
        (sender.view! as! UIImageView).transform = CGAffineTransform.identity.scaledBy(x: 1.2, y: 1.2)
        let iconNum = (itemIcons.index(of: sender.view! as! UIImageView)!)
        icon = images[iconNum]
        iconSelected = true
        
        
    }
    
    @IBAction func next(_ sender: UIButton) {
        UIView.transition(with: view, duration: 0.4, options: [.transitionCrossDissolve], animations: {
            self.iconView.alpha = 1
            self.nextButton.alpha = 0
            self.createItemButton.alpha = 1
            self.nameView.alpha = 0
        
        },completion: {finished in
            self.iconView.isUserInteractionEnabled = true
            self.nextButton.isUserInteractionEnabled = false
            self.nameView.isUserInteractionEnabled = false
            self.createItemButton.isUserInteractionEnabled = true
        })
    }
    
    @IBAction func back(_ sender: UIButton) {
        if iconView.isUserInteractionEnabled == true {
            UIView.transition(with: view, duration: 0.4, options: [.transitionCrossDissolve], animations: {
                self.iconView.alpha = 0
                self.nextButton.alpha = 1
                self.nameView.alpha = 1
                self.createItemButton.alpha = 0
                
            }, completion: {finished in
                self.iconView.isUserInteractionEnabled = false
                self.nextButton.isUserInteractionEnabled = true
                self.nameView.isUserInteractionEnabled = true
                self.createItemButton.isUserInteractionEnabled = false
            })
        } else {
            performSegue(withIdentifier: "newItemToGM", sender: nil)
        }
        

    }
    
    
    @IBAction func createItem(_ sender: Any) {
        if iconSelected != false {
            let newItem = Item(itemField.text!, descriptionField.text, icon: icon!)
            userItems += [newItem]
            saveData()
            performSegue(withIdentifier: "newItemToGM", sender: nil)
        }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        descriptionField.resignFirstResponder()
        itemField.resignFirstResponder()
        return true
    }
    
}
