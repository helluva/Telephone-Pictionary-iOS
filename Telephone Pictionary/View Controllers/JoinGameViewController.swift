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
    
    override func viewWillAppear(_ animated: Bool) {
        self.loadGames()
    }
    
    @IBAction func loadGames() {
        ApplicationState.state.sendMessage("requestListOfGames") { response in
            
            self.games = response.components(separatedBy: ";").flatMap { gameInfo in
                let components = gameInfo.components(separatedBy: ",")
                if components.count < 2 { return nil }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.selectRow(at: nil, animated: true, scrollPosition: .none)
        
        let game = self.games[indexPath.item]
        self.presentConfirmationAlert(gameName: game.gameName, gameId: game.gameId)
    }
    
    
    //MARK - User Interaction
    
    func presentConfirmationAlert(gameName: String, gameId: String) {
        let alert = UIAlertController(title: "Join \(gameName)?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Join", style: .default, handler: { _ in
            self.requestUsername(gameId: gameId)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func requestUsername(gameId: String, message: String? = nil) {
        let alert = UIAlertController(title: "What's your name?", message: message, preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Your Name"
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { _ in
            
            let name = alert.textFields?[0].text ?? ""
            
            if name.isEmpty {
                self.requestUsername(gameId: gameId, message: "We need your name so the other players know who you are.")
            } else {
                self.joinGame(gameId: gameId, username: name)
            }
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func joinGame(gameId: String, username: String) {
        
        ApplicationState.state.sendMessage("joinGame:\(username),\(gameId)")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250), execute: {
            PlayersViewController.present(in: self.navigationController!, playerIsHost: false)
        })
        
    }
    
}
