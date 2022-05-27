//
//  RecordViewController.swift
//  Game Designer
//
//  Created by jhp on 2019-01-21.
//  Copyright © 2019 Papaya. All rights reserved.
//

import UIKit

class RecordViewController: UIViewController {
    
    @IBOutlet weak var dateLabel: UILabel!

    @IBOutlet weak var recordScrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if Calendar.current.component(.day, from: Date()) != Calendar.current.component(.day, from: dailyRecord.day) {
            for i in 0..<weeklyRecord.count-1 {
                weeklyRecord[6-i].description = dailyRecord.description
                weeklyRecord[6-i].amount = dailyRecord.amount
                weeklyRecord[6-i].day = dailyRecord.day
            }
            dailyRecord.clear()
        }
        weeklyRecord[0] = dailyRecord
        drawRecord(pos: 0)
        
        // Do any additional setup after loading the view.
    }
    func drawRecord (pos : Int) {
        for i in recordScrollView.subviews {
            i.removeFromSuperview()
        }
        var recordPos : CGFloat = 0
        let weekday = Calendar.current.component(.weekday, from: Date())-1
        dateLabel.text = "\(getMonthName(monthNum: Calendar.current.component(.month, from: weeklyRecord[pos].day)))  \(Calendar.current.component(.day, from: weeklyRecord[pos].day))"
        for i in 0..<weeklyRecord[pos].description.count {
            let descriptionLabel = UILabel.init(frame: CGRect(x: 0, y: recordPos, width: recordScrollView.frame.width, height: 20))
            descriptionLabel.text = weeklyRecord[pos].description[i]
            let amountLabel = UILabel.init(frame: CGRect(x: recordScrollView.frame.maxX-102, y: recordPos, width: 102, height: 20))
            amountLabel.text = "\(weeklyRecord[pos].amount[i])"
            if weeklyRecord[pos].amount[i]<0 {
                amountLabel.textColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            }
            recordScrollView.addSubview(descriptionLabel)
            recordScrollView.addSubview(amountLabel)
            recordPos += 30
            
        }
        let lineLabel = UILabel.init(frame: CGRect(x: 0, y: recordPos, width: recordScrollView.frame.width, height: 20))
        lineLabel.text = "---------------------------"
        recordPos += 30
        lineLabel.textAlignment = .center
        let netLabel = UILabel.init(frame: CGRect(x: 0, y: recordPos, width: recordScrollView.frame.width, height: 20))
        netLabel.text = "Net Income:  \(weeklyRecord[pos].weekRecord[weekday][0])"
        netLabel.textAlignment = .center
        if weeklyRecord[pos].weekRecord[weekday][0]<0 {
            netLabel.textColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        }
        
        recordScrollView.addSubview(lineLabel)
        recordScrollView.addSubview(netLabel)
        recordScrollView.contentSize = CGSize.init(width: recordScrollView.frame.width, height: recordPos)
        
    }
    
    func getMonthName (monthNum : Int) -> String {
        if monthNum == 1 {
            return "Jan"
        } else if monthNum == 2{
            return "Feb"
        } else if monthNum == 3{
            return "Mar"
        } else if monthNum == 4{
            return "Apr"
        } else if monthNum == 5{
            return "May"
        } else if monthNum == 6{
            return "Jun"
        } else if monthNum == 7{
            return "Jul"
        } else if monthNum == 8{
            return "Aug"
        } else if monthNum == 9{
            return "Sep"
        } else if monthNum == 10{
            return "Oct"
        } else if monthNum == 11{
            return "Nov"
        } else if monthNum == 12{
            return "Dec"
        } else {
            return ""
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
