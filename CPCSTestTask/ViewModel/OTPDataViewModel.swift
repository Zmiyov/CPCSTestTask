//
//  PhoneViewModel.swift
//  CPCSTestTask
//
//  Created by Volodymyr Pysarenko on 26.06.2024.
//

import Foundation
import Combine

final class OTPDataViewModel: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()
    private let verifyOTPUseCase: VerifyOTPUseCaseProtocol
        
    @Published private(set) var timerExpired = false
    @Published private(set) var timeStr = "Tap to resend code"
    @Published private(set) var infoText = "Enter 4 digit code we'll text you on Email"
    @Published private(set) var continueButtonIsActive = false
    @Published var verificationCode = "" {
        didSet {
            firstCodeCheckingDone = false
            infoText = "Enter 4 digit code we'll text you on Email"
            continueButtonIsActive = !(verificationCode.count < Constants.OTP_CODE_LENGTH)
        }
    }
    @Published private(set) var codeIsVerified = false
    @Published private(set) var firstCodeCheckingDone = false

    init(verifyOTPUseCase: VerifyOTPUseCaseProtocol) {
        self.verifyOTPUseCase = verifyOTPUseCase
        bindTimerPublishers()
    }
    
    private func bindTimerPublishers() {
        
        verifyOTPUseCase.timeRemaining
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Timer error: \(error)")
                }
            } receiveValue: { [weak self] remainingTime in
                self?.timeStr = "Resend code in " + String(format: "%02d:%02d", 00, remainingTime)
            }.store(in: &cancellables)

        verifyOTPUseCase.timerExpired
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Updating resend button state error: \(error)")
                }
            } receiveValue: { [weak self] timeExpired in
                self?.timerExpired = timeExpired
                if timeExpired {
                    self?.timeStr = "Tap to resend code"
                }
            }.store(in: &cancellables)
        
        verifyOTPUseCase.verified
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Verifying error: \(error)")
                }
            } receiveValue: { [weak self] isVerified in
                self?.firstCodeCheckingDone = true
                self?.codeIsVerified = isVerified
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

    func getOnlyValidFormatCode(inputText: String, viewModel: OTPDataViewModel) {
        let filtered = inputText.filter { "0123456789".contains($0) }
        if filtered == inputText, filtered.count <= Constants.OTP_CODE_LENGTH {
            viewModel.verificationCode = filtered
        } else {
            viewModel.verificationCode = String(filtered.prefix(Constants.OTP_CODE_LENGTH))
        }
    }
}
