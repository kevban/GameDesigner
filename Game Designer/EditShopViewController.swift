//
//  EditShopViewController.swift
//  Game Designer
//
//  Created by jhp on 2018-09-01.
//  Copyright © 2018 Papaya. All rights reserved.
//

import UIKit

class EditShopViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var itemInfoView: UIView!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var itemScrollView: UIScrollView!
    
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var priceField: UITextField!
    
    @IBOutlet weak var itemNameLabel: UILabel!
    
    @IBOutlet weak var viewShopButton: UIButton!
    
    @IBOutlet weak var addShopButton: UIButton!
    
    @IBOutlet weak var descriptionScrollView: UIScrollView!
    
    var itemIcons : [UIImageView] = []
    
    
    var itemSelectedNum : Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawItemIcons()
        itemInfoView.isHidden = true
        priceField.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    
    func drawItemIcons () {
        var count = 1
        var iconx = itemScrollView.frame.width/2 - 143
        var icony :CGFloat = 10
        for i in 0..<userItems.count {
            
            let iconSlot = UIImageView (image: UIImage(named: userItems[i].iconName))
            iconSlot.frame = CGRect(x: iconx, y: icony, width: 64, height: 64)
            iconx += 74
            if count == 4 {
                icony += 74
                iconx = itemScrollView.frame.width/2 - 143
                count = 0
            }
           itemIcons += [iconSlot]
            iconSlot.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(selectItem(_:))))
            iconSlot.isUserInteractionEnabled = true
            itemScrollView.addSubview(iconSlot)
            
            count += 1
        }
        itemScrollView.contentSize = CGSize(width: itemScrollView.frame.width, height: icony)
    }
    
    func drawShopIcons () {
        var count = 1
        var iconx = itemScrollView.frame.width/2 - 143
        var icony :CGFloat = 10
        for i in 0..<userShop.count {
            
            
            
            let iconSlot = UIImageView (image: UIImage(named: userShop[i].iconName))
            iconSlot.frame = CGRect(x: iconx, y: icony, width: 64, height: 64)
            iconx += 74
            if count == 4 {
                icony += 74
                iconx = itemScrollView.frame.width/2 - 143
                count = 0
            }
            itemIcons += [iconSlot]
            iconSlot.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(selectItem(_:))))
            iconSlot.isUserInteractionEnabled = true
            itemScrollView.addSubview(iconSlot)
            
            count += 1
        }
        itemScrollView.contentSize = CGSize(width: itemScrollView.frame.width, height: icony)    }
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }

    
    @objc func selectItem (_ recognizer : UITapGestureRecognizer) {
        switch recognizer.state {
        case.ended:
            
            if viewShopButton.currentTitle == "View Item" {
                let itemNum = (itemIcons.index(of: recognizer.view! as! UIImageView)!)
                descriptionLabel.text = userShop[itemNum].description
                
                let descriptionScrollLength = heightForView(text: descriptionLabel.text!, font: descriptionLabel.font, width: descriptionLabel.frame.width)
                descriptionScrollView.contentSize = CGSize(width: descriptionScrollView.frame.width, height: descriptionScrollLength)
                itemNameLabel.text = userShop[itemNum].name
                itemSelectedNum = itemNum
                itemInfoView.isHidden = false
                priceField.text = String(userShop[itemNum].amount[0])
                addShopButton.setTitle("Remove From Shop", for: .normal)
            } else {
                let itemNum = (itemIcons.index(of: recognizer.view! as! UIImageView)!)
                descriptionLabel.text = userItems[itemNum].description
                
                let descriptionScrollLength = heightForView(text: descriptionLabel.text!, font: descriptionLabel.font, width: descriptionLabel.frame.width)
                descriptionScrollView.contentSize = CGSize(width: descriptionScrollView.frame.width, height: descriptionScrollLength)
                itemNameLabel.text = userItems[itemNum].name
                itemSelectedNum = itemNum
                itemInfoView.isHidden = false
                addShopButton.setTitle("Add To Shop", for: .normal)
                
            }
            for i in itemIcons {
                i.transform = CGAffineTransform.identity.scaledBy(x: 1, y: 1)
            }
            recognizer.view!.transform = CGAffineTransform.identity.scaledBy(x: 1.2, y: 1.2)
        default: break
        }
        
    }
    
  
    @IBAction func viewButton(_ sender: UIButton) {
        if sender.currentTitle == "View Shop" {
            itemInfoView.isHidden = true
            itemIcons = []
            for i in itemScrollView.subviews {
                i.removeFromSuperview()
            }
            drawShopIcons()
            sender.setTitle("View Item", for: .normal)
            
        } else {
            itemInfoView.isHidden = true
            itemIcons = []
            for i in itemScrollView.subviews {
                i.removeFromSuperview()
            }
            drawItemIcons()
            sender.setTitle("View Shop", for: .normal)
        }
    }
    
    @IBAction func addToShop(_ sender: UIButton) {
        if sender.currentTitle == "Add To Shop" {
            var item = userItems[itemSelectedNum!]
            if Int(priceField.text!) != nil {
                item.amount[0] = Int(priceField.text!)!
            }
            userShop += [item]
            itemInfoView.isHidden = true
            saveData()
            
            
        } else {
            userShop.remove(at: itemSelectedNum!)
            itemIcons = []
            for i in itemScrollView.subviews {
                i.removeFromSuperview()
            }
            drawShopIcons()
            itemInfoView.isHidden = true
            saveData()
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
        priceField.resignFirstResponder()
        return true
    }

}
