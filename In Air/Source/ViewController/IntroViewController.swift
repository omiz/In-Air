//
//  IntroViewController.swift
//  In Air
//
//  Created by Omar Allaham on 3/30/17.
//  Copyright © 2017 Bemaxnet. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {

   class var instance: IntroViewController {
      return IntroViewController(nibName: "IntroViewController", bundle: nil)
   }

   @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
   @IBOutlet weak var button: UIButton!


   var dataSource: [Any] = []

   override func viewDidLoad() {
      super.viewDidLoad()

      collectionView.register(IntroPageCollectionViewCell.self)

      setup()
   }

   func setup() {
      automaticallyAdjustsScrollViewInsets = false
      navigationController?.isNavigationBarHidden = true
      view.backgroundColor = .clear
//      button.tintColor = .blue
   }

   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
   }

   @IBAction func skip(_ sender: UIButton) {
      Router.set(UINavigationController(rootViewController: MainViewController.instance))
   }
}

extension IntroViewController: UICollectionViewDataSource, UICollectionViewDelegate {

   func collectionView(_ collectionView: UICollectionView,
                       layout collectionViewLayout: UICollectionViewLayout,
                       sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
      return view.bounds.size
   }

   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      pageControl.numberOfPages = 10
      return 10
   }

   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

      return collectionView.cell(IntroPageCollectionViewCell.self, indexPath: indexPath)
   }


   func scrollViewDidScroll(_ scrollView: UIScrollView) {
      let pageWidth = scrollView.frame.size.width
      let fractionalPage = scrollView.contentOffset.x / pageWidth
      let index = round(fractionalPage)

      let currentOffset = scrollView.contentOffset.x - (pageWidth * index)

      let percent = currentOffset / scrollView.frame.size.width

      let isDark = index.truncatingRemainder(dividingBy: 2.0) > 0

      let first: UIColor = isDark ? UIColor(hexString: "0B0B0B") : UIColor(hexString: "252525")
      let second: UIColor = isDark ? UIColor(hexString: "252525") : UIColor(hexString: "0B0B0B")

      view.backgroundColor = UIColor.between(first: first, second: second, percent: abs(percent - round(percent)))

      pageControl.currentPage = Int(index)
   }
}


