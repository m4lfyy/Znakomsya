import SwiftUI
import Combine

struct PhoneNumberFormatter: ViewModifier {
    @Binding var text: String
    private let limit = 18
    
    func body(content: Content) -> some View {
        content
            .keyboardType(.numberPad)
            .onReceive(Just(text)) { newValue in
                let filtered = newValue.filter { "0123456789".contains($0) }
                if filtered != newValue {
                    text = filtered
                }
                if text.count > limit {
                    text = String(text.prefix(limit))
                }
                text = applyPatternOnNumbers("+# (###) ###-##-##", text)
            }
    }
    
    private func applyPatternOnNumbers(_ pattern: String, _ pureNumber: String) -> String {
        var pureNumberIndex = 0
        var formattedString = ""
        for ch in pattern where pureNumberIndex < pureNumber.count {
            if ch == "#" {
                let index = pureNumber.index(pureNumber.startIndex, offsetBy: pureNumberIndex)
                formattedString.append(pureNumber[index])
                pureNumberIndex += 1
            } else {
                formattedString.append(ch)
            }
        }
        return formattedString
    }
}

extension View {
    func phoneNumberFormat(text: Binding<String>) -> some View {
        self.modifier(PhoneNumberFormatter(text: text))
    }
}

