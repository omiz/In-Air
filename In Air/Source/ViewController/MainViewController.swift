//
//  MainViewController.swift
//  In Air
//
//  Created by Omar Allaham on 3/24/17.
//  Copyright © 2017 Bemaxnet. All rights reserved.
//

import UIKit
import TextAttributes

typealias MainLoader = MainViewController
typealias MainPlayerDelegate = MainViewController
typealias MainUpdater = MainViewController
typealias MainCollectionView = MainViewController

class MainViewController: UIViewController {

    class var instance: MainViewController {
        return MainViewController(nibName: "MainViewController", bundle: nil)
    }

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!

    var gesture: UIPanGestureRecognizer!

    var dataSource: [Airport] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        setupSearchBar()
        setupTableView()
        setupCollectionView()
        setupPlayer()
        setupGesture()

        //      DataManager.main.get(type: Airport.self, onUpdate: onUpdate)
    }

    func setupSearchBar() {
        let attribute = TextAttributes()
            .font(name: "Modern Sans", size: 17)
            .foregroundColor(Color.lightGray)

        searchBar.textColor = UIColor.white

        searchBar
            .textField
            .attributedPlaceholder = NSAttributedString(string: "Airport",
                                                        attributes: attribute)
    }

    func setupCollectionView() {
        collectionView.register(ContinentCollectionViewCell.self)
    }

    func setupTableView() {
        tableView.register(AirportTableViewCell.self)

        tableView.dynamicHeight()
    }

    func setupPlayer() {
        Player.shared.delegate = self
        onUpdate(DataManager.main.load())
    }

    func setupGesture() {
        gesture = UIPanGestureRecognizer(target: self, action: #selector(pan(_:)))

        tableView.addGestureRecognizer(gesture)

        gesture.delegate = self
    }

    func pan(_ gesture: UIPanGestureRecognizer) {
        let point = gesture.location(in: self.view)

        let height = collectionView.frame.height / 2

        let x = point.x + collectionView.contentOffset.x

        let itemPoint = CGPoint(x: x, y: height)

        guard var indexPath = collectionView.indexPathForItem(at: itemPoint) else {
            return
        }

        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)

        if point.x < 30 {
            indexPath.row = indexPath.row > 0 ? indexPath.row - 1 : indexPath.row

            let rect = collectionView.layoutAttributesForItem(at: indexPath)?.frame
            collectionView.scrollRectToVisible(rect!, animated: true)
        }

        if point.x > view.frame.width - 50 {
            let count = collectionView.numberOfItems(inSection: 0)
            indexPath.row = indexPath.row < count ? indexPath.row + 1 : indexPath.row
            indexPath.row = indexPath.row == count ? indexPath.row - 1 : indexPath.row

            let rect = collectionView.layoutAttributesForItem(at: indexPath)?.frame
            collectionView.scrollRectToVisible(rect!, animated: true)
        }
    }
}

extension MainViewController: UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
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

        tableView.reloadData()
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
            Player.shared.airport = self.dataSource[indexPath.row]
            Player.shared.play()
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == tableView else {
            return
        }

        let spaceFromTop = -scrollView.contentOffset.y

        guard spaceFromTop >= 0 else {
            return
        }

        topConstraint.constant = spaceFromTop
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.cell(ContinentCollectionViewCell.self, indexPath: indexPath)
        cell.label.text = "label \(indexPath.row)"
        return cell
    }
}
