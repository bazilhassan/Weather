//
//  SpeachHandler.swift
//  WeatherApp
//
//  Created by Hassan Qureshi on 8/16/20.
//  Copyright © 2020 hassan qureshi. All rights reserved.
//

import Foundation
import UIKit
import Speech

class SpeachHandler: NSObject {
    
    static let sharedInstance = SpeachHandler()
    
    fileprivate var currentVC : UIViewController?
    
    
    //MARK:- VARIABLES
    
    private let audioEngine = AVAudioEngine()
    private let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    private let request = SFSpeechAudioBufferRecognitionRequest()
    private var recognitionTask : SFSpeechRecognitionTask?
    
    //MARKS: CONSTANTS
    fileprivate struct Constants {
        static let alertHeading  = "Speech Recognition Error"
        static let audioError = "There has been an Audio Engin Error"
        static let recognitionSupportedError = "Speech recognition is not supported for your current locale."
        static let recogniitionAvailableError = "Speech recognition is not currently available. Check back at a later time."
        static let ACCESS_AUTHORISED = "User give access to speech recognition"
        static let ACCESS_DENIED = "User denied access to speech recognition"
        static let ACCESS_RESTRICTED = "Speech recognition restricted on this device"
        static let ACCESS_NOT_DETERMINED = "Speech recognaition not yet authorized"
    }
    
    
    //MARK:- CHECK AUTHORIZATION STATUS
    func requestSpeechAuthorization (completion: @escaping (_ message: String, _ isEnable: Bool)->Void) {
        SFSpeechRecognizer.requestAuthorization {(authStatus) in
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    completion(Constants.ACCESS_AUTHORISED, true)

                case .denied:
                    completion(Constants.ACCESS_DENIED, false)

                case .restricted:
                    completion(Constants.ACCESS_RESTRICTED, false)
                case .notDetermined:
                    
                    completion(Constants.ACCESS_NOT_DETERMINED, false)

                @unknown default:
                    return
                }
            }
        }
    }
    
    //MARK: RECOGNIZE SPEECH
    func recordAndRecognizeSpeech(speechTextHandler: @escaping ((String?)->Void), vc: UIViewController) {
        currentVC = vc
        let node = audioEngine.inputNode
        let recordingFormate = node.outputFormat(forBus: 0)
        
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormate) {[weak self] (buffer, avAudioeTime) in
            self?.request.append(buffer)
            
        }
        
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            self.showAlert(title: Constants.alertHeading, message: Constants.audioError)
            speechTextHandler(nil)
        }
        
        //Recognizer
        
        guard let myRecognizer = SFSpeechRecognizer() else {
            self.showAlert(title: Constants.alertHeading, message: Constants.recognitionSupportedError)
            speechTextHandler(nil)
            return
        }
        
        if !myRecognizer.isAvailable {
            self.showAlert(title: Constants.alertHeading, message: Constants.recogniitionAvailableError)
            speechTextHandler(nil)
            
            // Recognizer is not available right now
            return
        }
        
        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: {[weak self] (result, error) in
            
            if let result = result {
                let bestString = result.bestTranscription.formattedString
                var lastString: String = ""
                for segment in result.bestTranscription.segments {
                    let indexTo = bestString.index(bestString.startIndex, offsetBy: segment.substringRange.location)
                    lastString = String(bestString[indexTo...])
                }
                speechTextHandler(lastString)
                
                //                self?.speechTextHandler?(lastString)
                // self?.checkForTextSaid(resultString: lastString)
            } else if let error = error {
                self?.showAlert(title: Constants.alertHeading, message: Constants.recogniitionAvailableError)
                speechTextHandler(nil)
                
                print(error)
            }
        })
    }
    
    //MARK:- CANCEL THE RECORDING
    func cancelRecording() {
        recognitionTask?.finish()
        recognitionTask = nil
        
        //stop Audio
        request.endAudio()
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        
    }

    //MARK: - Alert
    fileprivate func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        currentVC?.present(alert, animated: true, completion: nil)
    }
}
