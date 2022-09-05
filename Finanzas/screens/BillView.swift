//
//  BillView.swift
//  Finanzas
//
//  Created by Paulo Menezes on 04/09/22.
//

import SwiftUI

struct BillView: View {
    @State private var addModalView = false
    @FetchRequest(sortDescriptors: []) var bills: FetchedResults<Bill>
    
    var body: some View {
        NavigationView {
            VStack {
                List(bills) { bill in
                    BillItemView(name: bill.name, value: bill.value, paid: bill.paid, billType: bill.billType, date: bill.date)
                }
            }
            .listStyle(.inset)
            .navigationTitle("Transactions")
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
                BillAddView()
            }
        }
    }
}

struct BillView_Previews: PreviewProvider {
    static var previews: some View {
        BillView()
    }
}
