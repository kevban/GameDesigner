//
//  ViewController.swift
//  Game Designer
//
//  Created by jhp on 2018-08-20.
//  Copyright © 2018 Papaya. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var selectQuestType: UILabel!
    @IBOutlet var typeIcon: [UIButton]!
    @IBOutlet var frequencyTable: [UIButton]!
    
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var dailyLabel: UILabel!
    @IBOutlet weak var limitLabel: UILabel!
    @IBOutlet weak var repeatLabel: UILabel!
    
    
    @IBOutlet weak var questNameLabel: UILabel!
    
    
    @IBOutlet weak var limitDatePicker: UIDatePicker!
    @IBOutlet weak var questDescription: UILabel!
    @IBOutlet weak var questNameField: UITextField!
    
    @IBOutlet weak var descriptionField: UITextView!
    
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var diminishReturnButton: UIButton!
    
    
    @IBOutlet weak var limitView: UIView!
    
    @IBOutlet weak var dailyView: UIView!
    
    @IBOutlet weak var rewardScrollView: UIScrollView!
    
    @IBOutlet weak var itemView: UIView!
    @IBOutlet weak var itemIcon: UIImageView!
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var itemAmountField: UITextField!
    
    @IBOutlet weak var questTypeView: UIView!
    
    @IBOutlet weak var weekSelectorView: UIView!
    
    var type : Int?
    var typeNum : Int?
    var itemAmountFields : [UITextField] = []
    var oriPos : CGPoint?
    var frequency : [String] = []
    var diminishReturn = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.descriptionField.delegate = self as? UITextViewDelegate
        self.questNameField.delegate = self
        self.itemAmountField.delegate = self
        
        nextButton.isHidden = true
        nextButton.alpha = 0
        limitView.isHidden = true
        limitView.alpha = 0
        questNameLabel.alpha = 0
        questNameLabel.isHidden = true
        questNameField.isHidden = true
        questNameField.alpha = 0
        questDescription.isHidden = true
        questDescription.alpha = 0
        descriptionField.isHidden = true
        descriptionField.alpha = 0
        dailyView.isHidden = true
        dailyView.alpha = 0
        rewardScrollView.contentSize = CGSize(width: rewardScrollView.frame.width, height: CGFloat(userItems.count*62+62))
        rewardScrollView.alpha = 0
        rewardScrollView.isHidden = true
        
        
        for i in 0..<userItems.count {
            let newItemView = UIView(frame: CGRect(x: self.itemView.frame.minX, y: self.itemView.frame.minY+(self.itemView.frame.height*CGFloat(i+1)), width: self.itemView.frame.width, height: self.itemView.frame.height) )
            let newItemIcon1 = UIImage(named: userItems[i].iconName)
            let newItemIcon = UIImageView.init(image: newItemIcon1)
            
            newItemIcon.frame = self.itemIcon.frame
            let newItemLabel = UILabel.init(frame: self.itemLabel.frame)
            newItemLabel.text = userItems[i].name
            newItemLabel.textAlignment = .center
            newItemLabel.font = self.itemLabel.font
            newItemLabel.numberOfLines = 0
            
            let newItemField = UITextField.init(frame: self.itemAmountField.frame)
            newItemField.delegate = self
            newItemField.textAlignment = .center
            newItemField.keyboardType = .numbersAndPunctuation
            newItemField.backgroundColor = UIColor.white
            let newItemImage = UIImageView.init(frame: CGRect(x: 0, y: 0, width: self.itemView.frame.width, height: self.itemView.frame.height))
            newItemImage.image = UIImage(named: "questframe")
            
            
            itemAmountFields += [newItemField]
            
            
            newItemView.addSubview(newItemImage)
            newItemView.addSubview(newItemIcon)
            newItemView.addSubview(newItemLabel)
            newItemView.addSubview(itemAmountFields[i])
            self.rewardScrollView.addSubview(newItemView)
            
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func weekSelected(_ sender: UIButton) {
        if sender.titleColor(for: .normal) == .black {
            frequency += [sender.currentTitle!]
            sender.setTitleColor(#colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1), for: .normal)
        } else {
            sender.setTitleColor(.black, for: .normal)
            for i in 0..<frequency.count {
                if frequency[i] == sender.currentTitle {
                    frequency.remove(at: i)
                    break
                }
            }
        }
        
    }
    
    
    @IBAction func chooseFreqency(_ sender: UIButton) {
        if sender.currentTitle == "Daily" {
            frequency = ["Daily"]
            nextButton.isHidden = false
            next(nextButton)
        } else if sender.currentTitle == "Weekly" {
            UIView.transition(with: view, duration: 0.4, options: [.transitionCrossDissolve], animations: {
                self.dailyView.alpha = 0
                self.weekSelectorView.alpha = 1
            }, completion: { finished in
                self.nextButton.isHidden = false
                self.weekSelectorView.isHidden = false
                self.dailyView.isHidden = true
            })
            
            
        }
    }
    
    @IBAction func diminishingReturn(_ sender: UIButton) {
        if diminishReturn {
            diminishReturn = false
            diminishReturnButton.setImage(UIImage(named: "blankicon"), for: .normal)
        } else {
            diminishReturn = true
            diminishReturnButton.setImage(UIImage(named: "checkmark"), for: .normal)
        }
    }
    
    
    
    @IBAction func typeButton(_ sender: UIButton) {
        type = typeIcon.index(of: sender)!
        typeNum = type
        
        UIView.transition(with: view, duration: 0.4, options: [.transitionCrossDissolve], animations: {
            self.oriPos = sender.center
            print (self.selectQuestType.center)
            sender.center = CGPoint (x: self.view.frame.width/2-20, y: self.selectQuestType.center.y-180)
            self.questDescription.alpha = 1
            self.questNameField.alpha = 1
            self.descriptionField.alpha = 1
            if self.type == 0 {
                self.typeIcon[1].alpha = 0
                self.typeIcon[3].alpha = 0
                self.typeIcon[2].alpha = 0
            } else if self.type == 1 {
                self.typeIcon[2].alpha = 0
                self.typeIcon[0].alpha = 0
                self.typeIcon[3].alpha = 0
            } else if self.type == 2{
                self.typeIcon[1].alpha = 0
                self.typeIcon[0].alpha = 0
                self.typeIcon[3].alpha = 0
            } else {
                self.typeIcon[1].alpha = 0
                self.typeIcon[0].alpha = 0
                self.typeIcon[2].alpha = 0
            }
            self.mainLabel.alpha = 0
            self.dailyLabel.alpha = 0
            self.limitLabel.alpha = 0
            self.repeatLabel.alpha = 0
            self.nextButton.alpha = 1
            self.selectQuestType.text = ""
            self.questNameLabel.alpha = 1
            
        }, completion:{ finished in
            sender.isUserInteractionEnabled = false
            self.questTypeView.isUserInteractionEnabled = false
            self.questNameField.isHidden = false
            self.questDescription.isHidden = false
           self.questNameLabel.isHidden = false
            self.descriptionField.isHidden = false
            self.mainLabel.isHidden = true
            self.dailyLabel.isHidden = true
            self.limitLabel.isHidden = true
            if self.type == 0 {
                self.typeIcon[1].isHidden = true
                self.typeIcon[2].isHidden = true
                self.typeIcon[3].isHidden = true
            } else if self.type == 1 {
                self.typeIcon[2].isHidden = true
                self.typeIcon[0].isHidden = true
                self.typeIcon[3].isHidden = true
            } else if self.type == 2{
                self.typeIcon[1].isHidden = true
                self.typeIcon[0].isHidden = true
                self.typeIcon[3].isHidden = true
            } else {
                self.typeIcon[1].isHidden = true
                self.typeIcon[0].isHidden = true
                self.typeIcon[2].isHidden = true
            }
            self.nextButton.isHidden = false
        })
        
    }
    
    
    @IBAction func back(_ sender: UIButton) {
        if questNameLabel.alpha == 1 {
            UIView.transition(with: view, duration: 0.4, options: [.transitionCrossDissolve], animations: {
                self.typeIcon[self.type!].center = self.oriPos!
                self.typeIcon[self.type!].isUserInteractionEnabled = true
                self.questDescription.alpha = 0
                self.questNameField.alpha = 0
                self.questNameLabel.alpha = 0
                self.descriptionField.alpha = 0
                
                self.typeIcon[1].alpha = 1
                self.typeIcon[2].alpha = 1
                self.typeIcon[0].alpha = 1
                self.typeIcon[3].alpha = 1
                self.mainLabel.alpha = 1
                self.dailyLabel.alpha = 1
                self.limitLabel.alpha = 1
                self.repeatLabel.alpha = 1
                self.nextButton.alpha = 0
                self.selectQuestType.text = "Select Quest Type"
                
            }, completion:{ finished in
                self.questNameField.isHidden = true
                self.questNameLabel.isHidden = true
                self.questDescription.isHidden = true
                self.descriptionField.isHidden = true
                self.questTypeView.isUserInteractionEnabled = true
                self.mainLabel.isHidden = false
                self.dailyLabel.isHidden = false
                self.limitLabel.isHidden = false
                self.repeatLabel.isHidden = false
                self.typeIcon[0].isHidden = false
                self.typeIcon[1].isHidden = false
                self.typeIcon[2].isHidden = false
                self.typeIcon[3].isHidden = false
                self.nextButton.isHidden = true
            })
        } else if limitView.alpha == 1 || dailyView.alpha == 1{
            UIView.transition(with: view, duration: 0.4, options: [.transitionCrossDissolve], animations: {
                self.questDescription.alpha = 1
                self.questNameLabel.alpha = 1
                self.questNameField.alpha = 1
                self.descriptionField.alpha = 1
                self.dailyView.alpha = 0
                self.limitView.alpha = 0
            }, completion:{ finished in
                self.nextButton.setTitle("Next", for: .normal)
                self.questNameField.isHidden = false
                self.questNameLabel.isHidden = false
                self.questDescription.isHidden = false
                self.descriptionField.isHidden = false
                self.typeNum = self.type!
                self.dailyView.isHidden = true
                self.limitView.isHidden = true
                
            })
        } else if rewardScrollView.alpha == 1 {
            UIView.transition(with: view, duration: 0.4, options: [.transitionCrossDissolve], animations: {
                self.nextButton.setTitle("Next", for: .normal)
                self.rewardScrollView.alpha = 0
               
                if self.type == 0 {
                    self.dailyView.alpha = 1
                } else if self.type == 2 {
                    self.limitView.alpha = 1
                } else {
                    self.questDescription.alpha = 1
                    self.questNameLabel.alpha = 1
                    self.questNameField.alpha = 1
                    self.descriptionField.alpha = 1
                    
                }
            }, completion:{ finished in
                self.selectQuestType.text = ""
                self.rewardScrollView.isHidden = true
                if self.type == 0 {
                    self.dailyView.isHidden = false
                } else if self.type == 2 {
                    self.limitView.isHidden = false
                } else {
                    self.questNameField.isHidden = false
                    self.questDescription.isHidden = false
                    self.questNameField.isHidden = false
                    self.descriptionField.isHidden = false
                }
                
            })
        } else if weekSelectorView.isHidden == false {
            UIView.transition(with: view, duration: 0.4, options: [.transitionCrossDissolve], animations: {
                self.nextButton.setTitle("Next", for: .normal)
                self.weekSelectorView.alpha = 0
                
                if self.type == 0 {
                    self.dailyView.alpha = 1
                } else if self.type == 2 {
                    self.limitView.alpha = 1
                } else {
                    self.questDescription.alpha = 1
                    self.questNameLabel.alpha = 1
                    self.questNameField.alpha = 1
                    self.descriptionField.alpha = 1
                    
                }
            }, completion:{ finished in
                self.selectQuestType.text = ""
                self.weekSelectorView.isHidden = true
                if self.type == 0 {
                    self.dailyView.isHidden = false
                } else if self.type == 2 {
                    self.limitView.isHidden = false
                } else {
                    self.questNameField.isHidden = false
                    self.questDescription.isHidden = false
                    self.questNameField.isHidden = false
                    self.descriptionField.isHidden = false
                }
                
            })
        }
        else {
            performSegue(withIdentifier: "newQuestToGM", sender: nil)
        }
    }
    
    
    @IBAction func next(_ sender: UIButton) {
        var questReward : [Item] = []
        if sender.currentTitle == "Create" {
            if Int(itemAmountField.text!) != nil {
                
                var reward = cash
                reward.amount[0] = Int(itemAmountField.text!)!
                if reward.amount[0] > 0 {
                    questReward += [reward]
                }
                
            } else {
                if itemAmountField.text!.contains("~") {
                    var index1 = itemAmountField.text!.index(of: "~")
                    let range1 = itemAmountField.text!.prefix(upTo: index1!)
                    if Int(range1) != nil {
                        index1 = itemAmountField.text!.index(index1!,offsetBy: 1)
                        let range2 = itemAmountField.text!.suffix(from: index1!)
                        print (range2)
                        if Int(range2) != nil {
                            var reward = cash
                            
                            reward.amount[0] = Int(range1)!
                            reward.amount[1] = Int(range2)!
                            questReward += [reward]
                        }
                        
                    }
                } else if itemAmountField.text!.contains("%") {
                    let index1 = itemAmountField.text!.index(of: "%")
                    let range1 = itemAmountField.text!.prefix(upTo: index1!)
                    var reward = cash
                    reward.amount[0] = Int(range1)!
                    reward.amount[1] = -1
                    questReward += [reward]
                    
                }
            }
            for s in 0..<itemAmountFields.count {
                if Int(itemAmountFields[s].text!) != nil {
                    
                     var reward = userItems[s]
                    reward.amount[0] = Int(itemAmountFields[s].text!)!
                    if reward.amount[0] > 0 {
                        questReward += [reward]
                    }
                    
                } else {
                    if itemAmountFields[s].text!.contains("~") {
                        var index2 = itemAmountFields[s].text!.index(of: "~")
                        let range1 = itemAmountFields[s].text!.prefix(upTo: index2!)
                        if Int(range1) != nil {
                            index2 = itemAmountFields[s].text!.index(index2!,offsetBy: 1)
                            let range2 = itemAmountFields[s].text!.suffix(from: index2!)
                            if Int(range2) != nil {
                                var reward = userItems[s]
                                
                                reward.amount[0] = Int(range1)!
                                reward.amount[1] = Int(range2)!
                                questReward += [reward]
                            }
                            
                        }
                    } else if itemAmountFields[s].text!.contains("%") {
                        print ("done")
                        let index1 = itemAmountFields[s].text!.index(of: "%")
                        let range1 = itemAmountFields[s].text!.prefix(upTo: index1!)
                        var reward = userItems[s]
                        reward.amount[0] = Int(range1)!
                        reward.amount[1] = -1
                        questReward += [reward]
                        
                    }
                }
            }
            if type == 0 {
                var quest = Quest.init(questNameField.text!, descriptionField.text!, type!, reward: questReward)
                quest.repeats = frequency
                userDailyQuests += [quest]
                saveData()
                performSegue(withIdentifier: "newQuestToGM", sender: nil)
            } else if type == 1 {
                userMainQuests += [Quest.init(questNameField.text!, descriptionField.text!, type!, reward: questReward)]
                saveData()
                performSegue(withIdentifier: "newQuestToGM", sender: nil)
                
            } else if type == 2 {
                var quest = Quest.init(questNameField.text!, descriptionField.text!, type!, reward: questReward)
                let day = limitDatePicker.date
                quest.dueDate = day
                if diminishReturn == true {
                    quest.diminish = true
                    quest.dateStarted = Date()
                } else {
                    quest.diminish = false
                }
                userLimitQuests += [quest]
                saveData()
                performSegue(withIdentifier: "newQuestToGM", sender: nil)
            } else if type == 3 {
                userRepeatQuests += [Quest.init(questNameField.text!, descriptionField.text!, type!, reward: questReward)]
                saveData()
                performSegue(withIdentifier: "newQuestToGM", sender: nil)
            }
        } else {
        UIView.transition(with: view, duration: 0.4, options: [.transitionCrossDissolve], animations: {
            self.questDescription.alpha = 0
            self.questNameLabel.alpha = 0
            self.questNameField.alpha = 0
            self.descriptionField.alpha = 0
            if self.typeNum == 0 {
                self.dailyView.alpha = 1
            } else if self.typeNum == 2 {
                self.limitView.alpha = 1
            } else {
                self.weekSelectorView.alpha = 0
                self.dailyView.alpha = 0
                self.limitView.alpha = 0
                self.rewardScrollView.alpha = 1
                self.selectQuestType.text = "Select Reward"
                sender.setTitle("Create", for: .normal)
                
            }
        }, completion:{ finished in
            self.questNameField.isHidden = true
            self.questDescription.isHidden = true
            self.questNameField.isHidden = true
            self.descriptionField.isHidden = true
            if self.typeNum == 0 {
                self.dailyView.isHidden = false
                self.nextButton.isHidden = true
                self.typeNum = -1
            } else if self.typeNum == 2 {
                self.limitView.isHidden = false
                self.typeNum = -1
            } else {
                self.rewardScrollView.isHidden = false
                self.weekSelectorView.isHidden = true
                self.limitView.isHidden = true
                self.dailyView.isHidden = true
                sender.setTitle("Create", for: .normal)
                
            }
            
        })
    }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        itemAmountField.resignFirstResponder()
        for i in itemAmountFields {
            i.resignFirstResponder()
        }
        questNameField.resignFirstResponder()
        descriptionField.resignFirstResponder()
        return true
    }
    
}

