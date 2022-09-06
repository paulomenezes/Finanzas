//
//  CreditCardView.swift
//  Finanzas
//
//  Created by Paulo Menezes on 03/09/22.
//

import SwiftUI

struct CreditCardView: View {
    @State private var addModalView = false
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.name)
    ]) var creditCards: FetchedResults<CreditCard>
    
    var body: some View {
        NavigationView {
            VStack {
                if creditCards.count == 0 {
                    EmptyView(title: "No credit cards found")
                } else {
                    List(creditCards) { creditCard in
                        CreditCardItemView(name: creditCard.name, limit: creditCard.limit, available: creditCard.available, openedBill: 100.0)
                            .swipeActions {
                                Button("Delete") {
                                    managedObjectContext.delete(creditCard)
                                    try? managedObjectContext.save()
                                }
                                .tint(.red)
                            }
                    }
                }
            }
            .listStyle(.inset)
            .navigationTitle("Credit Cards")
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
