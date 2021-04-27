//
//  CarDetail.swift
//  mobiLive_Test
//
//  Created by Bhavin on 2021-04-27.
//

import Foundation

public struct CarDetail: Codable {
  let model,make: String
  let customerPrice,marketPrice : Double?
  let rating : Int?
  var consList = [String]()
  var prosList = [String]()
}


