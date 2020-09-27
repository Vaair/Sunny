//
//  NetworkWeatherManager.swift
//  Sunny
//
//  Created by Лера Тарасенко on 27.09.2020.
//  Copyright © 2020 Ivan Akulov. All rights reserved.
//

import Foundation

struct NetworkWeatherManager {
    
    func fetchCurrentWeather(forCity city: String){
    let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)"
    
    guard let url = URL(string: urlString) else { return }
    //работа с url ведется сессионно
    let session = URLSession(configuration: .default)
    let task = session.dataTask(with: url) { data, response, error in
        if let data = data {
            guard let dataString = String(data: data, encoding: .utf8) else { return }
            print(dataString)
        }
    }
    task.resume() //запуск
    }
}
