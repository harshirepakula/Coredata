//
//  ResultsCell.swift
//  Saving Data BayBeh
//
//  Created by Kartheek Repakula 01/03/21.


import UIKit

class ResultsCell: UITableViewCell {
    
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var expenseTypeLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var amountLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
