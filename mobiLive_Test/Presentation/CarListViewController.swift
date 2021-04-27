//
//  ViewController.swift
//  mobiLive_Test
//
//  Created by Bhavin on 2021-04-24.
//

import UIKit

class CarListViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  var carDetail: [CarDetail]?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UINib(nibName: "CarListCell", bundle: nil), forCellReuseIdentifier: "CarListCell")
    tableView.register(UINib(nibName: "MainViewCell", bundle: nil), forCellReuseIdentifier: "MainViewCell")
    setTitle()
  }
  
  override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      setupInitialView()
      prepareDataSource()
 }
  
  func setupInitialView() {
    //Custom navigation bar
    //navigationController?.navigationBar.prefersLargeTitles = true
    let appearance = UINavigationBarAppearance()
    appearance.backgroundColor = UIColor.init(red: 252.0/255.0, green: 96.0/255.0, blue: 22.0/255.0, alpha: 1.0)
    appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
    appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    navigationController?.navigationBar.tintColor = .white
    navigationController?.navigationBar.standardAppearance = appearance
    navigationController?.navigationBar.compactAppearance = appearance
    navigationController?.navigationBar.scrollEdgeAppearance = appearance
    //Set humberburger-menu class actions
    let imageBurger = UIImage(named: "ios_burger")!
    let btnRightMenu = UIButton(type: .system)
    btnRightMenu.bounds = CGRect(x: 10, y: 0, width: imageBurger.size.width, height: imageBurger.size.height)
    btnRightMenu.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    btnRightMenu.setImage(imageBurger, for: UIControl.State())
    let rightButton = UIBarButtonItem(customView: btnRightMenu)
    self.navigationItem.rightBarButtonItem = rightButton
  }
  
  func setTitle() {
    let TitleLabel = UILabel()
    TitleLabel.text = "GUIDOMIA"
    TitleLabel.textColor = .white
    TitleLabel.font = UIFont(descriptor: UIFontDescriptor(name: "Futura-Bold", size: 25), size: 25)
    TitleLabel.sizeToFit()
    let leftItem = UIBarButtonItem(customView: TitleLabel)
    self.navigationItem.leftBarButtonItem = leftItem
  }
  
  func prepareDataSource() {
    // MARK: - Json fetch
    if let path = Bundle.main.path(forResource: "car_list", ofType: "json") {
        do {
              let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
              if let fields = try? JSONDecoder().decode([CarDetail].self, from: data) {
              self.carDetail = fields
            }
          } catch {
            // handle error
            print(error.localizedDescription)
          }
      }
  }
}

// MARK: - Table View
extension CarListViewController: UITableViewDelegate,UITableViewDataSource {

   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return carDetail!.count + 1
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.row == 0 {
      return 260
    }
    return 150
  }
  
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.row == 0 {
      let cell = tableView.dequeueReusableCell(withIdentifier: "MainViewCell", for: indexPath) as! MainViewCell
      return cell
    } else {
      let cell = tableView.dequeueReusableCell(withIdentifier: "CarListCell", for: indexPath) as! CarListCell
      let temp = carDetail![indexPath.row - 1]
      cell.assetName?.text = temp.model
      cell.assetImage.image = UIImage(named: temp.model)
      cell.assetRatings.rating = Float(temp.rating!)
      cell.assetPrice.text = temp.customerPrice?.kmFormatted
      return cell
    }
   }
}

extension Double {
    var kmFormatted: String {
        if self >= 10000, self <= 999999 {
            return String(format: "%.1fK", locale: Locale.current,self/1000).replacingOccurrences(of: ".0", with: "")
        }
        if self > 999999 {
            return String(format: "%.1fM", locale: Locale.current,self/1000000).replacingOccurrences(of: ".0", with: "")
        }
        return String(format: "%.0f", locale: Locale.current,self)
    }
}
