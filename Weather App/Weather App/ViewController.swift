//
//  ViewController.swift
//  Weather App
//
//  Created by Jhoan Mauricio Vivas Rubiano on 18/05/20.
//  Copyright © 2020 Sennin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    @IBOutlet weak var cityNameTextField:UITextField!
    @IBOutlet weak var temperatureLabel:UILabel!
    @IBOutlet weak var humidityLabel:UILabel!
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cityNameTextField.rx.controlEvent(.editingDidEndOnExit).asObservable().map{self.cityNameTextField.text }.subscribe(onNext:{ cityName in
            if let cityName = cityName {
                if cityName.isEmpty {
                    self.displayWeather(nil)
                }else{
                    self.fetchWeather(by:cityName)
                }
            }
            
        }).disposed(by: disposeBag)
        
        // bad performance
        /*
         self.cityNameTextField.rx.value.subscribe(onNext: { (cityName) in
         if let cityName = cityName {
         if cityName.isEmpty{
         self.displayWeather(nil);
         }else{
         self.fetchWeather(by:cityName)
         }
         }
         }).disposed(by: disposeBag)
         */
    }
    
    private func displayWeather(_ weather:Weather?){
        if let weather = weather{
            self.temperatureLabel.text = "\(weather.temp) ºC"
            self.humidityLabel.text = "\(weather.humidity) ⛈"
        }else{
            self.temperatureLabel.text = "💩"
            self.humidityLabel.text = "❌"
        }
    }
    
    private func fetchWeather(by city: String) {
        guard let cityEncoded = city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed), let url = URL.urlForWeatherAPI(city: cityEncoded) else{
            return
        }
        
        
        let resource = Resource<WeatherResult>(url: url)
        
        let search =  URLRequest.load(resource: resource)
            .observeOn(MainScheduler.instance) // to be peding in the main UI thread avoiding writin UI distpacth code
            .asDriver(onErrorJustReturn:WeatherResult.emptyResult)
        
        search.map { "\($0.main.temp)ºC"
        }.drive(self.temperatureLabel.rx.text)
            .disposed(by: disposeBag)
        
        search.map { "\($0.main.humidity)⛈"
        }.drive(self.humidityLabel.rx.text)
            .disposed(by: disposeBag)
        // Without binding
        /*
         let search =  URLRequest.load(resource: resource)
         .observeOn(MainScheduler.instance) // to be peding in the main UI thread avoiding writin UI distpacth code
         .catchErrorJustReturn(WeatherResult.emptyResult)
         search.map { "\($0.main.temp)ºC"
         }.bind(to: self.temperatureLabel.rx.text).disposed(by: disposeBag)
         
         search.map { "\($0.main.humidity)⛈"
         }.bind(to: self.humidityLabel.rx.text).disposed(by: disposeBag)
         */
        /*
         //Without binding
         let resource = Resource<WeatherResult>(url: url)
         URLRequest.load(resource: resource)
         .observeOn(MainScheduler.instance) // to be peding in the main UI thread avoiding writin UI distpacth code
         .catchErrorJustReturn(WeatherResult.emptyResult)
         .subscribe(onNext:{ result in
         
         let  weather = result.main
         self.displayWeather(weather)
         
         }).disposed(by: disposeBag)
         */
    }
    
    
}

