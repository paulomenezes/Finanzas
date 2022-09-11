//
//  TransactionItemView.swift
//  Finanzas
//
//  Created by Paulo Menezes on 04/09/22.
//

import SwiftUI

struct TransactionItemView: View {
    public var name: String?
    public var value: Double?
    public var paid: Bool?
    public var type: String?
    public var date: Date?
    public var installmentsTo: Int16?
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if isIncome(type) {
                    Image(systemName: "arrow.up.right.circle")
                        .foregroundColor(.green)
                } else if isExpense(type) {
                    Image(systemName: "arrow.down.right.circle")
                        .foregroundColor(.red)
                } else {
                    Image(systemName: "arrow.left.arrow.right")
                        .foregroundColor(.blue)
                }
                
                Text(name ?? "-")
                    .fontWeight(.bold)
                
                Spacer()
                
                HStack {
                    if installmentsTo != nil && installmentsTo! > 1 {
                        Text("\(installmentsTo!)x")
                            .font(.caption)
                    }
                    Text(formatCurrency(value: value))
                }
                
                if paid ?? false {
                    Image(systemName: "checkmark.circle")
                        .foregroundColor(.green)
                }
            }
            
            if let date = date {
                Text((date).toFormattedString())
            }
        }
    }
}

struct TransactionItemView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionItemView(name: "Nubank", value: 10000.0, paid: false, type: "transfer", date: Date(), installmentsTo: 10)
            .previewLayout(.sizeThatFits)
        
        TransactionItemView(name: "Nubank", value: 10000.0, paid: false, type: "income", date: Date(), installmentsTo: 10)
            .previewLayout(.sizeThatFits)
        
        TransactionItemView(name: "Nubank", value: 10000.0, paid: false, type: "expense", date: Date(), installmentsTo: 10)
            .previewLayout(.sizeThatFits)
        
        TransactionItemView(name: "Nubank", value: 10000.0, paid: false, type: "transfer", installmentsTo: 10)
            .previewLayout(.sizeThatFits)
    }
}
