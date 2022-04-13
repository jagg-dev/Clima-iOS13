//
//  Weather.swift
//  Clima
//
//  Created by Jorge Gonzalez on 12/04/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

struct WeatherManager {
    var weatherUrl = "https://api.openweathermap.org/data/2.5/weather?appid=fc70c97f63ec774f07c72eac0c4989f7&units=metric"
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherUrl)&q=\(cityName)"
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String) {
        // 1. Create a URL
        if let url = URL(string: urlString) {
            // 2. Create a URLSession
            let session = URLSession(configuration: .default)
            
            // 3. Give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    let dataString = String(data: safeData, encoding: .utf8)
                    print(dataString!)
                    
                    parseJSON(weatherData: safeData)
                }
            }
            
            // 4. Start the task
            task.resume()
        }
    }
    
    func parseJSON(weatherData: Data) {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            
            let weatherId = decodedData.weather[0].id
            let name = decodedData.name
            let temperature = decodedData.main.temp
            
            let weather = WeatherModel(conditionId: weatherId, cityName: name, temperature: temperature)
            
            print(weather.conditionName)
            
            
        } catch {
            print(error)
        }   
    }
    
}
