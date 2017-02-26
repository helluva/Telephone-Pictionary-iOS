//
//  JoinGameViewController.swift
//  Telephone Pictionary
//
//  Created by Cal Stephens on 2/25/17.
//  Copyright © 2017 Cal Stephens. All rights reserved.
//

import UIKit

class JoinGameViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    //MARK: - View Setup
    
    override func viewDidAppear(_ animated: Bool) {
        self.loadGames()
    }
    
    @IBAction func loadGames() {
        ApplicationState.state.sendMessage("requestListOfGames") { response in
            
            self.games = response.components(separatedBy: ";").map { gameInfo in
                let components = gameInfo.components(separatedBy: ",")
                return (gameName: components[1], gameId: components[0])
            }
            
            self.tableView.reloadData()
        }
    }
    
    
    //MARK: - UITableViewDelegate
    
    var games = [(gameName: String, gameId: String)]()
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "game", for: indexPath)
        cell.textLabel?.text = games[indexPath.item].gameName
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55.0
    }
    
    
}
