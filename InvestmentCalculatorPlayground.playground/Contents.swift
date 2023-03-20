import UIKit

var initialValue: Decimal
var monthlyInvestment: Decimal
var dividendYeld: Decimal
var objective: Decimal

// Parameters
initialValue = 10000
monthlyInvestment = 2000
dividendYeld = 12.27
objective = 1000000
// End of Parameters

var patrimony = initialValue
var yearCount = 0

let formatter = DateFormatter()
formatter.dateFormat = "MMMM"

extension Decimal {
    func toMoney(localeIdentifier: String = "pt_BR") -> String {
        let moneyFormat = NumberFormatter()
        moneyFormat.numberStyle = .currency
        moneyFormat.locale = Locale(identifier: localeIdentifier)
        return moneyFormat.string(from: self as NSNumber) ?? ""
    }
}

func centralizedYearColumn(tableWidth: Int, yearCount: Int) -> String {
    let padding = (tableWidth - "YEAR \(yearCount)".count) / 2
    
    var extraRightPadding = String()
    if (padding % 2 == 1) {
        extraRightPadding = " ";
    }
    
    let header = "|\(String(repeating: " ", count: padding))YEAR \(yearCount)\(String(repeating: " ", count: padding))\(extraRightPadding)|"
    return header
}

func separatorLine(tableWidth: Int) -> String {
    let separator = "+\(String(repeating: "-", count: tableWidth))+"
    return separator
}

func formatTableColumn(_ text: String, width: Int, isCentered: Bool) -> String {
    var paddedText = ""
    
    if isCentered {
        let padding = (width - text.count) / 2
        paddedText = String(repeating: " ", count: padding) + text + String(repeating: " ", count: padding)
        
        if (text.count % 2 == 1) {
            return paddedText + " "
        }
        
    } else {
        let padding = (width - text.count - 1)
        paddedText = " " + text + String(repeating: " ", count: padding)
    }
    
    return paddedText
}

func tableRow(tableWidth: Int, values: [String], isCentered: Bool = false) -> String {
    
    guard values.count == 5 else {
        return String("* incomplete table row, please provide 5 values *")
    }
    
    let columnWidth = (tableWidth - 4) / 5
    var row = String()
    
    for (index, value) in values.enumerated() {
        let column = index == (values.count - 1) ? formatTableColumn(value, width: columnWidth, isCentered: isCentered) : "\(formatTableColumn(value, width: columnWidth, isCentered: isCentered))|"
        row.append(column)
    }
    
    return "|\(row)|"
}

func calculateYearlyIncone() {
    let tableWidth = 94 // should finish with 4 or 9
    yearCount += 1
    
    print(separatorLine(tableWidth: tableWidth))
    print(centralizedYearColumn(tableWidth: tableWidth, yearCount: yearCount))
    print(separatorLine(tableWidth: tableWidth))
    print(tableRow(tableWidth: tableWidth, values: ["MONTH", "PATRIMONY", "INVESTMENT", "INCOME", "TOTAL"], isCentered: true))
    print(separatorLine(tableWidth: tableWidth))
    
    let currentMonthNumber = yearCount == 1 ? Calendar.current.component(.month, from: Date()) : 1
    
    for monthNumber in currentMonthNumber...12 {
        
        let willReceiveIncome = !(yearCount == 1 && monthNumber == currentMonthNumber)
        
        let monthlyRate = dividendYeld / 12
        let income = willReceiveIncome ? ((monthlyRate/100) * patrimony) : 0
        let total = patrimony + monthlyInvestment + income
        let month = formatter.monthSymbols[monthNumber - 1]
        
        print(tableRow(
            tableWidth: tableWidth,
            values: [month, patrimony.toMoney(), monthlyInvestment.toMoney(), income.toMoney(), total.toMoney()]
        ))
        
        patrimony = total
    }
    
    print(separatorLine(tableWidth: tableWidth))
    print("\n\n")
    
    if patrimony < objective {
        calculateYearlyIncone()
    }
    
}

calculateYearlyIncone()
