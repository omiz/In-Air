//
//  DataManager.swift
//  Clouds
//
//  Created by Omar Allaham on 3/19/17.
//  Copyright © 2017 Bemaxnet. All rights reserved.
//

import Foundation

import Foundation
import Alamofire
import ObjectMapper
import AlamofireObjectMapper

class DataManager {

   var baseUrl: String = ""
   
   class var main : DataManager {
      struct Static {
         static let instance : DataManager = DataManager()
      }
      return Static.instance
   }

   
   func get<T: Mappable>(_ url: String? = nil, type: T.Type, param: [String: Any]? = nil, retryCount: Int = 3, onUpdate: @escaping (([T]) -> Void)) {

      Alamofire.request(baseUrl + (url ?? ""), parameters: param).responseArray { (response: DataResponse<[T]>) in

         switch response.result {

         case .success(let value):
            onUpdate(value)

         case .failure:
            if retryCount > 0 {
               delay(10, closure: {
                  self.get(url, type: type, retryCount: retryCount - 1, onUpdate: onUpdate)
               })
            }

         }
      }
   }

   func load() -> [Airport] {
      var airports: [Airport] = []
      if let path = Bundle.main.path(forResource: "airports", ofType: "json") {
         do {
            let jsonData = try NSData(contentsOfFile: path, options: NSData.ReadingOptions.mappedIfSafe)
            do {
               let jsonResult: NSArray = try JSONSerialization.jsonObject(with: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray

               for item in jsonResult {
                  let i = item as? NSDictionary
                  let airport = Airport()
                  airport.id = i?["id"] as? Int ?? 0
                  airport.title = i?["title"] as? String ?? ""
                  airport.detail = i?["detail"] as? String ?? ""
                  airport.url = i?["url"] as? String ?? ""
                  airport.continentId = i?["continentId"] as? Int ?? -1

                  airports.append(airport)
               }

            } catch {}
         } catch {}
      }

      return airports
   }
}

protocol DataObject {

   associatedtype ObjectType = Self

   init(data: Any)

   static var url: String { get set }

   static var saved: ObjectType? { get set }
}
