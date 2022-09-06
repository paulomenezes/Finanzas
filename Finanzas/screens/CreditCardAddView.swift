//
//  CreditCardAddView.swift
//  Finanzas
//
//  Created by Paulo Menezes on 03/09/22.
//

import SwiftUI

import CurrencyTextField
import CurrencyFormatter

struct CreditCardAddView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(sortDescriptors: []) var bankAccounts: FetchedResults<BankAccount>
    
    @State private var currencyFormatter = CurrencyFormatter.default
    
    @State private var showPasteModal = false
    
    @State private var name: String = ""
    @State private var limitText: String = "0"
    @State private var limit: Double? = 0.0
    @State private var available: Double = 0.0
    @State private var paymentDate = Date()
    @State private var closedDate = Date()
    
    @State private var paymentAccount: UUID?
    
    @State var itemsValueText = [String]()
    @State var itemsValue = [Double?]()
    @State var itemsDate = [Date]()
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Detail")) {
                        TextField("Name", text: $name)
                        
                        HStack {
                            Text("Limit")
                            
                            CurrencyTextField(
                                configuration: .init(
                                    text: $limitText,
                                    inputAmount: $limit,
                                    clearsWhenValueIsZero: true,
                                    formatter: $currencyFormatter,
                                    textFieldConfiguration: { uiTextField in
                                        uiTextField.keyboardType = .numbersAndPunctuation
                                        uiTextField.layer.masksToBounds = true
                                        uiTextField.textAlignment = .right
                                    },
                                    onCommit: {
                                        calculateAvailable()
                                    }
                                )
                            )
                        }
                        
                        HStack {
                            Text("Available")
                            Spacer()
                            Text(formatCurrency(value: available))
                        }
                        
                        DatePicker("Payment at", selection: $paymentDate, displayedComponents: [.date])
                        
                        DatePicker("Closed at", selection: $closedDate, displayedComponents: [.date])
                        
                        Picker("Payment account", selection: $paymentAccount) {
                            ForEach(bankAccounts, id: \.id) { bankAccount in
                                Text(bankAccount.name ?? "-")
                            }
                        }
                    }
                    
                    Section(header: Text("Bills")) {
                        if itemsValue.count > 0 {
                            ForEach(0..<itemsValue.count, id: \.self) { index in
                                itemView(index: index)
                            }
                        }
                        
                        Button {
                            self.itemsValueText.append("0")
                            self.itemsValue.append(0)
                            
                            if self.itemsDate.isEmpty {
                                self.itemsDate.append(paymentDate)
                            } else {
                                self.itemsDate.append(Calendar.current.date(byAdding: .month, value: 1, to: self.itemsDate.last ?? Date()) ?? Date())
                            }
                            
                            calculateAvailable()
                        } label: {
                            Label("Add", systemImage: "plus")
                        }
                    }
                }
            }
            .navigationTitle("Add Credit Card")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let creditCard = CreditCard(context: managedObjectContext)
                        creditCard.id = UUID()
                        creditCard.name = name
                        creditCard.limit = limit ?? 0
                        creditCard.available = available
                        creditCard.closedDate = closedDate
                        creditCard.paymentDate = paymentDate
                        creditCard.paymentAccount = paymentAccount
                        creditCard.createdAt = Date()
                        creditCard.updateAt = Date()
                        creditCard.item = []
                        
                        try? managedObjectContext.save()
                        
                        for index in 0..<itemsValue.count {
                            let newItem = CreditCardItem(context: managedObjectContext)
                            newItem.id = UUID()
                            newItem.name = "Fatura \(itemsDate[index].toFormattedString())"
                            newItem.value = itemsValue[index] ?? 0
                            newItem.date = itemsDate[index]
                            newItem.creditCard = creditCard
                            
                            try? managedObjectContext.save()
                        }
                        
                        dismiss()
                    }
                }
            }
        }
    }
    
    func itemView(index: Int) -> some View {
        VStack {
            DatePicker("Date", selection: $itemsDate[index], displayedComponents: [.date])
            
            HStack {
                Text("Value")
                CurrencyTextField(
                    configuration: .init(
                        text: $itemsValueText[index],
                        inputAmount: $itemsValue[index],
                        clearsWhenValueIsZero: true,
                        formatter: $currencyFormatter,
                        textFieldConfiguration: { uiTextField in
                            uiTextField.keyboardType = .numbersAndPunctuation
                            uiTextField.layer.masksToBounds = true
                            uiTextField.textAlignment = .right
                        },
                        onCommit: {
                            calculateAvailable()
                        }
                    )
                )
                
            }
        }
    }
    
    func calculateAvailable() {
        var available: Double = limit ?? 0
        
        for item in itemsValue {
            available -= item ?? 0
        }
        
        self.available = available
    }
}

struct CreditCardAddView_Previews: PreviewProvider {
    static var previews: some View {
        CreditCardAddView()
    }
}
