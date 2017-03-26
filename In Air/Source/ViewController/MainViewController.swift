//
//  MainViewController.swift
//  In Air
//
//  Created by Omar Allaham on 3/24/17.
//  Copyright © 2017 Bemaxnet. All rights reserved.
//

import UIKit

typealias MainLoader = MainViewController
typealias MainPlayerDelegate = MainViewController
typealias MainUpdater = MainViewController
typealias MainCollectionView = MainViewController

class MainViewController: UIViewController {

    class var instance: MainViewController {
        return MainViewController(nibName: "MainViewController", bundle: nil)
    }

    @IBOutlet weak var tableView: UITableView!

    var dataSource: [Airport] = [] {
        didSet{
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()

        //      bottomView.setup()

        tableView.register(AirportTableViewCell.self)

        tableView.dynamicHeight()

        Player.shared.delegate = self

        //      DataManager.main.get(type: Airport.self, onUpdate: onUpdate)

        onUpdate(DataManager.main.load())
    }
}

extension MainPlayerDelegate: PlayerDelegate {
    func player(stateChanged state: PlayerState) {
        //      bottomView.isPlaying = state == .playing
    }
}

extension MainUpdater {
    func onUpdate(_ airports: [Airport]) {

        let airports = airports.sorted {
            $0.title < $1.title
        }

        dataSource = airports
    }
}

extension MainCollectionView: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.cell(AirportTableViewCell.self, for: indexPath)
        cell.setup(dataSource[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delay(0) {
            PlayerView.shared.setup(self.dataSource[indexPath.row])

            Player.shared.airport = self.dataSource[indexPath.row]
            Player.shared.play()
        }
    }
}
