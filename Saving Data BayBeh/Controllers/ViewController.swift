//
//  ViewController.swift
//  CoreData
//
//  Created by Kartheek Repakula on 01/03/21

import UIKit
import CoreData

  var mainExpenseArr = ["Housing", "Food", "Transportation", "Savings", "Entertainment"]

class ViewController: UIViewController {
    
    @IBOutlet weak var totalAmountLbl: UILabel!

    
    @IBOutlet weak var tableView: UITableView!
    
    var totoalAmount = 0
    
    var people = [Person]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
          tableView.tableFooterView = UIView()
        
        let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
        
        do {
            let people = try PersistenceServce.context.fetch(fetchRequest)
            self.people = people
            self.tableView.reloadData()
        } catch {}
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
         let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()

              do {
                  let people = try PersistenceServce.context.fetch(fetchRequest)
                  self.people = people
                  self.tableView.reloadData()
                  totoalAmount = 0
                  for item in self.people{
                      totoalAmount =  Int(item.amount) + totoalAmount
                  }
                  self.totalAmountLbl.text = String(totoalAmount)+"/-"
              } catch {}
        
    }
    
    @IBAction func filters() {
        
        if(self.people.count > 0){
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ResultsDisplayVC") as! ResultsDisplayVC
            self.navigationController?.pushViewController(nextViewController, animated: true)
            
        }else{
          
            self.showToast(message: "No Expenses")
        }
    }
    
    @IBAction func onPlusTapped() {

        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "AddOrEditVC") as! AddOrEditVC
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
    }
    
}

extension ViewController: UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainData", for: indexPath) as! ResultsCell
        cell.expenseTypeLbl.text = people[indexPath.row].type
        cell.priceLbl.text = String(people[indexPath.row].amount)+"/-"
        cell.dateLbl.text = people[indexPath.row].date
        return cell
        
    }
    

    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "AddOrEditVC") as! AddOrEditVC
        
        nextViewController.typeTxt = people[indexPath.row].type ?? ""
        nextViewController.amountTxt = String(people[indexPath.row].amount)
        nextViewController.dateTxt = people[indexPath.row].date ?? ""
        nextViewController.remarksTxt = people[indexPath.row].remarks ?? ""
        nextViewController.isEditable = true
        nextViewController.desiredIndex = indexPath.row
        
        
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    
}




