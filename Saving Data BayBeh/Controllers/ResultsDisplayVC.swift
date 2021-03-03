//
//  ResultsDisplayVC.swift
//  Saving Data BayBeh
//
//  Created by Kartheek Repakula on 01/03/21.


import UIKit
import CoreData

class ResultsDisplayVC: UIViewController , UITableViewDataSource , UITableViewDelegate,UITextFieldDelegate{
    
    @IBOutlet weak var toDateTF: UITextField!
    @IBOutlet weak var fromDateTF: UITextField!
    @IBOutlet weak var resultsDisplayTable: UITableView!
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var totalCostLbl: UILabel!
     @IBOutlet weak var totalCostStLbl: UILabel!
    
    var datePicker : UIDatePicker?
    var dateToolBar : UIToolbar?
    
    //PICKERVIEW PROPERTIES
    var pickerView : UIPickerView?
    var pickerToolBar : UIToolbar?
    
    var filterArr : [Person] = []
    var isFiterEnabled = false
    
    
    var toDateStr = ""
    var fromDateStr = ""
    
    var totoalAmount = 0


    
    var textfieldCheckValue : Int!
    
    
    var people = [Person]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultsDisplayTable.tableFooterView = UIView()
        toDateTF.delegate = self
        fromDateTF.delegate = self
        
        let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
        
        do {
            let people = try PersistenceServce.context.fetch(fetchRequest)
            self.people = people
        } catch {}
        
