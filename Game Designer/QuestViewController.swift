//
//  QuestViewController.swift
//  Game Designer
//
//  Created by jhp on 2018-08-20.
//  Copyright © 2018 Papaya. All rights reserved.
//

import UIKit

class QuestViewController: UIViewController {

    @IBOutlet weak var questNameLabel: UILabel!
    
    @IBOutlet weak var questScrollView: UIScrollView!
    
    @IBOutlet weak var questView: UIView!
    
    @IBOutlet weak var questSubtitle: UILabel!
    @IBOutlet weak var questName: UILabel!
    
    @IBOutlet weak var questImage: UIImageView!
    
    @IBOutlet weak var questsLabel: UILabel!
    
    @IBOutlet weak var selectQuestView: UIView!
    @IBOutlet weak var selectQuestName: UILabel!
    
    @IBOutlet weak var selectQuestDescription: UILabel!
    @IBOutlet weak var selectQuestIcon: UIImageView!
    
    @IBOutlet weak var descriptionScrollView: UIScrollView!
    
    @IBOutlet weak var back2u: UIButton!
    
    @IBOutlet weak var rewardScrollView: UIScrollView!
    @IBOutlet weak var rewardView: UIView!
    @IBOutlet weak var rewardAmount: UILabel!
    @IBOutlet weak var rewardName: UILabel!
    @IBOutlet weak var rewardIcon: UIImageView!
    
    @IBOutlet weak var completeButton: UIButton!
    
    @IBOutlet weak var rewardPopupView: UIView!
    
    @IBOutlet weak var rewardPopup: UIView!
    
    @IBOutlet weak var rewardPopupIcon: UIImageView!
    
    @IBOutlet weak var xLabel: UILabel!
    
