//
//  DefaultVerifyOTPUseCase.swift
//  CPCSTestTask
//
//  Created by Volodymyr Pysarenko on 26.06.2024.
//

import Foundation
import Combine

protocol VerifyOTPUseCase {
    var timeRemaining: Int { get set }
    var timerExpired: Bool { get set }

    func verifyCode(code: String) -> Void
}

final class DefaultVerifyOTPUseCase: VerifyOTPUseCase {
    
    var timer: AnyCancellable?
    
    @Published var timeRemaining = Constants.COUNTDOWN_TIMER_LENGTH
    @Published var timerExpired = false
    
    var verified: Bool = false
    
    init() {
        startTimer()
    }
    
    func verifyCode(code: String) {
        let storedCode = ""
        verified = code == storedCode
    }
    
    func startTimer() {
        timerExpired = false
        timeRemaining = Constants.COUNTDOWN_TIMER_LENGTH
        self.timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.countDownString()
                print(self?.timeRemaining)
            }
    }
    
    func stopTimer() {
        timerExpired = true
        self.timer?.cancel()
    }
    
    func countDownString() {
        guard (timeRemaining > 0) else {
            stopTimer()
            return
        }
        
        timeRemaining -= 1
    }
}
