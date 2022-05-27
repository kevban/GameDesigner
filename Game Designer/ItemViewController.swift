//
//  ItemViewController.swift
//  Game Designer
//
//  Created by jhp on 2018-08-31.
//  Copyright © 2018 Papaya. All rights reserved.
//

import UIKit

class ItemViewController: UIViewController {

    
    @IBOutlet weak var itemName: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var descriptionScrollView: UIScrollView!
    
    @IBOutlet weak var itemScrollView: UIScrollView!
    
    @IBOutlet weak var removeButton: UIButton!
    
    @IBOutlet weak var consumeButton: UIButton!
    
    var itemSelectedNum : Int?
    
    var inventorySpace : [UIImageView] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        consumeButton.isHidden = true
        itemName.isHidden = true
        descriptionLabel.isHidden = true
        
        drawIcons()
        // Do any additional setup after loading the view.
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

    
    
    func drawIcons () {
        inventorySpace.removeAll()
        for i in itemScrollView.subviews {
            i.removeFromSuperview()
        }
        var first = true
        
        
        
        if status == "GMMode" {
            var iconx = 10
            var icony = 10
            var count = 1
            for i in 0..<userItems.count {
                let imageIcon = UIImageView(image: UIImage(named: userItems[i].iconName))
                
                let newTapGesture = UITapGestureRecognizer(target: self, action: #selector (gmSelect(_:)))
                imageIcon.addGestureRecognizer(newTapGesture)
                imageIcon.isUserInteractionEnabled = true
                imageIcon.frame = CGRect(x: iconx, y: icony, width: 64, height: 64)
                iconx += 74
                if count == 4 {
                    iconx = 10
                    icony += 74
                    count = 0
                }
                count += 1
                inventorySpace += [imageIcon]
                itemScrollView.contentSize = CGSize(width: itemScrollView.frame.width, height: CGFloat(icony+74))
                itemScrollView.addSubview(imageIcon)
            }
        } else {
            var iconx = 10
            var icony = 10
            var count = 1
        
        
        for i in 0..<userInventory.count {
            
            if first {
                first = false
            } else {
            let amountLabel = UILabel(frame: CGRect(x: 5, y: 0, width: 64, height: 16))
                if userInventory[i].amount[0] > 1 {
                    amountLabel.text = String(userInventory[i].amount[0])
                } else {
                    amountLabel.text = ""
                }
                let imageIcon = UIImageView(image: UIImage(named: userInventory[i].iconName))
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector (selectItem(_:) ))
                imageIcon.frame = CGRect(x: iconx, y: icony, width: 64, height: 64)
                iconx += 74
                if count == 4 {
                    iconx = 10
                    icony += 74
                    count = 0
                }
                count += 1
                itemScrollView.contentSize = CGSize(width: itemScrollView.frame.width, height: CGFloat(icony+74))
                inventorySpace += [imageIcon]
                imageIcon.addSubview(amountLabel)
                imageIcon.addGestureRecognizer(tapGesture)
                imageIcon.isUserInteractionEnabled = true
                itemScrollView.addSubview(imageIcon)
            }
        }
        }
    }
    
    @objc func gmSelect(_ recognizer : UITapGestureRecognizer) {
        switch recognizer.state {
        case.ended:
            let itemNum = (inventorySpace.index(of: recognizer.view! as! UIImageView)!)
            descriptionLabel.text = userItems[itemNum].description
            
            let descriptionScrollLength = heightForView(text: descriptionLabel.text!, font: descriptionLabel.font, width: descriptionLabel.frame.width)
            descriptionScrollView.contentSize = CGSize(width: descriptionScrollView.frame.width, height: descriptionScrollLength)
            itemName.text = userItems[itemNum].name
            removeButton.isHidden = false
            itemName.isHidden = false
            descriptionLabel.isHidden = false
            for s in inventorySpace {
                s.transform = CGAffineTransform.identity.scaledBy(x: 1, y: 1)
            }
            recognizer.view!.transform = CGAffineTransform.identity.scaledBy(x: 1.2, y: 1.2)
            itemSelectedNum = itemNum
        default : break
        }
    }
    
    
    @IBAction func remove(_ sender: UIButton) {
        userItems.remove(at: itemSelectedNum!)
        saveData()
        performSegue(withIdentifier: "itemToGM", sender: nil)
    }
    
    
    
    
    @objc func selectItem (_ recognizer : UITapGestureRecognizer) {
        switch recognizer.state {
        case.ended:
            let itemNum = (inventorySpace.index(of: recognizer.view! as! UIImageView)!)
            descriptionLabel.text = userInventory[itemNum+1].description
            
            let descriptionScrollLength = heightForView(text: descriptionLabel.text!, font: descriptionLabel.font, width: descriptionLabel.frame.width)
            descriptionScrollView.contentSize = CGSize(width: descriptionScrollView.frame.width, height: descriptionScrollLength)
            itemName.text = userInventory[itemNum+1].name
            consumeButton.isHidden = false
            itemName.isHidden = false
            descriptionLabel.isHidden = false
            for s in inventorySpace {
                s.transform = CGAffineTransform.identity.scaledBy(x: 1, y: 1)
            }
                recognizer.view!.transform = CGAffineTransform.identity.scaledBy(x: 1.2, y: 1.2)
            itemSelectedNum = itemNum + 1
        default : break
        }
    }
    
    
    @IBAction func back(_ sender: UIButton) {
        if status == "GMMode" {
            performSegue(withIdentifier: "itemToGM", sender: nil)
            
        } else {
            performSegue(withIdentifier: "itemToLanding", sender: nil)
        }
    }
    
    
    
    
    @IBAction func consume(_ sender: UIButton) {
        
        
        userInventory[itemSelectedNum!].amount[0] -= 1
    
        if userInventory[itemSelectedNum!].amount[0] <= 0 {
            for s in inventorySpace {
                s.transform = CGAffineTransform.identity.scaledBy(x: 1, y: 1)
            }
            consumeButton.isHidden = true
            itemName.isHidden = true
            descriptionLabel.isHidden = true
            userInventory.remove(at: itemSelectedNum!)
        }
        drawIcons()
        saveData()
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
