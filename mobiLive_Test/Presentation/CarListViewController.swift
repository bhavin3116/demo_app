//
//  ViewController.swift
//  mobiLive_Test
//
//  Created by Bhavin on 2021-04-24.
//

import UIKit

class CarListViewController: UIViewController {

  struct customCellData {
    var expanded = Bool()
    var carObject : CarDetail
  }
  
  
  @IBOutlet weak var tableView: UITableView!
  var carDetail: [CarDetail]?
  var listTableData = [customCellData]()
  var firstIndex = true
  var isModelPicker = false
  var isMakePicker = false
  var modelList = [String]()
  var makeList = [String]()
  var modelSaveFilter = String()
  var makerSavedFilter = String()
  var filteredData: [CarDetail]?
  let UIPicker: UIPickerView = UIPickerView()
  var isFilterApplied = false
 
  override func viewDidLoad() {
    super.viewDidLoad()
     tableView.delegate = self
     tableView.dataSource = self
     tableView.register(UINib(nibName: "CarListCell", bundle: nil), forCellReuseIdentifier: "CarListCell")
     tableView.register(UINib(nibName: "MainViewCell", bundle: nil), forCellReuseIdentifier: "MainViewCell")
     tableView.register(UINib(nibName: "FilterCell", bundle: nil), forCellReuseIdentifier: "FilterCell")
     setTitle()
     UIPicker.delegate = self as UIPickerViewDelegate
     UIPicker.dataSource = self as UIPickerViewDataSource
     self.view.addSubview(UIPicker)
     UIPicker.frame = CGRect(x: 0, y: self.view.bounds.size.height - UIPicker.bounds.size.height, width: self.view.bounds.size.width, height: UIPicker.bounds.size.height);
     UIPicker.backgroundColor = UIColor.lightGray
     UIPicker.isHidden = true
  }
  override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      setupInitialView()
      prepareDataSource()
 }
}

// MARK: - Table View
extension CarListViewController: UITableViewDelegate,UITableViewDataSource {

   func numberOfSections(in tableView: UITableView) -> Int {
    if isFilterApplied {
      if filteredData?.count ?? 0 > 0 {
        return filteredData!.count + 2
      } else {
        return 2
      }
    } else {
      return carDetail!.count + 2
    }
   }
  
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     return 1
   }

   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.section == 0 {
       return 260
    }
    else if indexPath.section == 1 {
      return 200
    }
    else {
      if isFilterApplied {
        if listTableData[indexPath.section - 2].expanded == true {
           return UITableView.automaticDimension
        } else {
           return 150
        }
      } else {
        if listTableData[indexPath.section - 2].expanded == true {
           return UITableView.automaticDimension
        } else {
           return 150
        }
       }
     }
   }
  
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.section == 0 {
      let cell = tableView.dequeueReusableCell(withIdentifier: "MainViewCell", for: indexPath) as! MainViewCell
      return cell
    } else if indexPath.section == 1 {
      let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell", for: indexPath) as! FilterCell
      cell.filterDelegate = self
      cell.makeFilter.text = makerSavedFilter
      cell.modelFilter.text = modelSaveFilter
      return cell
    }
    else {
      let cell = tableView.dequeueReusableCell(withIdentifier: "CarListCell", for: indexPath) as! CarListCell
      var temp : CarDetail
      if isFilterApplied {
       temp =  filteredData![indexPath.section - 2]
      } else {
       temp = carDetail![indexPath.section - 2]
      }
      cell.assetName?.text = temp.model
      cell.assetImage.image = UIImage(named: temp.model)
      cell.assetRatings.rating = Float(temp.rating!)
      cell.assetPrice.text = temp.customerPrice?.kmFormatted
      //Clean up stackview to avoid duplications
      for case let label as UILabel in cell.consStackView.subviews {
        label.removeFromSuperview()
      }
      for case let label as UILabel in cell.prosStackView.subviews {
        label.removeFromSuperview()
      }
      if temp.consList.count>0 {
        for str in temp.consList {
          let label = UILabel(frame: CGRect(x: 0 , y: 200,width: 300, height: 21))
          label.text =  "•" + " " + str
          cell.consStackView.addArrangedSubview(label)
        }
      }
      if temp.prosList.count>0 {
        for str in temp.prosList {
          let label = UILabel(frame: CGRect(x: 0 , y: 200,width: 300, height: 21))
          label.text = "•" + " " + str
          cell.prosStackView.addArrangedSubview(label)
        }
      }
      return cell
    }
   }
  
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
  
    if indexPath.section != 0 && indexPath.section != 1 {
      if listTableData[indexPath.section - 2].expanded == true {
         listTableData[indexPath.section - 2].expanded = false
         let sections = IndexSet.init(integer: indexPath.section)
         tableView.reloadSections(sections, with: .automatic)
      } else {
        if isFilterApplied {
          listTableData[indexPath.section - 2].expanded = true
          let sections = IndexSet.init(integer: indexPath.section)
          tableView.reloadSections(sections, with: .automatic)
        } else {
          listTableData[indexPath.section - 2].expanded = true
          let sections = IndexSet.init(integer: indexPath.section)
          tableView.reloadSections(sections, with: .automatic)
        }
      }
    }
  }
}


// MARK: - Table View and Picker Views
extension CarListViewController: filterDelegates ,UIPickerViewDelegate,UIPickerViewDataSource {
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  func openModelFilter(_ selection: String) {
    UIPicker.isHidden = false
    isModelPicker = true
    isMakePicker = false
    UIPicker.reloadAllComponents()
  }
  
  func openMakeFilter(_ selection: String) {
    isModelPicker = false
    isMakePicker = true
    UIPicker.isHidden = false
    UIPicker.reloadAllComponents()
  }
  
  func closeFilter(_ selection: String) {
    UIPicker.isHidden = true
  }
  func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int{
      return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
    if isMakePicker {
      return makeList.count
    } else {
      return modelList.count
    }
  }
 
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    if isMakePicker {
      return makeList[row]
    } else {
      return modelList[row]
    }
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    if isMakePicker {
      makerSavedFilter = makeList[row]
    } else {
      modelSaveFilter = modelList[row]
    }
    prepareFilteredDataSource(Model: modelSaveFilter, Maker: makerSavedFilter)
  }
 
  func  getFilterQuearyData()  {
    if isFilterApplied {
      listTableData.removeAll()
      if let data = filteredData {
       for carObj in data {
         if firstIndex {
           listTableData.append(customCellData(expanded: true, carObject: carObj))
           firstIndex = false
         } else {
           listTableData.append(customCellData(expanded: false, carObject: carObj))
          }
         }
       }
    } else {
      if let data = self.carDetail {
        listTableData.removeAll()
       for carObj in data {
         if firstIndex {
           listTableData.append(customCellData(expanded: true, carObject: carObj))
           firstIndex = false
         } else {
           listTableData.append(customCellData(expanded: false, carObject: carObj))
          }
          modelList.append(carObj.model)
          makeList.append(carObj.make)
         }
       }
    }
  }
}

extension CarListViewController {
  
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
    // MARK: - Json fetch on main show spinner
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
    getFilterQuearyData()
  }
  
  func prepareFilteredDataSource(Model : String , Maker : String) {
     isFilterApplied = true
    if Maker.count != 0 {
      filteredData = carDetail?.filter({$0.make == Maker})
    }
    if Model.count != 0 {
      filteredData = carDetail?.filter({$0.model == Model})
    }
    UIPicker.isHidden = true
    getFilterQuearyData()
    tableView.reloadData()
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