    @IBOutlet weak var rewardPopupAmount: UILabel!
    
    
    var quest : Quest?
    var questNum : Int?
    var rewardPopupPos : CGFloat = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.selectQuestView.frame = CGRect(x: self.selectQuestView.frame.minX, y: self.selectQuestView.frame.minY-600, width: self.selectQuestView.frame.width, height: self.selectQuestView.frame.height)
        rewardPopupView.isHidden = true
        drawAllQuests()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        drawAllQuests()
    }
    
    func drawAllQuests () {
        var questPos : CGFloat = 0
        var firsts = true
        
        if status == "GMMode" {
            for i in 0..<userLimitQuests.count {
                drawEditQuests(i: i, type: 2, s: questPos)
                questPos += 76
            }
            for i in 0..<userDailyQuests.count {
                drawEditQuests(i: i, type: 0, s: questPos)
                questPos += 76
            }
            for i in 0..<userMainQuests.count {
                drawEditQuests(i: i, type: 1, s: questPos)
                questPos += 76
            }
            for i in 0..<userRepeatQuests.count {
                drawEditQuests(i: i, type: 3, s: questPos)
                questPos += 76
            }
            questScrollView.contentSize = CGSize(width: questScrollView.frame.width, height: questPos)
        } else {
        
        
        for s in questScrollView.subviews {
            if firsts {
                firsts = false
            } else {
                s.removeFromSuperview()
            }
        }
            var questsToRemove : [Int] = []
        for i in 0..<userLimitQuests.count {
            let diffInDays = Calendar.current.dateComponents([.day], from: Date(), to: userLimitQuests[i].dueDate!).day
            if diffInDays!<0 {
                questsToRemove += [i]
            } else {
            userLimitQuests[i].dayRemaining = diffInDays!
            }
        }
            for i in questsToRemove {
                userLimitQuests.remove(at: i)
            }
        
        if Calendar.current.component(.weekday, from: Date()) == 1 {
            for i in 0..<userDailyQuests.count {
                if userDailyQuests[i].evenDays != nil {
                    userDailyQuests[i].evenDays! = !userDailyQuests[i].evenDays!
                }
            }
        }
        
        
        userLimitQuests.sort {
            $0.dayRemaining! < $1.dayRemaining!
        }
        
        // Do any additional setup after loading the view.
        for i in 0..<userLimitQuests.count {
            drawQuests(i: i, type: 2, s: questPos)
            questPos += 76
            
        }
        
        for i in 0..<userDailyQuests.count {
            let weekday = Calendar.current.component(.weekday, from: Date())
            if userDailyQuests[i].done == true {
                if userDailyQuests[i].doneDate != nil {
                    let daysDiff = Calendar.current.dateComponents([.day], from: Date(), to: userDailyQuests[i].doneDate!).day
                    if daysDiff! > 1 || daysDiff! < -1 {
                        userDailyQuests[i].dayRemaining = 0
                        userDailyQuests[i].description = ""
                    }
                    if !Calendar.current.isDateInToday(userDailyQuests[i].doneDate!) {
                        userDailyQuests[i].done = false
                    }
                }
                
            }
            for s in userDailyQuests[i].repeats {
            if s == "Daily" {
                drawQuests(i: i, type: 0, s : questPos)
                questPos += 76
            }
            else if s == "Mondays" {
                if weekday == 2 {
                    drawQuests(i: i, type: 0, s : questPos)
                    questPos += 76
                }
            } else if s == "Tuesdays" {
                if weekday == 3 {
                    drawQuests(i: i, type: 0, s: questPos)
                    questPos += 76
                }
            } else if s == "Wednesdays" {
                if weekday == 4 {
                    drawQuests(i: i, type: 0, s: questPos)
                    questPos += 76
                }
            } else if s == "Thursdays" {
                if weekday == 5 {
                    drawQuests(i: i, type: 0, s: questPos)
                    questPos += 76
                }
            } else if s == "Fridays" {
                if weekday == 6 {
                    drawQuests(i: i, type: 0, s: questPos)
                    questPos += 76
                }
            } else if s == "Saturdays" {
                if weekday == 7 {
                    drawQuests(i: i, type: 0, s: questPos)
                    questPos += 76
                }
            } else if s == "Sundays" {
                if weekday == 1 {
                    drawQuests(i: i, type: 0, s: questPos)
                    questPos += 76
                }
            }
            }
        }
        
        for i in 0..<userMainQuests.count {
            drawQuests(i: i, type: 1, s: questPos)
            questPos += 76
        }
            for i in 0..<userRepeatQuests.count {
                drawQuests(i: i, type: 3, s: questPos)
                questPos += 76
            }
            questScrollView.contentSize = CGSize(width: questScrollView.frame.width, height: questPos)
        }
    }
    
    func drawEditQuests (i : Int, type: Int, s: CGFloat) {
        
        let newQuestView = QuestView()
        let newQuestName = UILabel()
        
        
        let newQuestSubtitle = UILabel()
        let newQuestImage = UIImageView(frame: questImage.frame)
        
        
        if type == 2 {
            newQuestImage.image = UIImage(named: "!mark")
            newQuestView.quest = userLimitQuests[i]
            newQuestView.questNum = i
            newQuestSubtitle.text = "\(Calendar.current.component(.year, from:  userLimitQuests[i].dueDate!))/\(Calendar.current.component(.month, from:  userLimitQuests[i].dueDate!))/\(Calendar.current.component(.day, from:  userLimitQuests[i].dueDate!))"
            newQuestName.text = userLimitQuests[i].name
        } else if type == 1 {
            newQuestImage.image = UIImage(named: "main")
            newQuestView.quest = userMainQuests[i]
            newQuestView.questNum = i
            newQuestSubtitle.text = "Main Quest"
            newQuestName.text = userMainQuests[i].name
        } else if type == 0 {
            newQuestImage.image = UIImage(named: "daily")
            newQuestView.quest = userDailyQuests[i]
            newQuestView.questNum = i
            if userDailyQuests[i].repeats.count > 1 {
                newQuestSubtitle.text = "Weekly"
            }else {
                newQuestSubtitle.text = "\(userDailyQuests[i].repeats[0])"
            }
            newQuestName.text = userDailyQuests[i].name
            
        } else if type == 3 {
            newQuestImage.image = UIImage(named: "repeat")
            newQuestView.quest = userRepeatQuests[i]
            newQuestView.questNum = i
            newQuestSubtitle.text = "Repeat"
            newQuestName.text = userRepeatQuests[i].name
            
        }
        newQuestView.frame = CGRect(x: 0, y: s, width: questView.frame.width, height: questView.frame.height)
        newQuestName.frame = questName.frame
        newQuestName.textAlignment = .center
        newQuestName.font = questName.font
        
        newQuestSubtitle.frame = questSubtitle.frame
        newQuestSubtitle.textAlignment = .center
        newQuestSubtitle.font = questSubtitle.font
        let newQuestBoarder = UIImageView(frame: CGRect(x: 0, y: 0, width: newQuestView.frame.width, height: newQuestView.frame.height))
        newQuestBoarder.image = UIImage(named: "questframe")
        
        newQuestView.addSubview(newQuestSubtitle)
        newQuestView.addSubview(newQuestImage)
        newQuestView.addSubview(newQuestBoarder)
        newQuestView.addSubview(newQuestName)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector (showQuest(_:)))
        
        newQuestView.addGestureRecognizer(tapGesture)
        questScrollView.addSubview(newQuestView)
    }
    
    
    func drawQuests (i: Int, type: Int, s: CGFloat){
        let newQuestView = QuestView()
        let newQuestName = UILabel()
        
        
        let newQuestSubtitle = UILabel()
        let newQuestImage = UIImageView(frame: questImage.frame)
        
        if type == 2 {
            newQuestImage.image = UIImage(named: "!mark")
            newQuestView.quest = userLimitQuests[i]
            newQuestView.questNum = i
            newQuestSubtitle.text = "\(userLimitQuests[i].dayRemaining!) days left"
            newQuestName.text = userLimitQuests[i].name
        } else if type == 1 {
            newQuestImage.image = UIImage(named: "main")
            newQuestView.quest = userMainQuests[i]
            newQuestView.questNum = i
            newQuestSubtitle.text = "Main Quest"
            newQuestName.text = userMainQuests[i].name
        } else if type == 0 {
            if userDailyQuests[i].done == true {
                
                newQuestImage.image = UIImage(named: "checkmark")
                newQuestView.isUserInteractionEnabled = false
            } else {
                newQuestImage.image = UIImage(named: "daily")
            }
            newQuestView.quest = userDailyQuests[i]
            newQuestView.questNum = i
            if userDailyQuests[i].repeats.count > 1 {
                newQuestSubtitle.text = "Weekly"
            }else {
                newQuestSubtitle.text = "\(userDailyQuests[i].repeats[0])"
            }
            
            newQuestName.text = userDailyQuests[i].name
        } else if type == 3 {
            newQuestImage.image = UIImage(named: "repeat")
            newQuestView.quest = userRepeatQuests[i]
            newQuestView.questNum = i
            newQuestSubtitle.text = "Repeat Quest"
            newQuestName.text = userRepeatQuests[i].name
        }
        
        
        
        newQuestView.frame = CGRect(x: 0, y: s, width: questView.frame.width, height: questView.frame.height)
        newQuestName.frame = questName.frame
        newQuestName.textAlignment = .center
        newQuestName.font = questName.font
        
        newQuestSubtitle.frame = questSubtitle.frame
        newQuestSubtitle.textAlignment = .center
        newQuestSubtitle.font = questSubtitle.font
        let newQuestBoarder = UIImageView(frame: CGRect(x: 0, y: 0, width: newQuestView.frame.width, height: newQuestView.frame.height))
        newQuestBoarder.image = UIImage(named: "questframe")
        
        newQuestView.addSubview(newQuestSubtitle)
        newQuestView.addSubview(newQuestImage)
        newQuestView.addSubview(newQuestBoarder)
        newQuestView.addSubview(newQuestName)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector (showQuest(_:)))
        
        newQuestView.addGestureRecognizer(tapGesture)
        questScrollView.addSubview(newQuestView)
        
        
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
    
    
    
    @objc func showQuest (_ recognizer : UITapGestureRecognizer) {
        switch recognizer.state {
        case.ended:
            var scrollLength : CGFloat = 0
            if status == "GMMode" {
                completeButton.setTitle("Remove", for: .normal)
                
            }
            
            questScrollView.isUserInteractionEnabled = false
            quest = (recognizer.view! as! QuestView).quest!
            questNum = (recognizer.view! as! QuestView).questNum!
            selectQuestName.text = quest!.name
            
            if quest!.type == 0 {
                
                    selectQuestIcon.image = UIImage(named: "daily")
            } else if quest!.type == 1 {
                selectQuestIcon.image = UIImage(named: "main")
            } else if quest!.type == 2 {
                selectQuestIcon.image = UIImage(named: "!mark")
            } else if quest!.type == 3 {
                selectQuestIcon.image = UIImage(named: "repeat")
            }
            selectQuestDescription.text = quest!.description
            
            let descriptionScrollLength = heightForView(text: selectQuestDescription.text!, font: selectQuestDescription.font, width: selectQuestDescription.frame.width)
            descriptionScrollView.contentSize = CGSize(width: descriptionScrollView.frame.width, height: descriptionScrollLength)
            
            for i in 0..<quest!.reward.count {
                scrollLength = CGFloat(i*48)
                
                let newRewardView = UIView(frame: CGRect(x: rewardView.frame.minX, y: rewardView.frame.minY+scrollLength, width: rewardView.frame.width, height: rewardView.frame.height))
                let newRewardIcon1 = UIImage.init(named: quest!.reward[i].iconName)
                let newRewardIcon = UIImageView(frame: rewardIcon.frame)
                newRewardIcon.image = newRewardIcon1
                let newRewardName = UILabel(frame: rewardName.frame)
                newRewardName.text = quest!.reward[i].name
                newRewardName.font = rewardName.font
                newRewardName.textAlignment = .center
                let newRewardAmount = UILabel(frame:rewardAmount.frame)
                newRewardAmount.font = rewardName.font
                newRewardAmount.textAlignment = .center
                if quest!.reward[i].amount[1] > 0 {
                    if quest!.reward[i].amount[0]<=0 && status != "GMMode" {
                        newRewardAmount.text = "?"
                    } else {
                    newRewardAmount.text = "\(quest!.reward[i].amount[0])~\(quest!.reward[i].amount[1])"
                    }
                } else if quest!.reward[i].amount[1] < 0 {
                    newRewardAmount.text = String("\(quest!.reward[i].amount[0])%")
                } else {
                    newRewardAmount.text = String("\(quest!.reward[i].amount[0])")
                }
                newRewardView.addSubview(newRewardName)
                newRewardView.addSubview(newRewardIcon)
                newRewardView.addSubview(newRewardAmount)
                
                rewardScrollView.addSubview(newRewardView)
                
                
                
            }
            rewardScrollView.contentSize = CGSize(width: rewardScrollView.frame.width, height: scrollLength+48)
            
            
            view.bringSubviewToFront(selectQuestView)
            
            selectQuestView.isHidden = false
           
            
            UIView.transition(with: selectQuestView, duration: 0.6, options: [.curveEaseIn], animations: {
                self.back2u.isHidden = true
                self.questsLabel.isHidden = true
                self.selectQuestView.frame = CGRect(x: self.selectQuestView.frame.minX, y: self.selectQuestView.frame.minY+600, width: self.selectQuestView.frame.width, height: self.selectQuestView.frame.height)
            })
        default: break
        }
        
    }
    
    @IBAction func complete(_ sender: UIButton) {
        if sender.currentTitle == "Remove" {
            if quest!.type == 0 {
                userDailyQuests.remove(at: questNum!)
               
            } else if quest!.type == 1 {
                userMainQuests.remove(at: questNum!)
            } else if quest!.type == 2 {
                userLimitQuests.remove(at: questNum!)
                
            } else if quest!.type == 3 {
                userRepeatQuests.remove(at:questNum!)
            }
            performSegue(withIdentifier: "questToGM", sender: nil)
            saveData()
        } else {
        
        if quest!.type == 0 {
            for i in quest!.reward {
                /*if i.name == "Cash" {
                    if userDailyQuests[questNum!].dayRemaining != nil {
                        var k = Item.init("Cash", "", icon: "dollarsignicon")
                        let z = max(1.3, (Double(1 + userDailyQuests[questNum!].dayRemaining! / 10)))
                        k.amount[0] = Int(z * Double(i.amount[0]))
                        addItem(item: k)
                    }
                    else {
                        addItem(item: i)
                    }
                    
                }
                else {
                    addItem(item: i)
                }*/
                addItem(item: i)
            }
            userDailyQuests[questNum!].done = true
            userDailyQuests[questNum!].doneDate = Date()
            /*if userDailyQuests[questNum!].dayRemaining == nil {
                userDailyQuests[questNum!].dayRemaining = 1
                userDailyQuests[questNum!].description = "\(String(describing: userDailyQuests[questNum!].dayRemaining))"
            }
            else {
                userDailyQuests[questNum!].dayRemaining! += 1
                userDailyQuests[questNum!].description = "\(String(describing: userDailyQuests[questNum!].dayRemaining))"
            }*/
            saveData()
            drawAllQuests()
        } else if quest!.type == 3 {
            for i in quest!.reward {
                addItem(item: i)
            }
            saveData()
            drawAllQuests()
        }else if quest!.type == 1 {
            for i in quest!.reward {
                addItem(item: i)
            }
            userMainQuests.remove(at: questNum!)
            saveData()
            drawAllQuests()
        } else if quest!.type == 2 {
            for i in quest!.reward {
                addItem(item: i)
            }
            userLimitQuests.remove(at: questNum!)
            saveData()
            drawAllQuests()
        }
        UIView.transition(with: selectQuestView, duration: 0.6, options: [.curveEaseIn], animations: {
            self.selectQuestView.center = CGPoint(x: self.selectQuestView.center.x, y: self.selectQuestView.center.y-600)
        }, completion: {finished in
            self.back2u.isHidden = false
            self.selectQuestView.isHidden = true
            self.questsLabel.isHidden = false
            self.questScrollView.isUserInteractionEnabled = true
            var first = true
            for i in self.rewardScrollView.subviews {
                if first {
                    first = false
                } else {
                    i.removeFromSuperview()
                }
                
            }
            self.rewardPopupView.isHidden = false
            UIView.transition(with: self.rewardPopupView, duration: 0.2, options: [.transitionCrossDissolve], animations: {
                self.rewardPopupView.alpha = 1
            }, completion: {finished in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    UIView.transition(with: self.rewardPopupView, duration: 0.2, options: [.transitionCrossDissolve], animations: {
                        self.rewardPopupView.alpha = 0
                    }, completion: {finished in
                        self.rewardPopupView.isHidden = true
                        self.rewardPopupPos = 0
                        var aFirst = 3
                        for i in self.rewardPopupView.subviews {
                            if aFirst > 0 {
                                aFirst -= 1
                            } else {
                                i.removeFromSuperview()
                            }
                        }
                        print (self.rewardPopupView.subviews[0])
                    })
                }
            })
        })
        }
    }
    
    func addItem (item : Item) {
        var found = false
        let newRewardPopup = UIView(frame: CGRect(x: rewardPopup.frame.minX, y: rewardPopup.frame.minY+(rewardPopup.frame.height)*rewardPopupPos, width: rewardPopup.frame.width, height: rewardPopup.frame.height))
        let newRewardPopupIcon = UIImageView(frame: rewardPopupIcon.frame)
        newRewardPopupIcon.image = UIImage(named: item.iconName)
        let newXLabel = UILabel(frame: xLabel.frame)
        newXLabel.font = xLabel.font
        newXLabel.text = xLabel.text
        let newRewardPopupAmount = UILabel(frame: rewardPopupAmount.frame)
        newRewardPopupAmount.font = rewardPopupAmount.font
        if item.name == "Cash" {
            
            rewardPopupPos += 1
            let savings = Int((item.amount[0]*bank[1])/100)
            print (savings)
            userInventory[0].amount[0] -= savings
            if Calendar.current.component(.day, from: Date()) != Calendar.current.component(.day, from: dailyRecord.day) {
                dailyRecord.clear()
            }
            dailyRecord.add(description: quest!.name, amount: item.amount[0]-savings)
            bank[0] += savings
            let newRewardPopup2 = UIView(frame: CGRect(x: rewardPopup.frame.minX, y: rewardPopup.frame.minY+(rewardPopup.frame.height)*rewardPopupPos, width: rewardPopup.frame.width, height: rewardPopup.frame.height))
            let newRewardPopupIcon2 = UIImageView(frame: rewardPopupIcon.frame)
            newRewardPopupIcon2.image = UIImage(named: "bankicon")
            let newXLabel2 = UILabel(frame: xLabel.frame)
            newXLabel2.font = xLabel.font
            newXLabel2.text = xLabel.text
            let newRewardPopupAmount2 = UILabel(frame: rewardPopupAmount.frame)
            newRewardPopupAmount2.font = rewardPopupAmount.font
            newRewardPopupAmount2.text = String(savings)
            newRewardPopup2.addSubview(newRewardPopupIcon2)
            newRewardPopup2.addSubview(newRewardPopupAmount2)
            newRewardPopup2.addSubview(newXLabel)
            rewardPopupView.addSubview(newRewardPopup2)
        }
        for i in 0..<userInventory.count {
            
            if item.name == userInventory[i].name {
                found = true
                if quest!.diminish == true {
                    let diffInDays = Calendar.current.dateComponents([.day], from: quest!.dateStarted!, to: quest!.dueDate!).day
                    let diminishFactor = Double(quest!.dayRemaining!)/Double(diffInDays!)
                    if item.amount[1] == 0 {
                        let rewardAmount = Int(Double(item.amount[0])*diminishFactor)
                        if rewardAmount>0 {
                            userInventory[i].amount[0] += rewardAmount
                            newRewardPopupAmount.text = String(rewardAmount)
                            newRewardPopup.addSubview(newRewardPopupIcon)
                            newRewardPopup.addSubview(newRewardPopupAmount)
                            newRewardPopup.addSubview(newXLabel)
                            rewardPopupView.addSubview(newRewardPopup)
                            rewardPopupPos += 1
                            
                        }
                    } else {
                        let amount = Double(item.amount[1] - item.amount[0])*diminishFactor
                        let newAmount = Int(amount) + item.amount[0]
                        userInventory[i].amount[0] += newAmount
                        newRewardPopupAmount.text = String(newAmount)
                        newRewardPopup.addSubview(newRewardPopupIcon)
                        newRewardPopup.addSubview(newRewardPopupAmount)
                        newRewardPopup.addSubview(newXLabel)
                        rewardPopupView.addSubview(newRewardPopup)
                        rewardPopupPos += 1
                        
                    }
                } else {
                if item.amount[1] == 0 {
                    userInventory[i].amount[0] += item.amount[0]
                    newRewardPopupAmount.text = String(item.amount[0])
                    newRewardPopup.addSubview(newRewardPopupIcon)
                    newRewardPopup.addSubview(newRewardPopupAmount)
                    newRewardPopup.addSubview(newXLabel)
                    rewardPopupView.addSubview(newRewardPopup)
                    rewardPopupPos += 1
                    break
                } else if item.amount[1] > 0 {
                    let amount = (item.amount[1] - item.amount[0] + 1).randomNum + item.amount[0]
                    if amount>0 {
                        userInventory[i].amount[0] += amount
                        newRewardPopupAmount.text = String(amount)
                        newRewardPopup.addSubview(newRewardPopupIcon)
                        newRewardPopup.addSubview(newRewardPopupAmount)
                        newRewardPopup.addSubview(newXLabel)
                        rewardPopupView.addSubview(newRewardPopup)
                        rewardPopupPos += 1
                    }
                    break
                } else {
                    if item.amount[0] > 100.randomNum {
                        var newItem = item
                        newItem.amount[0] = 1
                        newItem.amount[1] = 0
                        userInventory[i].amount[0] += 1
                        newRewardPopupAmount.text = String("1")
                        newRewardPopup.addSubview(newRewardPopupIcon)
                        newRewardPopup.addSubview(newRewardPopupAmount)
                        newRewardPopup.addSubview(newXLabel)
                        rewardPopupView.addSubview(newRewardPopup)
                        rewardPopupPos += 1
                    }
                    }
                }
                
            }
        }
        if found == false {
            if quest!.diminish == true {
                let diffInDays = Calendar.current.dateComponents([.day], from: quest!.dateStarted!, to: quest!.dueDate!).day
                let diminishFactor = Double(quest!.dayRemaining!)/Double(diffInDays!)
                if item.amount[1] == 0 {
                    var newItem = item
                    let itemAmount = Int(Double(item.amount[0])*diminishFactor)
                    if itemAmount>0 {
                        newItem.amount[0] = Int(Double(item.amount[0])*diminishFactor)
                        userInventory += [newItem]
                        newRewardPopupAmount.text = String(itemAmount)
                        newRewardPopup.addSubview(newRewardPopupIcon)
                        newRewardPopup.addSubview(newRewardPopupAmount)
                        newRewardPopup.addSubview(newXLabel)
                        rewardPopupView.addSubview(newRewardPopup)
                        rewardPopupPos += 1
                        
                    }
                    
                    
                } else {
                    let amount = Double(item.amount[1] - item.amount[0])*diminishFactor
                    var newItem = item
                    if amount>0 {
                        newItem.amount[0] = Int(Double(newItem.amount[0]) + amount)
                        newItem.amount[1] = 0
                        userInventory += [newItem]
                        newRewardPopupAmount.text = String(amount)
                        newRewardPopup.addSubview(newRewardPopupIcon)
                        newRewardPopup.addSubview(newRewardPopupAmount)
                        newRewardPopup.addSubview(newXLabel)
                        rewardPopupView.addSubview(newRewardPopup)
                        rewardPopupPos += 1
                    }
                }
            } else {
            if item.amount[1] == 0 {
                userInventory += [item]
                newRewardPopupAmount.text = String(item.amount[0])
                newRewardPopup.addSubview(newRewardPopupIcon)
                newRewardPopup.addSubview(newRewardPopupAmount)
                newRewardPopup.addSubview(newXLabel)
                rewardPopupView.addSubview(newRewardPopup)
                rewardPopupPos += 1
            } else if item.amount[1] > 0{
            let amount = (item.amount[1] - item.amount[0] + 1).randomNum + item.amount[0]
                if amount>0 {
                    var newItem = item
                    newItem.amount[0] = amount
                    newItem.amount[1] = 0
                    userInventory += [newItem]
                    newRewardPopupAmount.text = String(amount)
                    newRewardPopup.addSubview(newRewardPopupIcon)
                    newRewardPopup.addSubview(newRewardPopupAmount)
                    newRewardPopup.addSubview(newXLabel)
                    rewardPopupView.addSubview(newRewardPopup)
                    rewardPopupPos += 1
                }
                
            
            } else {
                if item.amount[0] > 100.randomNum {
                    var newItem = item
                    newItem.amount[0] = 1
                    newItem.amount[1] = 0
                    userInventory += [newItem]
                    newRewardPopupAmount.text = String("1")
                    newRewardPopup.addSubview(newRewardPopupIcon)
                    newRewardPopup.addSubview(newRewardPopupAmount)
                    newRewardPopup.addSubview(newXLabel)
                    rewardPopupView.addSubview(newRewardPopup)
                    rewardPopupPos += 1
                }
                }
            }
            
        }
    }
    
    @IBAction func backToWhatever(_ sender: UIButton) {
        
        
        if status == "GMMode" {
            performSegue(withIdentifier: "questToGM", sender: nil)
        } else {
            performSegue(withIdentifier: "questToLanding", sender: nil)
        }
    }
    
    @IBAction func back(_ sender: UIButton) {
        UIView.transition(with: selectQuestView, duration: 0.6, options: [.curveEaseIn], animations: {
            self.selectQuestView.center = CGPoint(x: self.selectQuestView.center.x, y: self.selectQuestView.center.y-600)
        }, completion: {finished in
            self.selectQuestView.isHidden = true
            self.back2u.isHidden = false
            self.questsLabel.isHidden = false
            self.questScrollView.isUserInteractionEnabled = true
            var first = true
            for i in self.rewardScrollView.subviews {
                if first {
                    first = false
                } else {
                    i.removeFromSuperview()
                }
                
            }
        })
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
