//
//  OTPTextFieldView.swift
//  CPCSTestTask
//
//  Created by Volodymyr Pysarenko on 26.06.2024.
//

import SwiftUI

struct OTPTextFieldView: View {
    
    enum FocusField: Hashable {
        case field
    }
    
    @FocusState private var focusedField: FocusField?
    @ObservedObject var otpDataViewModel: OTPDataViewModel
    
    init(otpDataViewModel: OTPDataViewModel){
        self.otpDataViewModel = otpDataViewModel
    }
    
    public var body: some View {
        
        ZStack(alignment: .center) {
            BackgroundTextField()
            HStack(spacing: 15) {
                ForEach(0..<Constants.OTP_CODE_LENGTH) { index in
                    ZStack {
                        Text(otpDataViewModel.getPin(at: index))
                            .font(Font.system(size: 24))
                            .fontWeight(.regular)
                            .foregroundColor(Color.black)
                            .frame(width: 45, height: 45)
                            .background(Color.white.cornerRadius(5))
                            .background(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.blue, lineWidth: 2)
                            )
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func BackgroundTextField() -> some View {
        TextField("", text: $otpDataViewModel.verificationCode)
            .frame(width: 0, height: 0, alignment: .center)
            .font(Font.system(size: 0))
            .accentColor(.blue)
            .foregroundColor(.blue)
            .multilineTextAlignment(.center)
            .keyboardType(.numberPad)
            .onChange(of: otpDataViewModel.verificationCode) {oldVal, newVal in
                let filtered = newVal.filter { "0123456789".contains($0) }
                if filtered == newVal, filtered.count <= Constants.OTP_CODE_LENGTH {
                    otpDataViewModel.verificationCode = filtered
                } else {
                    otpDataViewModel.verificationCode = oldVal
                }
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
    OTPTextFieldView(otpDataViewModel: OTPDataViewModel(verifyOTPUseCase: DefaultVerifyOTPUseCase(takeCodeService: MockTakeCodeService())))
}
