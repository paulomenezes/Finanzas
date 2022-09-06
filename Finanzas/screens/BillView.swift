//
//  BillView.swift
//  Finanzas
//
//  Created by Paulo Menezes on 04/09/22.
//

import SwiftUI

struct BillView: View {
    @State private var addModalView = false
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.date),
        SortDescriptor(\.name)
    ]) var bills: FetchedResults<Bill>
    
    var body: some View {
        NavigationView {
            VStack {
                if bills.count == 0 {
                    EmptyView(title: "No transactions found")
                } else {
                    List(bills) { bill in
                        BillItemView(name: bill.name, value: bill.value, paid: bill.paid, billType: bill.billType, date: bill.date)
                            .swipeActions {
                                Button("Delete") {
                                    managedObjectContext.delete(bill)
                                    try? managedObjectContext.save()
                                }
                                .tint(.red)
                            }
                    }
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
