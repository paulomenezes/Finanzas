//
//  BillAddView.swift
//  Finanzas
//
//  Created by Paulo Menezes on 04/09/22.
//

import SwiftUI

import CurrencyTextField
import CurrencyFormatter

struct BillAddView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(sortDescriptors: []) var bankAccounts: FetchedResults<BankAccount>
    
    @State private var currencyFormatter = CurrencyFormatter.default
    
    @State private var name: String = ""
    
    @State private var value: Double? = 0.0
    @State private var valueText = "0"
    
    @State private var paid = false
    @State private var date = Date()
    @State private var paymentDate = Date()
    
    @State private var billType: BillType = .expense
    @State private var type: ItemsType = .none
    @State private var installmentFrom: String = "1"
    @State private var installmentTo: String = "2"
    
    @State private var accountFrom: UUID?
    @State private var accountTo: UUID?

    var colors = ["Red", "Green", "Blue", "Tartan"]

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Detail")) {
                        Picker("Type", selection: $billType) {
                            ForEach(BillType.allCases) { billType in
                                Text(billType.rawValue.capitalized)
                                    .tag(billType)
                            }
                        }
                        .pickerStyle(.segmented)
                        
                        TextField("Name", text: $name)
                        
                        HStack {
                            Text("Value")
                            CurrencyTextField(
                                configuration: .init(
                                    text: $valueText,
                                    inputAmount: $value,
                                    clearsWhenValueIsZero: true,
                                    formatter: $currencyFormatter,
                                    textFieldConfiguration: { uiTextField in
                                        uiTextField.keyboardType = .numbersAndPunctuation
                                        uiTextField.layer.masksToBounds = true
                                        uiTextField.textAlignment = .right
                                    }
                                )
                            )
                        }
                        
                        DatePicker("Date", selection: $date, displayedComponents: [.date])
                    }
                    
                    
                    Section(header: Text("Payment")) {
                        Toggle(billType == .expense ? "Paid" : billType == .income ? "Received" : "Transfered", isOn: $paid)
                        
                        if paid {
                            DatePicker(billType == .expense ? "Payment Date" : billType == .income ? "Received Date" : "Transfer Date", selection: $paymentDate, displayedComponents: [.date])
                        }
                        
                        Picker("From", selection: $accountFrom) {
                            ForEach(bankAccounts, id: \.id) { bankAccount in
                                Text(bankAccount.name ?? "-")
                            }
                        }
                        
                        if billType == .transfer {
                            Picker("To", selection: $accountTo) {
                                ForEach(bankAccounts, id: \.id) { bankAccount in
                                    Text(bankAccount.name ?? "-")
                                }
                            }
                        }
                    }
                    
                    Section(header: Text("Type")) {
                        Picker("Type", selection: $type) {
                            ForEach(ItemsType.allCases) { itemType in
                                Text(itemType.rawValue.capitalized)
                                    .tag(itemType)
                            }
                        }
                        .pickerStyle(.segmented)
                        
                        if type == .installments {
                            HStack {
                                Text("Installments")
                                Spacer()
                                TextField("From", text: $installmentFrom)
                                    .frame(width: 50)
                                    .multilineTextAlignment(.trailing)
                                Text("/")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                TextField("To", text: $installmentTo)
                                    .frame(width: 50)
                                    .multilineTextAlignment(.trailing)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Add transaction")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        save()
                        
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add more") {
                        save()
                        
                        name = ""
                        value = 0
                        date = Date()
                        paid = false
                        installmentFrom = "1"
                        installmentTo = "2"
                    }
                }
            }
        }
    }
    
    func save() {
        let bill = Bill(context: managedObjectContext)
        bill.id = UUID()
        bill.name = name
        bill.value = value ?? 0.0
        bill.date = date
        bill.paid = paid
        bill.paymentDate = paymentDate
        bill.installmentFrom = Int16(installmentFrom) ?? 0
        bill.installmentTo = Int16(installmentTo) ?? 0
        bill.type = type.rawValue
        bill.billType = billType.rawValue
        bill.accountFrom = accountFrom
        bill.accountTo = accountTo
        bill.createdAt = Date()
        bill.updateAt = Date()
        
        try? managedObjectContext.save()
        
    }
}

struct BillAddView_Previews: PreviewProvider {
    static var previews: some View {
        BillAddView()
    }
}
