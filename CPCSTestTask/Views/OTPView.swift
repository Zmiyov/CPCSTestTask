//
//  OTPView.swift
//  CPCSTestTask
//
//  Created by Volodymyr Pysarenko on 26.06.2024.
//

import SwiftUI

struct OTPView: View {
    
    private enum Constants {
        static let titleSize: CGFloat = 22
        static let resendTextSize: CGFloat = 15
        static let infoTextSize: CGFloat = 12
        static let horizontalPadding: CGFloat = 20
    }

    @EnvironmentObject var otpDataViewModel: OTPDataViewModel
    
    var body: some View {
        VStack(spacing: 25) {
            topTextsView(viewModel: otpDataViewModel)
            OTPTextFieldView()
            underCodeView(viewModel: otpDataViewModel)
        }
        .padding(.horizontal, Constants.horizontalPadding)
    }
    
    @ViewBuilder
    private func topTextsView(viewModel: OTPDataViewModel) -> some View {
        VStack(spacing: 10){
            Text("Verify your Email Address")
                .font(.otpScreenFont(size: Constants.titleSize))
                .fontWeight(.semibold)
                .foregroundStyle(.black)
            
            Text(viewModel.infoText)
                .font(.otpScreenFont(size: Constants.infoTextSize))
                .fontWeight(.light)
                .foregroundStyle(viewModel.firstCodeCheckingDone ? (viewModel.codeIsVerified ? .green : .red) : .black)
                .foregroundStyle(.black)
                .padding(.top, 4)
        }
    }
    
    private func underCodeView(viewModel: OTPDataViewModel) -> some View {
        VStack(spacing: 0) {
            Text(viewModel.timeStr)
                .font(.otpScreenFont(size: Constants.resendTextSize))
                .foregroundColor(.black)
                .fontWeight(.regular)
            
            Button(action: {
                viewModel.startTimer()
            }) {
                Text("Resend")
                    .foregroundColor(viewModel.timerExpired ? .blue : .gray)
                    .font(.otpScreenFont(size: Constants.resendTextSize))
                    .fontWeight(.medium)
                    .frame(width: 150)
            }
            .padding(15)
            .disabled(!viewModel.timerExpired)
            
            Button(action: {
                viewModel.checkCode()
            }, label: {
                Spacer()
                Text("Continue")
                    .font(.otpScreenFont(size: Constants.titleSize))
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                Spacer()
            })
            .padding(15)
            .background(viewModel.continueButtonIsActive ? .blue : .gray)
            .clipShape(Capsule())
            .padding(.top)
            .disabled(!viewModel.continueButtonIsActive)
        }
    }
}

#Preview {
    OTPView()
        .environmentObject(OTPDataViewModel(verifyOTPUseCase: DefaultVerifyOTPUseCase(takeCodeService: MockTakeCodeService())))
}
