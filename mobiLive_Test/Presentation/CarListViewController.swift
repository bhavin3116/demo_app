//
//  ViewController.swift
//  mobiLive_Test
//
//  Created by Bhavin on 2021-04-24.
//

import UIKit

class CarListViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "GUIDOMIA"
  }
  
  override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      setupInitialView()
 }
  
  func setupInitialView() {
    //Custom navigation bar
    navigationController?.navigationBar.prefersLargeTitles = true
    let appearance = UINavigationBarAppearance()
    appearance.backgroundColor = UIColor.init(red: 252.0/255.0, green: 96.0/255.0, blue: 22.0/255.0, alpha: 1.0)
    appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
    appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    navigationController?.navigationBar.tintColor = .white
    navigationController?.navigationBar.standardAppearance = appearance
    navigationController?.navigationBar.compactAppearance = appearance
    navigationController?.navigationBar.scrollEdgeAppearance = appearance
    //Set humbermenu class actions
    let imageBurger = UIImage(named: "ios_burger")!
    let btnRightMenu = UIButton(type: .system)
    btnRightMenu.bounds = CGRect(x: 10, y: 0, width: imageBurger.size.width, height: imageBurger.size.height)
    btnRightMenu.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    btnRightMenu.setImage(imageBurger, for: UIControl.State())
    let rightButton = UIBarButtonItem(customView: btnRightMenu)
    self.navigationItem.rightBarButtonItem = rightButton
  }
}

