//
//  CreditCardView.swift
//  Finanzas
//
//  Created by Paulo Menezes on 03/09/22.
//

import SwiftUI

struct CreditCardView: View {
    @State private var addModalView = false
    @FetchRequest(sortDescriptors: []) var creditCards: FetchedResults<CreditCard>
    
    var body: some View {
        NavigationView {
            VStack {
                List(creditCards) { creditCard in
                    CreditCardItemView(name: creditCard.name, limit: creditCard.limit, available: creditCard.available, openedBill: 100.0)
                }
            }
            .listStyle(.inset)
            .navigationTitle("Credit Card")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        addModalView.toggle()
                    } label: {
                        Label("Plus", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $addModalView) {
                CreditCardAddView()
            }
        }
    }
}

struct CreditCardView_Previews: PreviewProvider {
    static var previews: some View {
        CreditCardView()
    }
}
