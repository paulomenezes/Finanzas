//
//  TransactionItemView.swift
//  Finanzas
//
//  Created by Paulo Menezes on 05/09/22.
//

import SwiftUI

struct TransactionItemView: View {
    public var name: String?
    public var value: Double?
    public var paid: Bool?
    public var billType: String?
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if billType == BillType.income.rawValue {
                    Image(systemName: "arrow.up.right.circle")
                        .foregroundColor(.green)
                } else if billType == BillType.expense.rawValue {
                    Image(systemName: "arrow.down.right.circle")
                        .foregroundColor(.red)
                } else {
                    Image(systemName: "arrow.left.arrow.right")
                        .foregroundColor(.blue)
                }
                
                Text(name ?? "-")
                    .fontWeight(.bold)
                
                Spacer()
                
                Text(formatCurrency(value: value))
                
                if paid ?? false {
                    Image(systemName: "checkmark.circle")
                        .foregroundColor(.green)
                }
            }
        }
    }}

struct TransactionItemView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionItemView(name: "Nubank", value: 10000.0, paid: false, billType: "transfer")
            .previewLayout(.sizeThatFits)
    }
}
