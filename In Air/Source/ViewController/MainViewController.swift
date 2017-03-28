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

    var continents: [Continent] = []

    var isCollectionActive: Bool {
        return tableView.contentOffset.y < -safeSpace
    }

    let safeSpace: CGFloat = 50

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        setupContinents()
        setupPlayer()

        setupSearchBar()
        setupTableView()
        setupCollectionView()
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

    func setupContinents() {
        continents.append(Continent(0, title: "Africa", description: ""))
        continents.append(Continent(1, title: "Europe", description: ""))
        continents.append(Continent(2, title: "Asia", description: ""))
        continents.append(Continent(3, title: "North America", description: ""))
        continents.append(Continent(4, title: "South America", description: ""))
        continents.append(Continent(5, title: "Antarctica", description: ""))
        continents.append(Continent(6, title: "Australia", description: ""))
    }

    func pan(_ gesture: UIPanGestureRecognizer) {
        guard isCollectionActive else {
            return
        }

        guard let indexPath = indexPath(in: gesture.location(in: self.view)) else {
            return
        }

        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)

        if let rect = collectionView.layoutAttributesForItem(at: indexPath)?.frame {
            collectionView.scrollRectToVisible(rect, animated: true)
        }

        checkTouchEnd(gesture)
    }

    func indexPath(in point: CGPoint) -> IndexPath? {

        let height = collectionView.frame.height / 2

        let x = point.x + collectionView.contentOffset.x

        let itemPoint = CGPoint(x: x, y: height)

        return checkIndex(on: point, indexPath: collectionView.indexPathForItem(at: itemPoint))
    }

    func checkIndex(on point: CGPoint, indexPath: IndexPath?) -> IndexPath? {
        guard var indexPath = indexPath else {
            return nil
        }

        if point.x < safeSpace {
            indexPath.row = indexPath.row > 0 ? indexPath.row - 1 : indexPath.row
        }

        if point.x > view.frame.width - safeSpace {
            let count = collectionView.numberOfItems(inSection: 0)
            indexPath.row = indexPath.row < count ? indexPath.row + 1 : indexPath.row
            indexPath.row = indexPath.row == count ? indexPath.row - 1 : indexPath.row
        }

        return indexPath
    }

    func checkTouchEnd(_ gesture: UIPanGestureRecognizer) {
        guard gesture.state == .ended, isCollectionActive else {
            return
        }

        guard let index = collectionView.indexPathsForSelectedItems?[0].row else {
            return
        }

        load(continent: continents[index])
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

    func load(continent: Continent) {
        //TODO: load content for continent
        print("load content for \(continent.title)")
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

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        let font = UIFont(name: "Modern Sans", size: 17) ?? UIFont.systemFont(ofSize: 17)
        let title = NSString(string: continents[indexPath.row].title)

        let size = title.size(attributes: [NSFontAttributeName: font])


        return CGSize(width: size.width, height: collectionView.frame.height)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return continents.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.cell(ContinentCollectionViewCell.self, indexPath: indexPath)
        cell.label.text = continents[indexPath.row].title
        return cell
    }
}
