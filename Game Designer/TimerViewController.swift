//
//  TimerViewController.swift
//  Game Designer
//
//  Created by jhp on 2018-12-20.
//  Copyright © 2018 Papaya. All rights reserved.
//

import UIKit
import UserNotifications


class TimerViewController: UIViewController, UITextFieldDelegate, UIApplicationDelegate {
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var popupView: UIView!
    
    @IBOutlet weak var popupLabel: UILabel!
    
    @IBOutlet weak var completeButton: UIButton!
    
    @IBOutlet weak var titleField: UITextField!
    
    @IBOutlet weak var minutesField: UITextField!
    
    @IBOutlet weak var titleDisplayLabel: UILabel!
    
    @IBOutlet weak var setUpView: UIView!
    
    @IBOutlet weak var timerSlider: UISlider!
    
    @IBOutlet weak var goButton: UIButton!
    
    @IBOutlet var timerTypeButtons: [UIButton]!
    
    @IBOutlet weak var xbutton: UIButton!
    
    @IBOutlet weak var confirmCompleteButton: UIButton!
    
    @IBOutlet weak var weeklyHistoryView: UIView!
    
    @IBOutlet weak var weeklyHistButtView: UIView!
    
    @IBOutlet weak var timelineView: UIView!
    
    @IBOutlet weak var histScrollView: UIScrollView!
    
    @IBOutlet var histWeekdayButton: [UIButton]!
    
    
    
    
    let weekday = Calendar.current.component(.weekday, from: Date())
    var historyMode = false
    var countDown = true
    var secondString = "00"
    var minuteString = "00"
    var currentWeekDay = Calendar.current.component(.weekday, from: Date())-1
    var newWeekdayTimers : [TimerData] = []
    var taxtime = 0
    
    var timer : Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadTimers()
        var count = weekday
        for i in (0..<7).reversed() {
            if count >= 7 {
                count = 0
            }
            
            histWeekdayButton[count].titleLabel!.numberOfLines = 0
            histWeekdayButton[count].titleLabel?.textAlignment = .center
            histWeekdayButton[count].setTitle("\(histWeekdayButton[count].currentTitle!)\n\(Calendar.current.dateComponents([.day], from: Date().add(days:-i)!).day!)", for: .normal)
            count += 1
        }
        for i in 0..<7 {
        if !weekdayTimers[i].isEmpty {
            let diffInDays = Calendar.current.dateComponents([.day], from: Date(), to: weekdayTimers[i][0].startTime.add(days: -1)!).day!
            if diffInDays <= -7 {
                weekdayTimers[i].removeAll()
            }
            }
        }
       
