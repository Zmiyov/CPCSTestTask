//
//  OTPTextFieldView.swift
//  CPCSTestTask
//
//  Created by Volodymyr Pysarenko on 26.06.2024.
//

import SwiftUI

struct OTPTextFieldView: View {
    
    private enum FocusField: Hashable {
        case field
    }
    
    @FocusState private var focusedField: FocusField?
    @EnvironmentObject var otpDataViewModel: OTPDataViewModel
    
    var body: some View {
        
        ZStack(alignment: .center) {
            backgroundTextField(viewModel: otpDataViewModel, codeText: $otpDataViewModel.verificationCode)
            HStack(spacing: 15) {
                ForEach(0..<Constants.OTP_CODE_LENGTH) { index in
                    ZStack {
                        Text(otpDataViewModel.getPin(at: index))
                            .font(.system(size: 24))
                            .fontWeight(.regular)
                            .foregroundColor(.black)
                            .frame(width: 45, height: 45)
                            .background(Color.white.clipShape(RoundedRectangle(cornerRadius: 5)))
                            .background(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(.blue, lineWidth: 2)
                            )
                    }
                }
            }
        }
    }
    
    private func backgroundTextField(viewModel: OTPDataViewModel, codeText: Binding<String>) -> some View {
        TextField("", text: codeText)
            .frame(width: 0, height: 0, alignment: .center)
            .font(.system(size: 0))
            .accentColor(.blue)
            .foregroundColor(.blue)
            .multilineTextAlignment(.center)
            .keyboardType(.numberPad)
            .onChange(of: viewModel.verificationCode) { newVal in
                viewModel.getOnlyValidFormatCode(inputText: newVal, viewModel: viewModel)
            }
            .focused($focusedField, equals: .field)
            .task {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5)
                {
                    self.focusedField = .field
                }
            }
            .padding()
    }
}

#Preview {
    OTPTextFieldView()
        .environmentObject(OTPDataViewModel(verifyOTPUseCase: DefaultVerifyOTPUseCase(takeCodeService: MockTakeCodeService())))
}
