//
//  PhoneViewModel.swift
//  CPCSTestTask
//
//  Created by Volodymyr Pysarenko on 26.06.2024.
//

import Foundation

class PhoneViewModel: ObservableObject {
    //MARK: vars
    var nowDate = Date()
    

    @Published var pinOne: String = ""
    @Published var pinTwo: String = ""
    @Published var pinThree: String = ""
    @Published var pinFour: String = ""
    
    @Published var pin: String = ""
    @Published var phoneNumber = "+387 61 555 666"
    @Published var countryCodeNumber = ""
    @Published var country = ""
    @Published var code = ""
    @Published var timerExpired = false
    @Published var timeStr = ""
    @Published var timeRemaining = Constants.COUNTDOWN_TIMER_LENGTH
    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    //MARK: functions
    func startTimer() {
        timerExpired = false
        timeRemaining = Constants.COUNTDOWN_TIMER_LENGTH
        self.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    }
    
    func stopTimer() {
        timerExpired = true
        self.timer.upstream.connect().cancel()
    }

    func countDownString() {
        guard (timeRemaining > 0) else {
            self.timer.upstream.connect().cancel()
            timerExpired = true
            timeStr = String(format: "%02d:%02d", 00,  00)
            return
        }
        
        timeRemaining -= 1
        timeStr = String(format: "%02d:%02d", 00, timeRemaining)
    }
    
    func getPin(at index: Int) -> String {
        guard self.pin.count > index else {
            return ""
        }
        let character = self.pin[self.pin.index(self.pin.startIndex, offsetBy: index)]
        return String(character)
    }
    
    func limitText(_ upper: Int) {
        if pin.count > upper {
            pin = String(pin.prefix(upper))
        }
    }
}
