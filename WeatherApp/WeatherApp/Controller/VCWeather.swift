//
//  VCWeather.swift
//  WeatherApp
//
//  Created by Hassan Qureshi on 8/14/20.
//  Copyright © 2020 hassan qureshi. All rights reserved.
//

import UIKit
import Speech

class VCWeather: BaseViewController , SFSpeechRecognizerDelegate {
    
    //MARK:- IBOutlets
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var countryTextField: DesignableTextField!
    @IBOutlet weak var speakerBtn: UIButton!
    @IBOutlet weak var countryNameLbl: UILabel!
    @IBOutlet weak var weatherImageContainer: UIImageView!
    @IBOutlet weak var temperatureLbl: UILabel!
    @IBOutlet weak var weatherTypeLbl: UILabel!
    @IBOutlet weak var backgroundImageContainer: UIImageView!
    
    //MARK:- VARIABLES
    var isStart : Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    //MARK:- SPEAKER BUTTON
    @IBAction func speakerBtnTapped(_ sender: UIButton) {
        if isStart {
            SpeachHandler.sharedInstance.cancelRecording()
            isStart = false
            speakerBtn.setImage(#imageLiteral(resourceName: "ic_mute"), for: .normal)
            self.view.makeToast("Stop Listening..")
            
        } else {
            
            SpeachHandler.sharedInstance.recordAndRecognizeSpeech(speechTextHandler: {[weak self] (speakString) in
                guard let self = self else {return}
                if let speakString = speakString {
                    self.checkForTextSaid(resultString: speakString )
                }
                }, vc: self)
            
            isStart = true
            speakerBtn.setImage(#imageLiteral(resourceName: "ic_mute_selected"), for: .normal)
            self.view.makeToast("Start Listening..")
        }
    }
    
    //MARK:- SETUP YOUR UI RELATED ELEMENTS
    fileprivate func setupUI () {
        
        SpeachHandler.sharedInstance.requestSpeechAuthorization {[weak self] (messages, btnEnabled) in
            self?.view.makeToast(messages)
            self?.speakerBtn.isEnabled = btnEnabled
        }
    }
    
    //MARK:- Api for Weather Data
    fileprivate func getWeatherDetail(countryName: String) {
        
        let countryNameSpaceReplace = countryName.replaceSpaceChracter(with: "%20")
        let weatherURL = BASE_URL + "?q=\(countryNameSpaceReplace)&APPID=\(WEATHER_KEY)&units=metric"
        self.showActivityView()
        WeatherService.sharedInstance.getWeatherAPi(url: weatherURL) {[weak self] (success, message, response) in
            self?.hideActivityView()
            if success {
                guard let weather = response else {return}
                self?.countryNameLbl.text = weather.name
                self?.temperatureLbl.text = "\(weather.main.temp)°C"
                var weatherType  = ""
                for value in weather.weathers {
                    self?.weatherTypeLbl.text = value.main
                    weatherType = value.main
                }
                DispatchQueue.main.async {
                    self?.setupWeatherTypes(weatherType: weatherType)
                    
                }
            } else {
                self?.view.makeToast(message)
            }
        }
    }
    // SET THE STRINGS VALUE
    func checkForTextSaid (resultString: String) {
        self.countryTextField.text = resultString
        self.getWeatherDetail(countryName: resultString)
    }
    
    func setupWeatherTypes (weatherType: String) {
        switch weatherType {
        case WeatherEnums.clouds.rawValue:
            backgroundImageContainer.image = #imageLiteral(resourceName: "Bg-Cloudy2")
            weatherImageContainer.image = #imageLiteral(resourceName: "Cloud66")
        case WeatherEnums.rain.rawValue:
            backgroundImageContainer.image = #imageLiteral(resourceName: "Bg-Rain")
            weatherImageContainer.image = #imageLiteral(resourceName: "Rain18")
        case WeatherEnums.haze.rawValue:
            backgroundImageContainer.image = #imageLiteral(resourceName: "Bg-Sunny")
            weatherImageContainer.image = #imageLiteral(resourceName: "Cloudy47")
        case WeatherEnums.clear.rawValue:
            backgroundImageContainer.image = #imageLiteral(resourceName: "Bg-Thunder")
            weatherImageContainer.image = #imageLiteral(resourceName: "Sunny5")
        case WeatherEnums.smoke.rawValue:
            backgroundImageContainer.image = #imageLiteral(resourceName: "Bg-Cloudy")
            weatherImageContainer.image = #imageLiteral(resourceName: "Snow")
        default:
            print("Weather Type not mtched")
            break
        }
    }
}

