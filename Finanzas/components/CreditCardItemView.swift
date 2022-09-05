//
//  CreditCardItem.swift
//  Finanzas
//
//  Created by Paulo Menezes on 04/09/22.
//

import SwiftUI

struct CreditCardItemView: View {
    public var name: String?
    public var limit: Double?
    public var available: Double?
    public var openedBill: Double?
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(name ?? "-")
                    .fontWeight(.bold)
                
                Spacer()
                
                Text(formatCurrency(value: available))
            }
            
            HStack {
                Text(formatCurrency(value: limit))
                Spacer()
                Text("Next bill: \(formatCurrency(value: openedBill))")
            }
        }
    }
}

struct CreditCardItemView_Previews: PreviewProvider {
    static var previews: some View {
        CreditCardItemView(name: "Nubank", limit: 10000.0, available: 100.20, openedBill: 100.30)
            .previewLayout(.sizeThatFits)
    }
}
