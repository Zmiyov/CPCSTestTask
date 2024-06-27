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
    let verifyOTPUseCase: VerifyOTPUseCaseProtocol
        
    @Published var timerExpired = false
    @Published var timeStr = "Resend code in 00:00"
    @Published var infoText = "Enter 4 digit code we'll text you on Email"
    @Published var continueButtonIsActive = false
    @Published var verificationCode = "" {
        didSet {
            codeChecked = false
            infoText = "Enter 4 digit code we'll text you on Email"
            continueButtonIsActive = !(verificationCode.count < Constants.OTP_CODE_LENGTH)
        }
    }
    @Published var verified = false
    @Published var codeChecked = false

    init(verifyOTPUseCase: VerifyOTPUseCaseProtocol) {
        self.verifyOTPUseCase = verifyOTPUseCase
        
        bindTimerPublishers()
    }
    
    private func bindTimerPublishers() {
        
        verifyOTPUseCase.timeRemaining
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { [weak self] remainingTime in
                self?.timeStr = "Resend code in " + String(format: "%02d:%02d", 00, remainingTime)
            }.store(in: &cancellables)

        verifyOTPUseCase.timerExpired
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { [weak self] timeExpired in
                self?.timerExpired = timeExpired
            }.store(in: &cancellables)
        
        verifyOTPUseCase.verified
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { [weak self] isVerified in
                self?.codeChecked = true
                self?.verified = isVerified
                if isVerified {
                    self?.infoText = "Code is verified!"
                } else {
                    self?.infoText = "Code is wrong. Please try again!"
                }
            }.store(in: &cancellables)

    }
    
    func startTimer() {
        verifyOTPUseCase.startTimer()
    }
    
    func checkCode() {
        verifyOTPUseCase.sendCodeVerifyingResult(code: verificationCode)
    }
    
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
