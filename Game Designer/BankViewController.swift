//
//  BankViewController.swift
//  Game Designer
//
//  Created by jhp on 2018-11-11.
//  Copyright © 2018 Papaya. All rights reserved.
//

import UIKit

class BankViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var fundLabel: UILabel!
    
    
    @IBOutlet weak var bankSlider: UISlider!
    
    @IBOutlet weak var taxView: UIView!
    @IBOutlet weak var bankView: UIView!
   
    @IBOutlet weak var adjustView: UIView!
    
    @IBOutlet weak var GMView: UIView!
    
    @IBOutlet weak var savingRateLabel: UILabel!
    @IBOutlet weak var saveRateField: UITextField!
    @IBOutlet weak var cashLabel: UILabel!
    
    @IBOutlet weak var bufferField: UITextField!
    @IBOutlet weak var costTimeField: UITextField!
    
    @IBOutlet weak var startTimePicker: UIDatePicker!
    
    @IBOutlet weak var amountField: UITextField!
    
    @IBOutlet weak var descriptionField: UITextView!
    
    
    @IBOutlet weak var backButt: UIButton!
    
    @IBOutlet weak var taxTimeField: UITextField!
    @IBOutlet weak var taxTimeLabel: UILabel!
    @IBOutlet weak var taxLabel: UILabel!
    
    var initialBank = bank[0]
    var initialCash = userInventory[0].amount[0]
    var totalAsset = userInventory[0].amount[0] + bank[0]
    var taxableAmount : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        startTimePicker.date = taxableStartTime
        bankSlider.minimumValue = 0
        bankSlider.maximumValue = Float(totalAsset)
        bankSlider.value = Float(bank[0])
        if status == "bank" {
            bankView.isHidden = false
        } else if status == "GMMode" {
            GMView.isHidden = false
        } else if status == "adjust" {
            adjustView.isHidden = false
            backButt.setTitle("Confirm", for: .normal)
        }
        else {
            taxView.isHidden = false
        }
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        
        fundLabel.text = "Bank Fund: \(bank[0])"
        cashLabel.text = "Cash: \(userInventory[0].amount[0])"
        costTimeField.text = "\(tax[1])"
        bufferField.text = "\(Int(tax[2]/tax[1]))"
        
       
        savingRateLabel.text = "Saving Rate: \(bank[1]) %"
        taxTimeLabel.text = "Current Taxable Time: \(tax[0])"
        computeTax()
        taxLabel.text = "Tax Payable: \(taxableAmount)"
    }
    
    @IBAction func bankSliderSlides(_ sender: Any) {
        bank[0] = Int(bankSlider.value)
        userInventory[0].amount[0] = totalAsset - bank[0]
        fundLabel.text = "Bank Fund: \(bank[0])"
        cashLabel.text = "Cash: \(userInventory[0].amount[0])"
        
    }
    
    @IBAction func backButton(_ sender: Any) {
        taxableStartTime = startTimePicker.date
        if status == "adjust" {
            let amount = Int(amountField.text!)
            if amount != nil {
                userInventory[0].amount[0] += amount!
                dailyRecord.add(description: descriptionField.text, amount: amount!)
            }
        }
        if Calendar.current.component(.day, from: Date()) != Calendar.current.component(.day, from: dailyRecord.day) {
            dailyRecord.clear()
        }
            let diffInCash = userInventory[0].amount[0] - initialCash
            if diffInCash > 0 && status == "bank"{
            dailyRecord.add(description: "Bank Withdraw", amount: diffInCash)
            } else if diffInCash < 0 && status == "bank"{
                dailyRecord.add(description: "Bank Deposit", amount: diffInCash)
        }
        saveData()
    }
    
    @objc func editText(_ recognizer : UITapGestureRecognizer) {
        switch recognizer.state {
        case.ended:
            if (recognizer.view as! UITextField).textColor != #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) {
            (recognizer.view as! UITextField).textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                (recognizer.view as! UITextField) .becomeFirstResponder()
            }
            for i in recognizer.view!.gestureRecognizers! {
                recognizer.view?.removeGestureRecognizer(i)
            }
        default: break
        }
    }
    
    func computeTax() {
        taxableAmount = tax[0]*tax[1] - tax[2]
        if taxableAmount<0 {
            taxableAmount = 0
        }
    }
    
    @IBAction func addTaxTime(_ sender: Any) {
        tax[0] += Int(taxTimeField.text!)!
        computeTax()
        taxLabel.text = "Tax Payable: \(taxableAmount)"
        taxTimeLabel.text = "Current Taxable Time: \(tax[0])"
        saveData()
    }
    
    @IBAction func set(_ sender: UIButton) {
        tax[1] = Int(costTimeField.text!)!
        tax[2] = Int(bufferField.text!)!*tax[1]
        saveData()
    }
    
    
    @IBAction func payTax(_ sender: UIButton) {
        userInventory[0].amount[0] -= taxableAmount
        if Calendar.current.component(.day, from: Date()) != Calendar.current.component(.day, from: dailyRecord.day) {
            dailyRecord.clear()
        }
        if taxableAmount > 0 {
        dailyRecord.add(description: "Tax", amount: -taxableAmount)
        } else if taxableAmount < 0 {
            dailyRecord.add(description: "Tax Refund", amount: -taxableAmount)
        }
        tax[0] = 0
        taxableAmount = 0
        taxLabel.text = "Tax Payable: \(taxableAmount)"
        taxTimeLabel.text = "Current Taxable Time: \(tax[0])"
        saveData()
    }
    
    @IBAction func setSaveRate(_ sender: UIButton) {
        bank[1] = Int(saveRateField.text!)!
        savingRateLabel.text = "Saving Rate: \(bank[1]) %"
        saveData()
    }
    

  
    
    
    func updateLabels() {
        fundLabel.text = "Bank Fund: \(bank[0])"
        cashLabel.text = "Cash: \(userInventory[0].amount[0])"
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
        taxTimeField.resignFirstResponder()
        saveRateField.resignFirstResponder()
        descriptionField.resignFirstResponder()
        amountField.resignFirstResponder()
        return true
    }

}
