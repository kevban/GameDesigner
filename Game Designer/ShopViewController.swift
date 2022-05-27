//
//  ShopViewController.swift
//  Game Designer
//
//  Created by jhp on 2018-09-01.
//  Copyright © 2018 Papaya. All rights reserved.
//

import UIKit

class ShopViewController: UIViewController {
    
    
    @IBOutlet weak var itemInfoView: UIView!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var itemNameLabel: UILabel!
    
    @IBOutlet weak var dollarAmount: UILabel!
    
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var itemScrollView: UIScrollView!
    
    @IBOutlet weak var descriptionScrollView: UIScrollView!
    var itemIcons : [UIImageView] = []
    
    var selectedItem : Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dollarAmount.text = String(userInventory[0].amount[0])
        itemInfoView.isHidden = true
        itemScrollView.contentSize = CGSize(width: itemScrollView.frame.width, height: 480)
        
        drawIcons()
        
        // Do any additional setup after loading the view.
    }
    
    func drawIcons () {
        var count = 1
        var iconx = itemScrollView.frame.width/2 - 143
        var icony :CGFloat = 10
        for i in 0..<userShop.count {
            
            let iconSlot = UIImageView (image: UIImage(named: userShop[i].iconName))
            iconSlot.frame = CGRect(x: iconx, y: icony, width: 64, height: 64)
            iconx += 74
            if count == 4 {
                icony += 104
                iconx = itemScrollView.frame.width/2 - 143
                count = 0
            }
            let priceIcon = UIImageView(frame: CGRect(x: -6, y: 64, width: 40, height: 40))
            priceIcon.image = UIImage(named: "dollarsign")
            let priceTag = UILabel(frame: CGRect(x: 30, y: 64, width: 120, height: 40))
            priceTag.font = priceTag.font.withSize(10)
            priceTag.text = String(userShop[i].amount[0])
            iconSlot.addSubview(priceTag)
            iconSlot.addSubview(priceIcon)
            itemIcons += [iconSlot]
            iconSlot.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(selectIcon(_:))))
            iconSlot.isUserInteractionEnabled = true
            itemScrollView.addSubview(iconSlot)
            
            count += 1
        }
        itemScrollView.contentSize = CGSize(width: itemScrollView.frame.width, height: icony)

    }
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
    @objc func selectIcon (_ recognizer : UITapGestureRecognizer){
        let itemNum = (itemIcons.index(of: recognizer.view! as! UIImageView)!)
        
        
        
        for i in itemIcons {
            i.transform = CGAffineTransform.identity.scaledBy(x: 1, y: 1)
        }
        recognizer.view!.transform = CGAffineTransform.identity.scaledBy(x: 1.2, y: 1.2)
        priceLabel.text = String(userShop[itemNum].amount[0])
        itemNameLabel.text = userShop[itemNum].name
        descriptionLabel.text = userShop[itemNum].description
        let descriptionScrollLength = heightForView(text: descriptionLabel.text!, font: descriptionLabel.font, width: descriptionLabel.frame.width)
        descriptionScrollView.contentSize = CGSize(width: descriptionScrollView.frame.width, height: descriptionScrollLength)
        
        itemInfoView.isHidden = false
        selectedItem = itemNum
        
    }
    
    @IBAction func purchase(_ sender: UIButton) {
        if userInventory[0].amount[0] >= userShop[selectedItem!].amount[0] {
            if Calendar.current.component(.day, from: Date()) != Calendar.current.component(.day, from: dailyRecord.day) {
                dailyRecord.clear()
            }
            dailyRecord.add(description: userShop[selectedItem!].name, amount: -userShop[selectedItem!].amount[0])
            addItem(item: userShop[selectedItem!])
            userInventory[0].amount[0] -= userShop[selectedItem!].amount[0]
            dollarAmount.text = String(userInventory[0].amount[0])
            saveData()
        } else {
            self.dollarAmount.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.dollarAmount.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            }
        }
    }
    
    func addItem (item : Item) {
        var found = false
        for i in 0..<userInventory.count {
            if item.name == userInventory[i].name {
                found = true
                        userInventory[i].amount[0] += 1
                        break
                
                
            }
        }
        if found == false {
            var newItem = item
            newItem.amount[0] = 1
            userInventory += [newItem]
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

}
