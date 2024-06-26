//
//  OTPView.swift
//  CPCSTestTask
//
//  Created by Volodymyr Pysarenko on 26.06.2024.
//

import SwiftUI

struct OTPView: View {
    
    @StateObject var otpDataViewModel = OTPDataViewModel(verifyOTPUseCase: DefaultVerifyOTPUseCase(takeCodeService: MockTakeCodeService()))
    
    var body: some View {
        VStack {

            TopTexts()
                .padding(.horizontal)
            
            OTPTextFieldView(otpDataViewModel: otpDataViewModel)
                .padding(.horizontal, 50)
                .padding(.vertical, 20)
                .padding(.top, 8)
            
            VStack(spacing: 0){
                CountDownView()
                ButtonReactivate()
                ContinueButton()
            }
        }
    }
    
    @ViewBuilder
    func TopTexts() -> some View {
        Text("Verify your Email Address")
            .font(.title2)
            .fontWeight(.semibold)
            .foregroundStyle(.black)
        if otpDataViewModel.codeChecked {
            Text(otpDataViewModel.infoText)
                .font(.caption)
                .fontWeight(.light)
                .foregroundStyle(otpDataViewModel.verified ? .green : .red)
                .padding(.top, 4)
        } else {
            Text(otpDataViewModel.infoText)
                .font(.caption)
                .fontWeight(.light)
                .foregroundStyle(.black)
                .padding(.top, 4)
        }
    }
    
    @ViewBuilder
    func CountDownView() -> some View {
        Text(otpDataViewModel.timeStr)
            .font(Font.system(size: 15))
            .foregroundColor(Color.black)
            .fontWeight(.regular)
    }
    
    @ViewBuilder
    func ButtonReactivate() -> some View {
        Button(action: {
            otpDataViewModel.startTimer()
        }) {
            Text("Resend")
                .foregroundColor(otpDataViewModel.timerExpired ? Color.blue : Color.gray)
                .font(Font.system(size: 15))
                .fontWeight(.medium)
                .frame(maxWidth: 150)
        }
        .padding(15)
        .cornerRadius(50)
        .disabled(!otpDataViewModel.timerExpired)
    }
    
    @ViewBuilder
    func ContinueButton() -> some View {
        Button(action: {
            otpDataViewModel.checkCode()
        }, label: {
            Spacer()
            Text("Continue")
                .font(.system(.title3, design: .rounded))
                .fontWeight(.semibold)
                .foregroundColor(.white)
            Spacer()
        })
        .padding(15)
        .background(otpDataViewModel.continueButtonIsActive ? Color.blue : Color.gray)
        .clipShape(Capsule())
        .padding(.horizontal)
        .padding(.top)
        .disabled(!otpDataViewModel.continueButtonIsActive)
    }
}

#Preview {
    OTPView()
}
