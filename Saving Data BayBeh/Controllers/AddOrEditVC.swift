//
//  AddOrEditVC.swift
//  Saving Data BayBeh
//
//  Created by Kartheek Repakula on 01/03/21.

import UIKit
import CoreData


class AddOrEditVC: UIViewController,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var autoCompleteHt: NSLayoutConstraint!
    @IBOutlet weak var typeTxtField: UITextField!
    @IBOutlet weak var amountTxtField: UITextField!
    @IBOutlet weak var dateTxtField: UITextField!
    @IBOutlet weak var remoteTxtField: UITextField!
    @IBOutlet weak var saveOutlet: UIButton!
    @IBOutlet weak var autocompleteTableView: UITableView!
   
    var typeTxt = ""
    var amountTxt = ""
    var dateTxt = ""
    var remarksTxt = ""
    var isEditable = false
    var desiredIndex : Int?
    
    var people = [Person]()
    
    var datePicker : UIDatePicker?
    var dateToolBar : UIToolbar?
    
    //PICKERVIEW PROPERTIES
    var pickerView : UIPickerView?
    var pickerToolBar : UIToolbar?
   
   var autocompleteUrls = [String]()
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showDatePicker()
        self.typeTxtField.text = typeTxt
        self.amountTxtField.text = amountTxt
        self.dateTxtField.text = dateTxt
        self.remoteTxtField.text = remarksTxt
        
        isEditable ? self.saveOutlet.setTitle("Edit", for: .normal) : self.saveOutlet.setTitle("Save", for: .normal)
        
        self.title =  isEditable ? "Edit Expenses" : "Add Expenses"
        
        
        
        typeTxtField.delegate = self
        autocompleteTableView.delegate = self
        autocompleteTableView.dataSource = self
        autocompleteTableView.isScrollEnabled = true
        autocompleteTableView.isHidden = true
        
        autocompleteTableView.tableFooterView = UIView()
        //autocompleteTableView.backgroundColor = .clear
        autocompleteTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(autocompleteTableView)
        // Do any additional setup after loading the view.
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        autocompleteTableView.isHidden = false
        let substring = (self.typeTxtField.text! as NSString).replacingCharacters(in: range, with: string)

        searchAutocompleteEntriesWithSubstring(substring: substring)
        return true      // not sure about this - could be false
        
       
    }
    
    func searchAutocompleteEntriesWithSubstring(substring: String)
    {
        autocompleteUrls.removeAll(keepingCapacity: false)

        for curString in mainExpenseArr
        {
            var myString:NSString! = curString as NSString

            var substringRange :NSRange! = myString.range(of: substring)

            if (substringRange.location  == 0)
            {
                autocompleteUrls.append(curString)
            }
        }

        autocompleteTableView.reloadData()
        
        self.autocompleteTableView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        self.view.layoutIfNeeded()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
            
            
            autocompleteTableView.layer.removeAllAnimations()
            autoCompleteHt.constant = autocompleteTableView.contentSize.height
            
            UIView.animate(withDuration: 0.0) {
                self.updateViewConstraints()
                self.view.layoutIfNeeded()
            }
        }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return autocompleteUrls.count
    }

   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        
        let autoCompleteRowIdentifier = "AutoCompleteRowIdentifier"
        var cell = tableView.dequeueReusableCell(withIdentifier: autoCompleteRowIdentifier) as UITableViewCell!
        cell?.contentView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        if let tempo1 = cell {
            let index = indexPath.row as Int
            cell!.textLabel!.text = autocompleteUrls[index]
        }

        else {
            cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: autoCompleteRowIdentifier)
        }

        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell : UITableViewCell = tableView.cellForRow(at: indexPath as IndexPath)!
        typeTxtField.text = self.autocompleteUrls[indexPath.row]
        
        self.autocompleteTableView.isHidden = true
    }



    
    //MARK:SHOW DATE PICKER
    func showDatePicker(){
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
        self.dateTxtField.inputView = datePicker
        self.dateTxtField.inputAccessoryView = dateToolBar
       
        let date = Date()
        let calendar = Calendar(identifier: .indian)
        var components = DateComponents()
        components.day = 0
       
        let newDate : Date? = calendar.date(byAdding: components, to: date)
        datePicker?.maximumDate = newDate
        
    }
    
    //MARK:DONE PICKER DATE
    @objc func donePickerDate ()
    {
       
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
      
        dateTxtField.text! = formatter.string(from: (datePicker?.date)!)
        self.view.endEditing(true)
        dateTxtField.resignFirstResponder()
    }
    
    //MARK:CANCEL PICKER DATE
    @objc func canclePickerDate ()
    {
        self.view.endEditing(true)
        dateTxtField.resignFirstResponder()
    }
    
    @IBAction func saveAction(_ sender: Any) {
        
        if self.typeTxtField.text == "" || self.amountTxtField.text == "" ||
            self.dateTxtField.text == "" || self.remoteTxtField.text == ""
        {
            self.showToast(message: "Please enter all details")
        }
        else
        {
            isEditable ? editData(myindex: desiredIndex ?? 0) : saveData()
        }
        
    }
    
    @IBAction func backBtnTap(_ sender: Any)
    {
         self.navigationController?.popViewController(animated: true)
    }
    
    
    func editData(myindex : Int){
        
        let typeofData = self.typeTxtField.text ?? ""
        let amount = self.amountTxtField.text ?? ""
        let mydate = self.dateTxtField.text ?? ""
        let remarks = self.remoteTxtField.text ?? ""
        
        let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
        
        do {
            let people = try PersistenceServce.context.fetch(fetchRequest)
            self.people = people
            self.people[desiredIndex ?? 0].type = typeofData
            self.people[desiredIndex ?? 0].amount = Int32(amount)!
            self.people[desiredIndex ?? 0].date = mydate
            self.people[desiredIndex ?? 0].remarks =  remarks
            PersistenceServce.saveContext()
            
            var peopleType = [String]()
            
            for i in 0..<people.count
            {
                peopleType.append(people[i].type ?? "")
            }
            
            var newExpense =  mainExpenseArr.difference(from: peopleType)
            
            for i in 0..<newExpense.count
            {
                mainExpenseArr.append(newExpense[i])
            }
            
            
        } catch {}
        
        
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    func saveData(){
        
        let typeofData = self.typeTxtField.text ?? ""
        let amount = self.amountTxtField.text ?? ""
        let mydate = self.dateTxtField.text ?? ""
        let remarks = self.remoteTxtField.text ?? ""
        
        let person = Person(context: PersistenceServce.context)
        person.type =  typeofData
        person.amount = Int32(amount)!
        person.date = mydate
        person.remarks =  remarks
        PersistenceServce.saveContext()
        self.people.append(person)
        
        var peopleType = [String]()
        
        for i in 0..<people.count
        {
            peopleType.append(people[i].type ?? "")
        }
        
        var newExpense =  mainExpenseArr.difference(from: peopleType)
        
        for i in 0..<newExpense.count
        {
            mainExpenseArr.append(newExpense[i])
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
}

extension Array where Element: Hashable {
func difference(from other: [Element]) -> [Element] {
    let thisSet = Set(self)
    let otherSet = Set(other)
    return Array(thisSet.symmetricDifference(otherSet))
 }
}
