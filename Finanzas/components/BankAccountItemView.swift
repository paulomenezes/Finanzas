//
//  BankAccountItemView.swift
//  Finanzas
//
//  Created by Paulo Menezes on 04/09/22.
//

import SwiftUI

struct BankAccountItemView: View {
    public var name: String?
    public var balance: Double?
    public var savedMoney: Double?
    
    var body: some View {
        HStack {
            Text(name ?? "-")
                .fontWeight(.bold)
            
            Spacer()
            
            Text(formatCurrency(value: (balance ?? 0.0) + (savedMoney ?? 0.0)))
        }
    }
}

struct BankAccountItemView_Previews: PreviewProvider {
    static var previews: some View {
        BankAccountItemView(name: "Nubank", balance: 10000.0, savedMoney: 100.20)
            .previewLayout(.sizeThatFits)
    }
}
