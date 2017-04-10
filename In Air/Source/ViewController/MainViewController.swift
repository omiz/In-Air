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

   @IBOutlet weak var topLabel: UILabel!
   @IBOutlet weak var searchBar: UISearchBar!
   @IBOutlet weak var tableView: UITableView!
   @IBOutlet weak var collectionView: UICollectionView!
   @IBOutlet weak var topConstraint: NSLayoutConstraint!

   var keyWord: String?

   var gesture: UIPanGestureRecognizer!

   var baseDataSource: [Airport] = []

   var dataSource: [Airport] = []

   var continents: [Continent] = []

   var activeContinent: Int?

   var isCollectionActive: Bool {
      return tableView.contentOffset.y < -safeSpace
   }

   var safeSpace: CGFloat {
      return collectionView.frame.height
   }

   var settingsBarButtonItem: UIBarButtonItem {
      return UIBarButtonItem(image: UIImage(named: "settings"), style: .plain, target: self, action: #selector(showSettings(_:)))
   }

//   var settingsItem:
   override func viewDidLoad() {
      super.viewDidLoad()

      navigationItem.rightBarButtonItems = [settingsBarButtonItem]
      setup()
      setupContinents()
      setupPlayer()

      setupSearchBar()
      setupTableView()
      setupCollectionView()
      setupGesture()

      hideSeachBar()
      //      DataManager.main.get(type: Airport.self, onUpdate: onUpdate)
   }

   func setup() {
      automaticallyAdjustsScrollViewInsets = false
      view.backgroundColor = .background

      setAttributedTitle("In Air")

      if #available(iOS 9.0, *) {
         if( traitCollection.forceTouchCapability == .available){

            registerForPreviewing(with: self, sourceView: view)

         }
      }
   }

   func hideSeachBar() {
      if tableView.visibleCells.count == 0 {
         let point = CGPoint(x: 0, y: searchBar.frame.height)
         tableView.setContentOffset(point, animated: false)
      } else {
         let indexPath = IndexPath(row: 0, section: 0)
         tableView.scrollToRow(at: indexPath, at: .top, animated: false)
      }
   }

   func filterIfNeeded() {
      dataSource = baseDataSource

      if let activeContinent = activeContinent {
         dataSource = dataSource.filter {
            $0.continentId == activeContinent
         }
      }

      if let keyWord = keyWord, !keyWord.isEmpty {
         dataSource = dataSource.filter {
            $0.title.contains(keyWord)
         }
      }
   }

   func setupSearchBar() {
      searchBar.textColor = UIColor.white
      searchBar.label?.textColor = .lightText
      searchBar.delegate = self
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
      //TODO: Load continents from the server
      continents.append(Continent(0, title: "Africa", description: ""))
      continents.append(Continent(1, title: "Antarctica", description: ""))
      continents.append(Continent(2, title: "Asia", description: ""))
      continents.append(Continent(3, title: "Australia", description: ""))
      continents.append(Continent(4, title: "Europe", description: ""))
      continents.append(Continent(5, title: "North America", description: ""))
      continents.append(Continent(6, title: "South America", description: ""))
   }

   func pan(_ gesture: UIPanGestureRecognizer) {

      guard isCollectionActive else {
         collectionView.indexPathsForSelectedItems?.forEach {
            collectionView.deselectItem(at: $0)
         }
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
      guard gesture.state == .ended else {
         return
      }

      guard let index = collectionView.indexPathsForSelectedItems?[0].row else {
         return
      }

      delay(0.6) {
         self.load(continent: self.continents[index])
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

      baseDataSource = airports.sorted {
         $0.title < $1.title
      }

      filterIfNeeded()

      tableView.reloadData()
   }

   func load(continent: Continent) {
      activeContinent = continents.index{ $0.id == continent.id }

      filterIfNeeded()

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

      navigationController?.navigationBar.shadowImageView?.isHidden = scrollView.contentOffset.y < 0

      let spaceFromTop = -scrollView.contentOffset.y

      guard spaceFromTop >= 0 else {
         return
      }

      topLabel.text = spaceFromTop > collectionView.frame.height ? "Release to select" : "Pull to select continent"

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

extension MainViewController: UISearchBarDelegate {
   func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
      keyWord = searchText

      filterIfNeeded()

      tableView.reloadData()
   }
}

extension MainViewController: UIViewControllerPreviewingDelegate {

   func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {

      let location = CGPoint.init(x: location.x, y: location.y + tableView.contentOffset.y)

      guard let indexPath = tableView?.indexPathForRow(at: location) else { return nil }

      let controller = AirportPreviewViewController.instance

      controller.airport = dataSource[indexPath.row]

      return controller
   }

   func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {

   }
}

extension MainViewController: UIViewControllerTransitioningDelegate {
   func showSettings(_ item: UIBarButtonItem) {

      guard let controller = UIStoryboard(name: "Settings", bundle: nil)
         .instantiateInitialViewController() else { return }

      navigationController?.pushViewController(controller, animated: true)
   }
}
