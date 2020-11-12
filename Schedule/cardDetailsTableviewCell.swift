//
//  cardDetailsTableviewCell.swift
//  Schedule
//
//  Created by Govardhan Goli on 10/29/20.
//

import Foundation
import UIKit

class cardDetailsTableviewCell : UITableViewCell{
    static let identifier = String(describing: cardDetailsTableviewCell.self)
    @IBOutlet weak var selectedTeamNameLbl: UILabel!
    @IBOutlet weak var selectedTeamScoreLbl: UILabel!
    @IBOutlet weak var ScheduleDateLbl: UILabel!
    @IBOutlet weak var atSymbol: UILabel!
    @IBOutlet weak var weekLbl: UILabel!
    @IBOutlet weak var selectedTeamLogo: UIImageView!
    @IBOutlet weak var opponentTeamLogo: UIImageView!
    @IBOutlet weak var opponentTeamNameLbl: UILabel!
    @IBOutlet weak var opponentTeamScoreLbl: UILabel!
    @IBOutlet weak var GameTypeLbl: UILabel!
    @IBOutlet weak var byeLabel: UILabel!
    
    // Hide all Ui components to show the data for the type B
    func hideByeLbl(){
        byeLabel.isHidden = true
        selectedTeamNameLbl.isHidden = false
        selectedTeamScoreLbl.isHidden = false
        ScheduleDateLbl.isHidden = false
        weekLbl.isHidden = false
        selectedTeamLogo.isHidden = false
        opponentTeamLogo.isHidden = false
        opponentTeamNameLbl.isHidden = false
        opponentTeamScoreLbl.isHidden = false
        GameTypeLbl.isHidden = false
        atSymbol.isHidden = false
    }
    
    // Hide all "BYE" label to show the data for the type F and S
    func showByeLbl(){
        byeLabel.isHidden = false
        selectedTeamNameLbl.isHidden = true
        selectedTeamScoreLbl.isHidden = true
        ScheduleDateLbl.isHidden = true
        weekLbl.isHidden = true
        selectedTeamLogo.isHidden = true
        opponentTeamLogo.isHidden = true
        opponentTeamNameLbl.isHidden = true
        opponentTeamScoreLbl.isHidden = true
        GameTypeLbl.isHidden = true
        atSymbol.isHidden = true
        
    }
}
