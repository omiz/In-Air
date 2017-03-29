//
//  WeatherManager.swift
//  In Air
//
//  Created by Omar Allaham on 3/29/17.
//  Copyright © 2017 Bemaxnet. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire

class WeatherManager {

   static let shared = WeatherManager()

   let base = "https://query.yahooapis.com/v1/public/yql?"

   func forecast(for location: String, onUpdate: @escaping ((WeatherForecast?, Error?) -> Void)) {

      Alamofire.request(base, parameters: parameter(for: location)).responseObject { (response: DataResponse<WeatherForecast>) in

         switch response.result {

         case .success(let value):
            onUpdate(value, nil)

         case .failure(let error):
            onUpdate(nil, error)
         }
      }
   }

   fileprivate func parameter(for location: String) -> [String: Any] {
      var param: [String:Any] = [:]

      param["q"] = "select * from weather.forecast where woeid in (select woeid from geo.places(1) where text=\"\(location)\")"

      param["format"] = "json"

      param["env"] = "store://datatables.org/alltableswithkeys"

      return param
   }
}

class WeatherForecast: Mappable {
   var city: String?
   var country: String?
   var region: String?
   var windDirection: Double = 0
   var windSpeed: Double = 0
   var pressure: Double = 0
   var visibility: Double = 0
   var link: String?
   var imageURL: String?

   var distanceUnit: String?
   var pressureUnit: String?
   var speedUnit: String?
   var temperatureUnit: String?

   let transform = TransformOf<Double, String>(fromJSON: { (value: String?) -> Double? in
      guard let value = value else {
         return nil
      }

      guard let double = Double(value) else {
         return nil
      }

      return Darwin.floor(double * 10) / 10

   }, toJSON: { (value: Double?) -> String? in
      // transform value from Int? to String?
      if let value = value {
         return String(value)
      }
      return nil
   })

   required init?(map: Map) {
   }

   func mapping(map: Map) {
      link           <- map["query.results.channel.link"]
      city           <- map["query.results.channel.location.city"]
      country        <- map["query.results.channel.location.country"]
      region         <- map["query.results.channel.location.region"]
      windDirection  <- (map["query.results.channel.wind.direction"], transform)
      windSpeed      <- (map["query.results.channel.wind.speed"], transform)
      pressure       <- (map["query.results.channel.atmosphere.pressure"], transform)
      visibility     <- (map["query.results.channel.atmosphere.visibility"], transform)
      imageURL       <- map["query.results.channel.image.url"]

      distanceUnit    <- map["query.results.channel.units.distance"]
      pressureUnit    <- map["query.results.channel.units.pressure"]
      speedUnit       <- map["query.results.channel.units.speed"]
      temperatureUnit <- map["query.results.channel.units.temperature"]
   }
}

extension Double {
   func roundTo(places:Int) -> Double {
      let multiplier = pow(0, Double(places))
      return Darwin.floor(self * multiplier) / multiplier
   }
}