        weeklyHistoryView.translatesAutoresizingMaskIntoConstraints = true
        histWeekdayButton[weekday-1].setTitleColor(#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1), for: .normal)
        histWeekdayButton[weekday-1].titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        histWeekdayButton[weekday-1].transform = CGAffineTransform.identity.scaledBy(x: 1.2, y: 1.2)
       showHistory(weekDayTimers: weekdayTimers[weekday-1])
        weeklyHistButtView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector (bringUpHistory(_:))))
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        titleField.delegate = self
        minutesField.delegate = self
        titleField.clearsOnBeginEditing = true
        if timerStarted == 1 {
            minutes = Int(-timerData[0].timeIntervalSinceNow/60)
            seconds = Int(-timerData[0].timeIntervalSinceNow-Double(minutes*60))
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireUpTimer), userInfo: nil, repeats: true)
            fireUpTimer(timer: timer!)
            setUpView.center = CGPoint(x: setUpView.center.x, y: setUpView.center.y-200)
            completeButton.isHidden = false
            xbutton.isHidden = false
            titleDisplayLabel.text = timerTitle
            titleDisplayLabel.isHidden = false
            setUpView.isHidden = true
        } else if timerStarted == 2 {
            if timerData[1].timeIntervalSinceNow < 0 {
                let weekday = Calendar.current.component(.weekday, from: timerData[0])
                let data = TimerData.init(startTime: timerData[0], endTime: timerData[1], type: timerType, title: timerTitle)
                weekdayTimers[weekday-1].append(data)
                popupView.isHidden = true
                titleDisplayLabel.isHidden = true
                completeButton.isHidden = true
                setUpView.isHidden = false
                timer?.invalidate()
                timeLabel.text = "00:00"
                seconds = 0
                
                timerStarted = 0
                saveTimerData()
            } else {
            minutes = Int(timerData[1].timeIntervalSinceNow/60)
            seconds = Int(timerData[1].timeIntervalSinceNow-Double(minutes*60))
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireDownTimer), userInfo: nil, repeats: true)
            fireDownTimer(timer: timer!)
            setUpView.center = CGPoint(x: setUpView.center.x, y: setUpView.center.y-200)
            completeButton.isHidden = false
                titleDisplayLabel.text = timerTitle
                titleDisplayLabel.isHidden = false
                xbutton.isHidden = false
            setUpView.isHidden = true
        }
        } else {
            timerType = 2
        }
        // Do any additional setup after loading the view.
    }
    
    
    
    func showHistory(weekDayTimers: [TimerData]) {
        var first = true
        for i in histScrollView.subviews {
            if !first {
            i.removeFromSuperview()
            } else {
                first = false
            }
        }
        var histPos : CGFloat = 0
        for i in weekDayTimers {
            let histView = UIView.init(frame: CGRect.init(x: 0, y: histPos, width: timelineView.frame.width, height: timelineView.frame.height))
            let histBackground = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: histView.frame.width, height: histView.frame.height))
            let histType = UILabel.init(frame: timelineView.subviews[3].frame)
            if i.type == 0 {
                histBackground.image = UIImage.init(named: "timelinebackground")
                histType.text = "Work"
            } else if i.type == 1 {
                histBackground.image = UIImage.init(named: "timelinebackgroundblue")
                histType.text = "Leisure"
            } else if i.type == 2 {
                histBackground.image = UIImage.init(named: "timelinebackgroundred")
                histType.text = "Other"
            } else {
                histBackground.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            }
            let histTitleLabel = UILabel.init(frame: timelineView.subviews[0].frame)
            histTitleLabel.text = i.title
            let histDurationLabel = UILabel.init(frame: timelineView.subviews[1].frame)
            histDurationLabel.text = i.duration
            let startTime = timeToString(hour: Calendar.current.dateComponents([.hour], from: i.startTime).hour!, minute: Calendar.current.dateComponents([.minute], from: i.startTime).minute!)
            let endTime = timeToString(hour: Calendar.current.dateComponents([.hour], from: i.endTime).hour!, minute: Calendar.current.dateComponents([.minute], from: i.endTime).minute!)
            let histTimeLabel = UILabel.init(frame:timelineView.subviews[2].frame)
            histTimeLabel.text = "\(startTime) ~ \(endTime)"
            histView.addSubview(histBackground)
            histView.addSubview(histTitleLabel)
            histView.addSubview(histDurationLabel)
            histView.addSubview(histTimeLabel)
            histView.addSubview(histType)
            histScrollView.addSubview(histView)
           histPos += histView.frame.height
            
        }
        histScrollView.contentSize = CGSize(width: histScrollView.frame.width, height: histPos)
    }
    @IBAction func showBlankTime(_ sender: UIButton) {
        
        findTaxBlock(weekDay: currentWeekDay)
        
        
    }
    
    @IBAction func taxBlankTime(_ sender: UIButton) {
        taxtime = 0
        for i in newWeekdayTimers {
            if i.type == 4 {
                taxtime += i.minutes
            }
        }
        popupLabel.text = "Add \(taxtime) tax?"
        confirmCompleteButton.setTitle("Confirm", for: .normal)
        popupView.isHidden = false
    }
    func ignoreDay (_ time: Date) -> Date {
        let date = Calendar.current.date(bySettingHour: Calendar.current.component(.hour, from: time), minute: Calendar.current.component(.minute, from: time), second: Calendar.current.component(.second, from: time), of: Date())!
        return date
    }
    
    func findTaxBlock (weekDay: Int) {
        newWeekdayTimers = []
        for i in 0..<weekdayTimers[weekDay].count {
            if i == 0 {
                let theTimer = TimerData.init(startTime: ignoreDay(taxableStartTime), endTime: ignoreDay(weekdayTimers[weekDay][i].startTime), type: 4, title: "Blank")
                if theTimer.minutes >= 5 {
                    newWeekdayTimers += [theTimer]
                }
                    
                    newWeekdayTimers += [weekdayTimers[weekDay][i]]
            }  else {
               
                let theTimer = TimerData.init(startTime: weekdayTimers[weekDay][i-1].endTime, endTime: weekdayTimers[weekDay][i].startTime, type: 4, title: "Blank")
                print ("\(theTimer.minutes)")
                if theTimer.minutes >= 5 {
                    newWeekdayTimers += [theTimer]
                }
                newWeekdayTimers += [weekdayTimers[weekDay][i]]
                
            }
            
            
        }
        if weekdayTimers[weekDay].count == 0 {
            let theTimer = TimerData.init(startTime: taxableStartTime, endTime: Date(), type: 4, title: "Blank")
            if theTimer.minutes >= 5 {
                newWeekdayTimers += [theTimer]
            }
            
        } else {
        let theTimer = TimerData.init(startTime: weekdayTimers[weekDay].last!.endTime, endTime: Date(), type: 4, title: "Blank")
        if theTimer.minutes >= 5 {
            newWeekdayTimers += [theTimer]
        }
        }
        showHistory(weekDayTimers: newWeekdayTimers)
    }
    
    @IBAction func histWeekdaySelector(_ sender: Any) {
        for i in histWeekdayButton {
            i.transform = CGAffineTransform.identity.scaledBy(x: 1, y: 1)
            
            i.titleLabel?.font = UIFont.systemFont(ofSize: 18)
            
        }
        currentWeekDay = histWeekdayButton.index(of: sender as! UIButton)!
        (sender as! UIButton).transform = CGAffineTransform.identity.scaledBy(x: 1.2, y: 1.2)
        (sender as! UIButton).titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        showHistory(weekDayTimers: weekdayTimers[currentWeekDay])
    }
    
    
    func timeToString(hour:Int, minute:Int) -> String{
        var hourStr = ""
        var minStr = ""
        if hour <= 9 {
            hourStr = "0\(hour)"
        } else {
            hourStr = "\(hour)"
        }
        if minute <= 9 {
            minStr = "0\(minute)"
        } else {
            minStr = "\(minute)"
        }
        return "\(hourStr):\(minStr)"
    }
    
    
    @IBAction func cancelTimer(_ sender: UIButton) {
        popupLabel.text = "Are you sure you want to abandon this timer?"
        confirmCompleteButton.setTitle("Abandon", for: .normal)
        popupView.isHidden = false
    }
    
    @objc func bringUpHistory(_ recognizer: UITapGestureRecognizer){
        switch recognizer.state {
        case.ended:
            if historyMode {
                UIView.transition(with: view, duration: 0.6, options: [.curveEaseIn], animations: {
                    self.weeklyHistoryView.frame = CGRect(x: self.weeklyHistoryView.frame.minX, y: self.weeklyHistoryView.frame.minY+708, width: self.weeklyHistoryView.frame.width, height: self.weeklyHistoryView.frame.height)
                })
                historyMode = false
            } else {
                histWeekdaySelector(histWeekdayButton[weekday-1])
            UIView.transition(with: view, duration: 0.6, options: [.curveEaseIn], animations: {
                self.weeklyHistoryView.frame = CGRect(x: self.weeklyHistoryView.frame.minX, y: self.weeklyHistoryView.frame.minY-708, width: self.weeklyHistoryView.frame.width, height: self.weeklyHistoryView.frame.height)
            })
                
            historyMode = true
            }
        default: break
        }
        
    }
    
    @objc func appMovedToForeground() {
        if timerStarted == 1 {
            minutes = Int(-timerData[0].timeIntervalSinceNow/60)
            seconds = Int(-timerData[0].timeIntervalSinceNow-Double(minutes*60))
            completeButton.isHidden = false
            xbutton.isHidden = false
            titleDisplayLabel.text = timerTitle
            titleDisplayLabel.isHidden = false
            setUpView.isHidden = true
        } else if timerStarted == 2 {
            if timerData[1].timeIntervalSinceNow < 0 {
                let weekday = Calendar.current.component(.weekday, from: timerData[0])
                let data = TimerData.init(startTime: timerData[0], endTime: timerData[1], type: timerType, title: timerTitle)
                weekdayTimers[weekday-1].append(data)
                popupView.isHidden = true
                titleDisplayLabel.isHidden = true
                completeButton.isHidden = true
                xbutton.isHidden = true
                setUpView.isHidden = false
                timer?.invalidate()
                timeLabel.text = "00:00"
                UIView.transition(with: setUpView, duration: 0.3, options: [.curveEaseIn], animations: {self.setUpView.center = CGPoint(x: self.setUpView.center.x, y: self.setUpView.center.y+200)})
                seconds = 0
                
                timerStarted = 0
                saveTimerData()
            } else {
                minutes = Int(timerData[1].timeIntervalSinceNow/60)
                seconds = Int(timerData[1].timeIntervalSinceNow-Double(minutes*60))
                completeButton.isHidden = false
                xbutton.isHidden = false
                titleDisplayLabel.text = timerTitle
                titleDisplayLabel.isHidden = false
                setUpView.isHidden = true
            }
        }
    }
    
    @objc func fireUpTimer(timer: Timer) {
        updateUpTimer()
    }
    @objc func fireDownTimer(timer: Timer) {
        updateDownTimer()
    }
    
    
    
    @IBAction func go(_ sender: UIButton) {
        minutesField.endEditing(true)
        if Int(minutesField.text!) != nil {
            minutes = Int(minutesField.text!)!
            timeLabel.text = "\(minutes):00"
        }
        if countDown == false {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireUpTimer), userInfo: nil, repeats: true)
            minutes = 0
            fireUpTimer(timer: timer!)
            xbutton.isHidden = false
            completeButton.isHidden = false
            timerStarted = 1
        } else {
            let content = UNMutableNotificationContent()
            content.title = "Time up!"
            content.body = "\(minutes) minutes is up!"
            content.badge = 1
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(minutes*60), repeats: false)
            let request = UNNotificationRequest(identifier: "timerDone", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            completeButton.isHidden = false
            xbutton.isHidden = false
            timerData[1] = Date().addingTimeInterval(Double(minutes*60))
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireDownTimer), userInfo: nil, repeats: true)
            fireDownTimer(timer: timer!)
            timerStarted = 2
            
                
            
        }
        timerTitle = titleField.text!
        timerData[0] = Date()
        if titleField.text != "Enter title here" {
            timerTitle = titleField.text!
        } else {
            timerTitle = "Timer"
        }
        titleDisplayLabel.text = timerTitle
        titleDisplayLabel.isHidden = false
        UIView.transition(with: setUpView, duration: 0.3, options: [.curveEaseIn], animations: {self.setUpView.center = CGPoint(x: self.setUpView.center.x, y: self.setUpView.center.y-200)}, completion: {finished in self.setUpView.isHidden = true})
        saveTimerData()
    }
    
    
    @IBAction func complete(_ sender: UIButton) {
        popupLabel.text = "Are you sure you want to complete?"
        confirmCompleteButton.setTitle("Complete", for: .normal)
        popupView.isHidden = false
        
        
    }
    
    @IBAction func cancelPopup(_ sender: UIButton) {
        popupView.isHidden = true
    }
    
    
    @IBAction func confirmComplete(_ sender: UIButton) {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        if sender.currentTitle == "Complete" {
        timerData[1] = Date()
            let weekday = Calendar.current.component(.weekday, from: timerData[0])
            let data = TimerData.init(startTime: timerData[0], endTime: timerData[1], type: timerType, title: timerTitle)
            weekdayTimers[weekday-1].append(data)
        popupView.isHidden = true
        completeButton.isHidden = true
        xbutton.isHidden = true
            titleDisplayLabel.isHidden = true
        setUpView.isHidden = false
        timer?.invalidate()
        timeLabel.text = "00:00"
        seconds = 0
        UIView.transition(with: setUpView, duration: 0.3, options: [.curveEaseIn], animations: {self.setUpView.center = CGPoint(x: self.setUpView.center.x, y: self.setUpView.center.y+200)})
        
        timerStarted = 0
            saveTimerData()
        } else if sender.currentTitle == "Abandon" {
            popupView.isHidden = true
            completeButton.isHidden = true
            setUpView.isHidden = false
            xbutton.isHidden = true
            titleDisplayLabel.isHidden = true
            timer?.invalidate()
            timeLabel.text = "00:00"
            seconds = 0
            UIView.transition(with: setUpView, duration: 0.3, options: [.curveEaseIn], animations: {self.setUpView.center = CGPoint(x: self.setUpView.center.x, y: self.setUpView.center.y+200)})
            timerStarted = 0
            saveTimerData()
        } else if sender.currentTitle == "Confirm" {
            popupView.isHidden = true
            tax[0] += taxtime
            saveData()
        }
    }
    
    @IBAction func timerTypeButton(_ sender: UIButton) {
        timerType = timerTypeButtons.index(of: sender)!
        for i in timerTypeButtons {
            i.transform = CGAffineTransform.identity.scaledBy(x:1,y:1)
        }
        timerTypeButtons[timerType].transform = CGAffineTransform.identity.scaledBy(x:1.2,y:1.2)
    }
    
    
    
    func updateUpTimer() {
        seconds += 1
        if seconds >= 60 {
            minutes += 1
            seconds = 0
        }
        if seconds > 9 {
            secondString = "\(seconds)"
        } else {
            secondString = "0\(seconds)"
        }
        if minutes > 9 {
            minuteString = "\(minutes)"
        } else {
            minuteString = "0\(minutes)"
        }
        timeLabel.text = "\(minuteString):\(secondString)"
    }
    
    func updateDownTimer() {
        seconds -= 1
        if seconds < 0  {
            minutes -= 1
            seconds = 59
        }
        if seconds > 9 {
            secondString = "\(seconds)"
        } else {
            secondString = "0\(seconds)"
        }
        if minutes > 9 {
            minuteString = "\(minutes)"
        } else {
            minuteString = "0\(minutes)"
        }
        if minutes < 0 {
            let weekday = Calendar.current.component(.weekday, from: timerData[0])
            let data = TimerData.init(startTime: timerData[0], endTime: timerData[1], type: timerType, title: timerTitle)
            weekdayTimers[weekday-1].append(data)
            popupView.isHidden = true
            completeButton.isHidden = true
            xbutton.isHidden = true
            titleDisplayLabel.isHidden = true
            setUpView.isHidden = false
            timer?.invalidate()
            timeLabel.text = "00:00"
            seconds = 0
            UIView.transition(with: setUpView, duration: 0.3, options: [.curveEaseIn], animations: {self.setUpView.center = CGPoint(x: self.setUpView.center.x, y: self.setUpView.center.y+200)})
            timerStarted = 0
            saveTimerData()
        } else {
        timeLabel.text = "\(minuteString):\(secondString)"
        }
    }
    
    @IBAction func setTimer(_ sender: UISlider) {
            minutesField.text = "\(Int(sender.value))"
        minutes = Int(minutesField.text!)!
        timeLabel.text = "\(minutes):00"
    }
    
    
    @IBAction func setTimerCustom(_ sender: UITextField) {
        if Int(minutesField.text!) != nil {
            minutes = Int(minutesField.text!)!
            timeLabel.text = "\(minutes):00"
        }
    }
    

    
    @IBAction func upDownControl(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            UIView.transition(with: view, duration: 0.3, options: [.curveEaseIn], animations: {
                self.minutesField.alpha = 1
                self.timerSlider.alpha = 1
            })
            minutesField.isUserInteractionEnabled = true
            timerSlider.isUserInteractionEnabled = true
            countDown = true
            
        } else {
            timeLabel.text = "00:00"
            minutesField.isUserInteractionEnabled = false
            timerSlider.isUserInteractionEnabled = false
            UIView.transition(with: view, duration: 0.3, options: [.curveEaseIn], animations: {
                self.minutesField.alpha = 0
                self.timerSlider.alpha = 0
            })
            countDown = false
        }
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        minutesField.resignFirstResponder()
        titleField.resignFirstResponder()
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            timer?.invalidate()
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
