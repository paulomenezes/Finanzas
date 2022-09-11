//
//  TransactionAddView.swift
//  Finanzas
//
//  Created by Paulo Menezes on 04/09/22.
//

import SwiftUI

import CurrencyTextField
import CurrencyFormatter

struct TransactionAddView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var managedObjectContext
    
    public var transactionItem: Transaction?
    
    @FetchRequest(sortDescriptors: []) var bankAccounts: FetchedResults<BankAccount>
    @FetchRequest(sortDescriptors: []) var creditCards: FetchedResults<CreditCard>
    
    @State private var currencyFormatter = CurrencyFormatter.default

    // Detail
    @State private var type: TransactionType = .expense
    @State private var paymentType: PaymentType = .debit

    @State private var name: String = ""
    
    @State private var value: Double? = 0.0
    @State private var valueText = "0"

    @State private var date = Date()
    // Detail
    
    // Payment
    @State private var paid = false
    @State private var paymentDate = Date()
    // - [PaymentType] is Debit -> Bank account
    // - [PaymentType] is Credit -> Credit card
    @State private var accountFrom: UUID?
    // - [Type] is transfer
    @State private var accountTo: UUID?
    // - Credit card payment
    @State private var creditCardPayment: UUID?
    // Payment

    // Type
    @State private var actionType: ActionType = .none
    // - Action type recurrent
    @State private var recurrentHasLastDate = false
    @State private var recurrentLastDate = Date()
    // - Action type installments
    @State private var installmentFrom: String = "1"
    @State private var installmentTo: String = "2"
    // Type

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Detail")) {
                        Picker("Type", selection: $type) {
                            ForEach(TransactionType.allCases) { transactionType in
                                Text(transactionType.rawValue.capitalized)
                                    .tag(transactionType)
                            }
                        }
                        .pickerStyle(.segmented)
                        .onChange(of: paymentType) { value in
                            accountFrom = nil
                            accountTo = nil
                        }
                        
                        if type == .expense {
                            Picker("Type", selection: $paymentType) {
                                ForEach(PaymentType.allCases) { paymentType in
                                    Text(paymentType.rawValue.capitalized)
                                        .tag(paymentType)
                                }
                            }
                            .pickerStyle(.segmented)
                            .onChange(of: paymentType) { value in
                                accountFrom = nil
                                accountTo = nil
                            }
                        }

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
                        Toggle(type == .expense ? "Paid" : type == .income ? "Received" : "Transfered", isOn: $paid)
                        
                        if paid {
                            DatePicker(type == .expense ? "Payment Date" : type == .income ? "Received Date" : "Transfer Date", selection: $paymentDate, displayedComponents: [.date])
                        }
                        
                        if paymentType == .debit {
                            Picker("From", selection: $accountFrom) {
                                ForEach(bankAccounts, id: \.id) { bankAccount in
                                    Text(bankAccount.name ?? "-")
                                }
                            }
                        } else {
                            Picker("From", selection: $accountFrom) {
                                ForEach(creditCards, id: \.id) { creditCard in
                                    Text(creditCard.name ?? "-")
                                }
                            }
                        }
                        
                        if type == .transfer {
                            Picker("To", selection: $accountTo) {
                                ForEach(bankAccounts, id: \.id) { bankAccount in
                                    Text(bankAccount.name ?? "-")
                                }
                            }
                        } else if type == .expense && paymentType == .debit {
                            Picker("Credit Card", selection: $creditCardPayment) {
                                ForEach(creditCards, id: \.id) { creditCard in
                                    Text(creditCard.name ?? "-")
                                }
                            }
                        }
                    }
                    
                    Section(header: Text("Type")) {
                        Picker("Type", selection: $actionType) {
                            ForEach(ActionType.allCases) { actionType in
                                Text(actionType.rawValue.capitalized)
                                    .tag(actionType)
                            }
                        }
                        .pickerStyle(.segmented)
                        
                        if actionType == .recurrent {
                            Toggle("Has last date", isOn: $recurrentHasLastDate)
                            
                            if recurrentHasLastDate {
                                DatePicker("Last Date", selection: $recurrentLastDate, displayedComponents: [.date])
                            }
                        }
                        
                        if actionType == .installments {
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
            .navigationTitle(transactionItem != nil ? "Update transaction" : "Add Transaction")
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
            .onAppear {
                if let transactionItem = transactionItem {
                    name = transactionItem.name ?? ""
                }
            }
        }
    }
    
    func save() {
        let bankAccountFrom = bankAccounts.first { bankAccount in
            bankAccount.id == accountFrom
        }
        
        let bankAccountTo = accountTo != nil ? bankAccounts.first { bankAccount in
            bankAccount.id == accountTo
        } : nil
        
        let creditCard = creditCardPayment != nil ? creditCards.first { creditCard in
            creditCard.id == creditCardPayment
        } : nil
        
        let transaction = Transaction(context: managedObjectContext)
        transaction.id = UUID()
        transaction.name = name
        transaction.value = value ?? 0.0
        transaction.date = date
        transaction.paid = paid
        transaction.paymentType = paymentType.rawValue
        transaction.paymentDate = paymentDate
        transaction.installmentFrom = Int16(installmentFrom) ?? 0
        transaction.installmentTo = Int16(installmentTo) ?? 0
        transaction.action = actionType.rawValue
        transaction.type = type.rawValue
        transaction.accountFrom = bankAccountFrom
        transaction.accountTo = bankAccountTo
        transaction.creditCardPayment = creditCard
        transaction.recurrentLastDate = recurrentHasLastDate ? recurrentLastDate : nil
        transaction.createdAt = Date()
        transaction.updateAt = Date()
        
        try? managedObjectContext.save()
    }
}

struct TransactionAddView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionAddView()
    }
}
