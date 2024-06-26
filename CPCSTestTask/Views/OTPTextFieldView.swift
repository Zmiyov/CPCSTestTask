//
//  OTPTextFieldView.swift
//  CPCSTestTask
//
//  Created by Volodymyr Pysarenko on 26.06.2024.
//

import SwiftUI
import Combine

struct OTPTextFieldView: View {
    enum FocusField: Hashable {
        case field
    }
    
    @FocusState private var pinFocusState : FocusPin?
    enum FocusPin {
        case  pinOne, pinTwo, pinThree, pinFour
    }
    
    @ObservedObject var phoneViewModel: PhoneViewModel
    @FocusState private var focusedField: FocusField?
    
    init(phoneViewModel: PhoneViewModel){
        self.phoneViewModel = phoneViewModel
    }
    
    private var backgroundTextField: some View {
        return TextField("", text: $phoneViewModel.pin)
            .frame(width: 0, height: 0, alignment: .center)
            .font(Font.system(size: 0))
            .accentColor(.blue)
            .foregroundColor(.blue)
            .multilineTextAlignment(.center)
            .keyboardType(.numberPad)
            .onReceive(Just(phoneViewModel.pin)) { _ in phoneViewModel.limitText(Constants.OTP_CODE_LENGTH) }
            .focused($focusedField, equals: .field)
            .task {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5)
                {
                    self.focusedField = .field
                }
            }
            .padding()
    }
    
    public var body: some View {
        VStack {
            ZStack(alignment: .center) {
                backgroundTextField
                HStack {
                    ForEach(0..<Constants.OTP_CODE_LENGTH) { index in
                        ZStack {
                            Text(phoneViewModel.getPin(at: index))
                                .font(Font.system(size: 27))
                                .fontWeight(.semibold)
                                .foregroundColor(Color.textColorPrimary)
                            Rectangle()
                                .frame(height: 2)
                                .foregroundColor(Color.textColorPrimary)
                                .padding(.trailing, 5)
                                .padding(.leading, 5)
                                .opacity(phoneViewModel.pin.count <= index ? 1 : 0)
                        }
                    }
                }
            }
            RoundedBorderTextField()
        }
    }
    
    @ViewBuilder
    func RoundedBorderTextField() -> some View {
        HStack(spacing:15) {
            
            TextField("", text: $phoneViewModel.pinOne)
                .modifier(OtpModifer(pin: $phoneViewModel.pinOne))
                .onChange(of: phoneViewModel.pinOne) {oldVal, newVal in
                    if (newVal.count == 1) {
                        pinFocusState = .pinTwo
                    }
                }
                .focused($pinFocusState, equals: .pinOne)
            
            TextField("", text:  $phoneViewModel.pinTwo)
                .modifier(OtpModifer(pin: $phoneViewModel.pinTwo))
                .onChange(of: phoneViewModel.pinTwo) {oldVal, newVal in
                    if (newVal.count == 1) {
                        pinFocusState = .pinThree
                    }
                }
                .focused($pinFocusState, equals: .pinTwo)
            
            TextField("", text: $phoneViewModel.pinThree)
                .modifier(OtpModifer(pin: $phoneViewModel.pinThree))
                .onChange(of: phoneViewModel.pinThree) {oldVal, newVal in
                    if (newVal.count == 1) {
                        pinFocusState = .pinFour
                    }
                }
                .focused($pinFocusState, equals: .pinThree)
            
            TextField("", text: $phoneViewModel.pinFour)
                .modifier(OtpModifer(pin: $phoneViewModel.pinFour))
                .focused($pinFocusState, equals: .pinFour)
        }
        .padding(.vertical)
    }
}

#Preview {
    OTPTextFieldView(phoneViewModel: PhoneViewModel())
}