        for item in self.people{
            totoalAmount =  Int(item.amount) + totoalAmount
        }
        print(totoalAmount)
     
    }
    
    //MARK:SHOW DATE PICKER
    func showDatePicker(_ textField : UITextField){
        datePicker = UIDatePicker()
        
        datePicker?.datePickerMode = .date
        datePicker?.backgroundColor = UIColor.white
        dateToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
        dateToolBar?.barStyle = .blackOpaque
        dateToolBar?.autoresizingMask = .flexibleWidth
        dateToolBar?.barTintColor = #colorLiteral(red: 0.4792685509, green: 0.8342691064, blue: 0.9794327617, alpha: 1)
        dateToolBar?.frame = CGRect(x: 0,y: (datePicker?.frame.origin.y)!-44, width: self.view.frame.size.width,height: 44)
        dateToolBar?.barStyle = UIBarStyle.default
        dateToolBar?.isTranslucent = true
        dateToolBar?.tintColor = .white
        dateToolBar?.backgroundColor = .white
        dateToolBar?.sizeToFit()
        
        let doneButton = UIBarButtonItem(title:"Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(donePickerDate))
        doneButton.tintColor = #colorLiteral(red: 0.9895833333, green: 1, blue: 1, alpha: 1)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title:"Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(canclePickerDate))
        cancelButton.tintColor = #colorLiteral(red: 0.9895833333, green: 1, blue: 1, alpha: 1)
        dateToolBar?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        dateToolBar?.setItems([cancelButton, spaceButton, doneButton], animated: false)
        
        textField.inputAccessoryView = dateToolBar
        textField.inputView = datePicker
        // self.datePicker?.minimumDate =
        let date = Date()
        let calendar = Calendar(identifier: .indian)
        var components = DateComponents()
        components.day = 0
        // let newDate: Date? = calendar.date(byAdding: components, to: date, options: [])
        //let newDate: Date? = calendar.date(byAdding: components, to:date, wrappingComponents:)
        let newDate : Date? = calendar.date(byAdding: components, to: date)
        datePicker?.maximumDate = newDate
        
    }
    
    //MARK:DONE PICKER DATE
    @objc func donePickerDate ()
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        if textfieldCheckValue == 1
        {
            fromDateTF.text! = formatter.string(from: (datePicker?.date)!)
            fromDateStr = formatter.string(from: (datePicker?.date)!)
            self.view.endEditing(true)
            fromDateTF.resignFirstResponder()
        }
        if textfieldCheckValue == 2
        {
            toDateTF.text! = formatter.string(from: (datePicker?.date)!)
             toDateStr = formatter.string(from: (datePicker?.date)!)
            self.view.endEditing(true)
            toDateTF.resignFirstResponder()
        }
        
    }
    
    //MARK:CANCEL PICKER DATE
    @objc func canclePickerDate ()
    {
        if textfieldCheckValue == 1
        {
            self.view.endEditing(true)
            fromDateTF.resignFirstResponder()
            fromDateTF.text = ""
        }
        if textfieldCheckValue == 2
        {
            self.view.endEditing(true)
            toDateTF.resignFirstResponder()
            toDateTF.text = ""
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField == fromDateTF
        {
            textfieldCheckValue = 1
            self.showDatePicker(self.fromDateTF)
        }
        if textField == toDateTF
        {
            textfieldCheckValue = 2
            self.showDatePicker(self.toDateTF)
            
        }
    }
    
    @IBAction func backBtnTap(_ sender: Any)
       {
            self.navigationController?.popViewController(animated: true)
       }
    
    func getDate(strDate  : String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        return dateFormatter.date(from: strDate) // replace Date String
    }
    
    @IBAction func filterAction(_ sender: Any) {
        
        if fromDateStr == "" || toDateStr == ""
        {
            if fromDateStr == ""
            {
                showToast(message: "Please select from date")
            }
            else
            {
                showToast(message: "Please select to date")
            }
        }
        else
        {
            let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
            
            do {
                let people = try PersistenceServce.context.fetch(fetchRequest)
                
                filterArr = [] // clearing array before filter
                
                var mydates : [String] = []
                var dateFrom =  Date() // First date
                var dateTo = Date()   // Last date
                
                // Formatter for printing the date, adjust it according to your needs:
                let fmt = DateFormatter()
                fmt.dateFormat = "dd-MM-yyyy"
                dateFrom = fmt.date(from: fromDateStr)!
                dateTo = fmt.date(from: toDateStr)!
                
                
                while dateFrom <= dateTo {
                    mydates.append(fmt.string(from: dateFrom))
                    dateFrom = Calendar.current.date(byAdding: .day, value: 1, to: dateFrom)!
                    
                }
                
                print(mydates)
                
                
                print(  mydates.contains(people[0].date!))
                
                for myuserDate in people{
                    let isValidData = mydates.contains(myuserDate.date!)
                    isValidData ? filterArr.append(myuserDate) : print("not matched")
                }
                resultsDisplayTable.reloadData()
                print(filterArr)
                totoalAmount = 0
                for item in filterArr{
                    totoalAmount =  Int(item.amount) + totoalAmount
                }
                totalCostStLbl.text = "Total Expenses  :"
                totalCostLbl.text = String(totoalAmount)+"/-"
                print(totoalAmount)
                
                // print(filterArr)
                
            } catch {
                print(error.localizedDescription)
            }
        }
        
    }
    
    
    
    func getDate(mydate : String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yy"
  
        return dateFormatter.date(from: mydate) // replace Date String
    }
    
    static func dates(from fromDate: Date, to toDate: Date) -> [Date] {
            var dates: [Date] = []
            var date = fromDate
            
            while date <= toDate {
                dates.append(date)
                guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
                date = newDate
            }
            return dates
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return self.filterArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultsCell", for: indexPath) as! ResultsCell
      
            cell.titleLbl.text = self.filterArr[indexPath.row].type
            cell.amountLbl.text = String(self.filterArr[indexPath.row].amount)+"/-"
        
        return cell
        
    }
    
   func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
               return UITableViewAutomaticDimension
           }
    
    
}


class Dates {
    static func printDatesBetweenInterval(_ startDate: Date, _ endDate: Date) {
        var startDate = startDate
        let calendar = Calendar.current

        let fmt = DateFormatter()
        fmt.dateFormat = "dd-MM-yyyy"

        while startDate <= endDate {
            print(fmt.string(from: startDate))
            startDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
        }
    }

    static func dateFromString(_ dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"

        return dateFormatter.date(from: dateString)!
    }
}
