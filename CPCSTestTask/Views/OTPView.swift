//
//  OTPView.swift
//  CPCSTestTask
//
//  Created by Volodymyr Pysarenko on 26.06.2024.
//

import SwiftUI

struct OTPView: View {
    
    @StateObject var otpDataViewModel = OTPDataViewModel(verifyOTPUseCase: DefaultVerifyOTPUseCase())
    
    var body: some View {
        VStack {
            
            Text("Verify your Email Address")
                .font(.title2)
                .fontWeight(.semibold)
            Text(otpDataViewModel.infoText)
                .font(.caption)
                .fontWeight(.thin)
                .padding(.top, 4)
            
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
    func CountDownView() -> some View {
        Text(otpDataViewModel.timeStr)
            .font(Font.system(size: 15))
            .foregroundColor(Color.black)
            .fontWeight(.regular)
//            .onReceive(otpDataViewModel.timer) { _ in
//                otpDataViewModel.countDownString()
//            }
    }
    
    @ViewBuilder
    func ContinueButton() -> some View {
        Button(action: {
            print("Continue")
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
