//
//  ViewController.swift
//  Schedule
//
//  Created by Govardhan Goli on 10/29/20.
//

import UIKit
import Kingfisher

class ViewController: UIViewController {
    @IBOutlet weak var detailsTableView: UITableView!
    var decodedResult: Result?
    override func viewDidLoad() {
        super.viewDidLoad()
        detailsTableView.delegate = self
        detailsTableView.dataSource = self
        // Call the API
        self.dataRequest { (result) in
            DispatchQueue.main.async {
                self.decodedResult = result
                self.detailsTableView.reloadData()
            }
        }
        // Do any additional setup after loading the view.
    }
    
    //Call the API to get the Json Data
    func dataRequest(onCompletion: @escaping ((Result) -> ())) {
        let urlToRequest = "http://files.yinzcam.com.s3.amazonaws.com/iOS/interviews/ScheduleExercise/schedule.json"

        let url = URL(string: urlToRequest)!
        let session4 = URLSession.shared
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        let task = session4.dataTask(with: request as URLRequest) { (data, response, error) in
          guard let _: Data = data, let _: URLResponse = response, error == nil else {
            print("*****error")
            return
          }
        if let data = data {
            // Decoding the Json Data
               if let decodedResponse = try? JSONDecoder().decode(Result.self, from: data) {
                print(decodedResponse)
                onCompletion(decodedResponse)
                    return
                }
            }
        }
        task.resume()
      }
    
    //Conversion of date format from one to another
    func convertDateFormat(inputDate: String) -> String {
         let olDateFormatter = DateFormatter()
         olDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:00z"
         let oldDate = olDateFormatter.date(from: inputDate)
         let convertDateFormatter = DateFormatter()
         convertDateFormatter.dateFormat = "E, MMM d"
        return convertDateFormatter.string(from: oldDate!)
    }

}

extension ViewController : UITableViewDelegate, UITableViewDataSource{
    // Number of sections in the schedule
    func numberOfSections(in tableView: UITableView) -> Int {
        return decodedResult?.GameList?.GameSection?.count ?? 0
    }
    
    // Number of rows in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows = decodedResult?.GameList?.GameSection![section].Game?.gameArrayValue
        return rows?.count ?? 1
    }
    
    //Show the deatils of the game
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cardDetailsTableviewCell.identifier, for: indexPath) as! cardDetailsTableviewCell
        cell.selectedTeamNameLbl.text = decodedResult?.GameList?.Team?.Name ?? ""
        cell.selectedTeamLogo.kf.setImage(with: URL(string: "http://yc-app-resources.s3.amazonaws.com/nfl/logos/nfl_phi_light.png"))
        var gameDetails = Game()
        // Get the data object to fill the cell.
        if let rowdata = decodedResult?.GameList?.GameSection![indexPath.section].Game?.gameArrayValue as? [Game]{
            gameDetails = rowdata[indexPath.row]
        }
        if let Object = decodedResult?.GameList?.GameSection![indexPath.section].Game?.gameValue as? Game{
            gameDetails = Object
        }
        
        //Passing data into the cell for display
        let opponentTriCode = gameDetails.Opponent?.TriCode ?? ""
            cell.opponentTeamLogo.kf.setImage(with: URL(string: "http://yc-app-resources.s3.amazonaws.com/nfl/logos/nfl_\(opponentTriCode.lowercased())_light.png"))
        cell.opponentTeamNameLbl.text = gameDetails.Opponent?.Name ?? ""
        cell.weekLbl.text = gameDetails.Week ?? ""
        let type = gameDetails.Types
        // Conditions if the type is F(Final)
        if type == "F"{
            cell.GameTypeLbl.text = "FINAL"
            cell.hideByeLbl()
            cell.selectedTeamScoreLbl.font = UIFont(name: "LeagueGothic-Regular", size: 45)
            cell.opponentTeamScoreLbl.font = UIFont(name: "LeagueGothic-Regular", size: 45)
            cell.selectedTeamScoreLbl.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)
            cell.opponentTeamScoreLbl.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)
            cell.selectedTeamScoreLbl.text = gameDetails.HomeScore ?? ""
            cell.opponentTeamScoreLbl.text = gameDetails.AwayScore ?? ""
        }
        // Conditions if the type is B(bye)
        else if type == "B"{
            cell.showByeLbl()
        }
        // Conditions if the type is S(Schedule)
        else if type == "S"{
            cell.GameTypeLbl.text = gameDetails.Date?.Time ?? ""
            cell.hideByeLbl()
            cell.selectedTeamScoreLbl.font = UIFont(name: "LeagueGothic-Regular", size: 21)
            cell.opponentTeamScoreLbl.font = UIFont(name: "LeagueGothic-Regular", size: 21)
            cell.selectedTeamScoreLbl.textColor = UIColor(red: 153, green: 153, blue: 153, alpha: 1.0)
            cell.opponentTeamScoreLbl.textColor = UIColor(red: 153, green: 153, blue: 153, alpha: 1.0)
            cell.selectedTeamScoreLbl.text = decodedResult?.GameList?.Team?.Record ?? ""
            cell.opponentTeamScoreLbl.text = gameDetails.Opponent?.Record ?? ""
        }
        let timeStamp = gameDetails.Date?.Timestamp ?? ""
        if timeStamp != ""{
            cell.ScheduleDateLbl.text = self.convertDateFormat(inputDate: timeStamp)
        }
        return cell
    }
    
    // Height for the row.
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190
    }
    
    //Height for the header section.
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    
    // Custom view for the header section.
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect(x: 0, y: 0, width: detailsTableView.bounds.size.width, height: 50))
        let lblHeader = UILabel.init(frame: CGRect(x: 15, y: 10.5, width: detailsTableView.bounds.size.width - 10, height: 24))
        let sectionname = decodedResult?.GameList?.GameSection![section].Heading
        lblHeader.text =  "2019 \(sectionname!)"
        lblHeader.font = UIFont (name: "LeagueGothic-Regular", size: 21)
        lblHeader.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        lblHeader.textAlignment = .center
        headerView.addSubview(lblHeader)
        headerView.backgroundColor = UIColor(red: 153, green: 153, blue: 153, alpha: 1.0)
        return headerView
    }
    
    
}

