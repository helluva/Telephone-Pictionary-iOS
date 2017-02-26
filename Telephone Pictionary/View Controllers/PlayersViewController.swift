//
//  PlayersViewController.swift
//  Telephone Pictionary
//
//  Created by Cal Stephens on 2/25/17.
//  Copyright © 2017 Cal Stephens. All rights reserved.
//

import UIKit

class PlayersViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    //MARK: - Transition
    
    static func present(in navigationController: UINavigationController, playerIsHost: Bool = false) {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "players") as! PlayersViewController
        controller.playerIsHost = playerIsHost
        
        navigationController.pushViewController(controller, animated: true)
        
        ApplicationState.state.registerListener(forNodeMethod: "playersInLobby", named: "playerlist", callback: controller.loadedListOfPlayers)
    }
    
    
    //MARK: - View Setup
    
    var playerIsHost: Bool = false
    @IBOutlet weak var waitingForHost: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        ApplicationState.state.sendMessage("requestRebroadcast:playersInLobby")
        
        if playerIsHost {
            waitingForHost.isHidden = true
        }
    }
    
    func loadedListOfPlayers(response: String) {
        self.players = response.components(separatedBy: ",")
        self.tableView.reloadData()
    }
    
    
    //MARK: - UITableViewDelegate
    
    var players = [String]()
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "player", for: indexPath)
        cell.textLabel?.text = players[indexPath.item]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65.0
    }
    
    
    //MARK: - User Interaction
    
    @IBAction func startGame(_ sender: Any) {
        print("Starting game")
    }
    
    
}
