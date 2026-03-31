import SwiftUI

struct ContentView: View {
    
    @State var display = "0"
    @State var firstNumber: Double = 0
    @State var currentOperation: String = ""
    @State var shouldResetDisplay = false
    @State var history: [String] = []
    
    let buttons = [
        ["7", "8", "9", "/"],
        ["4", "5", "6", "*"],
        ["1", "2", "3", "-"],
        ["0", ".", "=", "+"],
        ["C", "H"]
    ]
    
    var body: some View {
        VStack {
            Spacer()
            
            // History
            ScrollView {
                VStack(alignment: .trailing) {
                    ForEach(history, id: \.self) { item in
                        Text(item)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .frame(height: 100)
            
            // Display
            Text(display)
                .font(.system(size: 60))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding()
            
            // Buttons
            VStack(spacing: 12) {
                ForEach(buttons, id: \.self) { row in
                    HStack(spacing: 12) {
                        ForEach(row, id: \.self) { button in
                            Button(action: {
                                handleButtonPress(button)
                            }) {
                                Text(button)
                                    .font(.title)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 70)
                                    .background(buttonColor(button))
                                    .foregroundColor(.white)
                                    .cornerRadius(35)
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color.black)
    }
    
    func handleButtonPress(_ button: String) {
        
        // Numbers
        if "0123456789".contains(button) {
            if shouldResetDisplay {
                display = button
                shouldResetDisplay = false
            } else {
                display = display == "0" ? button : display + button
            }
        }
        
        // Decimal
        if button == "." {
            if !display.contains(".") {
                display += "."
            }
        }
        
        // Clear Display
        if button == "C" {
            display = "0"
            firstNumber = 0
            currentOperation = ""
        }
        
        // Clear History
        if button == "H" {
            history.removeAll()
        }
        
        // Operations
        if ["+", "-", "*", "/"].contains(button) {
            firstNumber = Double(display) ?? 0
            currentOperation = button
            shouldResetDisplay = true
        }
        
        // Equals
        if button == "=" {
            let secondNumber = Double(display) ?? 0
            var result: Double = 0
            
            switch currentOperation {
            case "+":
                result = firstNumber + secondNumber
            case "-":
                result = firstNumber - secondNumber
            case "*":
                result = firstNumber * secondNumber
            case "/":
                if secondNumber == 0 {
                    display = "Error"
                    return
                }
                result = firstNumber / secondNumber
            default:
                break
            }
            
            // Save history
            let historyEntry = "\(formatResult(firstNumber)) \(currentOperation) \(formatResult(secondNumber)) = \(formatResult(result))"
            history.append(historyEntry)
            
            // Limit history
            if history.count > 10 {
                history.removeFirst()
            }
            
            display = formatResult(result)
            shouldResetDisplay = true
        }
    }
    
    func formatResult(_ value: Double) -> String {
        if value.truncatingRemainder(dividingBy: 1) == 0 {
            return String(Int(value))
        } else {
            return String(value)
        }
    }
    
    func buttonColor(_ button: String) -> Color {
        if ["+", "-", "*", "/", "="].contains(button) {
            return .orange
        } else if button == "C" {
            return .red
        } else if button == "H" {
            return .blue
        } else {
            return Color.gray.opacity(0.3)
        }
    }
}

#Preview {
    ContentView()
}
