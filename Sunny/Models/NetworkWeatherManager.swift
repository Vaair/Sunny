//
//  NetworkWeatherManager.swift
//  Sunny
//
//  Created by Лера Тарасенко on 27.09.2020.
//  Copyright © 2020 Ivan Akulov. All rights reserved.
//

import Foundation
import CoreLocation

class NetworkWeatherManager {
    
    enum RequestType{
        case cityName(city: String)
        case coordinate(latitude: CLLocationDegrees, longtitude: CLLocationDegrees)
    }
    
    var onComplition: ((CurrentWeather) -> Void)?
    
    func fetchCurrentWeather(forRequestType requestType: RequestType){
        var urlString = ""
        
        switch requestType {
        case .cityName(let city):
            urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric"
        case .coordinate(let latitude, let longtitude):
            urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longtitude )&appid=\(apiKey)&units=metric"
        
        }
        performRequest(withURLString: urlString)
    }
    
    fileprivate func performRequest(withURLString urlString: String){
        guard let url = URL(string: urlString) else { return }
        //работа с url ведется сессионно
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            if let data = data {
                if let currentWeather = self.parseJSON(withjJSON: data){
                    self.onComplition?(currentWeather)
                }
            }
        }
        task.resume() //запуск
    }
    
    fileprivate func parseJSON(withjJSON data: Data) -> CurrentWeather? {
        let decoder = JSONDecoder()
        
        do {
            let currentWeatherData = try decoder.decode(CurrentWeatherData.self, from: data)
            guard let currentWeather = CurrentWeather(currentWeatherData: currentWeatherData) else { return nil }
            return currentWeather
        } catch let error as NSError {
            print(error.localizedDescription )
        }
        return nil
    }
    
}
