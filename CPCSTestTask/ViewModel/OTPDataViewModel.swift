//
//  PhoneViewModel.swift
//  CPCSTestTask
//
//  Created by Volodymyr Pysarenko on 26.06.2024.
//

import Foundation
import Combine

final class OTPDataViewModel: ObservableObject {
    
    var cancellables = Set<AnyCancellable>()

    let verifyOTPUseCase: DefaultVerifyOTPUseCase
    
//    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @Published var timeRemaining = Constants.COUNTDOWN_TIMER_LENGTH
    @Published var timerExpired = false
    @Published var timeStr = "Resend code in 00:00"
    @Published var infoText = "Enter 4 digit code we'll text you on Email"
    @Published var continueButtonIsActive = false
    @Published var verificationCode = "" {
        didSet {
            continueButtonIsActive = !(verificationCode.count < Constants.OTP_CODE_LENGTH)
        }
    }
    var isVerified = false
    
    init(verifyOTPUseCase: DefaultVerifyOTPUseCase) {
        self.verifyOTPUseCase = verifyOTPUseCase
        
        bind()
    }
    
    private func bind() {
        verifyOTPUseCase.$timeRemaining
            .sink { [weak self] remainingTime in
                self?.timeStr = "Resend code in " + String(format: "%02d:%02d", 00, remainingTime)
            }.store(in: &cancellables)
        
        verifyOTPUseCase.$timerExpired
            .sink { [weak self] timeExpired in
                self?.timerExpired = timeExpired
            }.store(in: &cancellables)
    }
    
//    func startTimer() {
//        timerExpired = false
//        timeRemaining = Constants.COUNTDOWN_TIMER_LENGTH
//        self.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
//    }
//    
//    func stopTimer() {
//        timerExpired = true
//        self.timer.upstream.connect().cancel()
//    }

//    func countDownString() {
//        guard (timeRemaining > 0) else {
//            stopTimer()
//            timeStr = "Resend code in " + String(format: "%02d:%02d", 00, 00)
//            return
//        }
//        
//        timeRemaining -= 1
//        timeStr = "Resend code in " + String(format: "%02d:%02d", 00, timeRemaining)
//    }
    
    
    func getPin(at index: Int) -> String {
        guard self.verificationCode.count > index else {
            return ""
        }
        let character = self.verificationCode[self.verificationCode.index(self.verificationCode.startIndex, offsetBy: index)]
        return String(character)
    }
    
    func limitText(_ upper: Int) {
        if verificationCode.count > upper {
            verificationCode = String(verificationCode.prefix(upper))
        }
    }

}
