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
                    VStack(alignment: .leading) {
                        Text(creditCard.name ?? "Unknown")
                            .fontWeight(.bold)
                        HStack {
                            Text("R$ 18.000,00")
                            Spacer()
                            Text("Available: R$ 720,20")
                        }
                        
                        Divider()
                        
                        Text("Fatura aberta: R$ 5.600,20")
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(.gray.opacity(0.2))
                    )
                }
            }
            .padding()
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
