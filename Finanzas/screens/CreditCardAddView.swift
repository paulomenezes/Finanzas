//
//  CreditCardAddView.swift
//  Finanzas
//
//  Created by Paulo Menezes on 03/09/22.
//

import SwiftUI

enum ItemsType: String, CaseIterable, Identifiable {
    case none
    case recurrent
    case installments
    
    var id: String { self.rawValue }
}

struct CreditCardAddView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State private var name: String = ""
    @State private var limit = 0
    @State private var available = 0
    @State private var closedDate = Date()
    
    @State var itemsValue = [Int]()
    @State var itemsType = [ItemsType]()
    @State var itemsInstallmentFrom = [String]()
    @State var itemsInstallmentTo = [String]()
    
    private var numberFormatter: NumberFormatterProtocol
    
    init(numberFormatter: NumberFormatterProtocol = PreviewNumberFormatter(locale: Locale(identifier: "pt_BR"))) {
        self.numberFormatter = numberFormatter
        self.numberFormatter.numberStyle = .currency
        self.numberFormatter.maximumFractionDigits = 2
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Detail")) {
                        TextField("Name", text: $name)
                        
                        HStack {
                            Text("Limit")
                            CurrencyTextField(numberFormatter: numberFormatter, value: $limit)
                        }
                        
                        HStack {
                            Text("Available")
                            CurrencyTextField(numberFormatter: numberFormatter, value: $available)
                        }
                        
                        DatePicker("Closed at", selection: $closedDate, displayedComponents: [.date])
                    }
                    
                    Section(header: Text("Items")) {
                        if itemsValue.count > 0 {
                            ForEach(0..<itemsValue.count, id: \.self) { index in
                                itemView(index: index)
                            }
                        }
                        
                        Button {
                            self.itemsValue.append(0)
                            self.itemsType.append(.none)
                            self.itemsInstallmentFrom.append("1")
                            self.itemsInstallmentTo.append("2")
                        } label: {
                            Label("Add", systemImage: "plus")
                        }
                    }
                }
            }
            .navigationTitle("Add credit card")
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
                        creditCard.limit = Double(limit) / 100
                        creditCard.available = Double(available) / 100
                        creditCard.closedAt = closedDate
                        creditCard.item = []
                        
                        try? managedObjectContext.save()
                        
                        for index in 0..<itemsValue.count {
                            let newItem = CreditCardItem(context: managedObjectContext)
                            newItem.id = UUID()
                            newItem.value = Double(itemsValue[index]) / 100
                            newItem.date = Date()
                            newItem.type = itemsType[index].rawValue
                            newItem.installmentFrom = Int16(itemsInstallmentFrom[index]) ?? 0
                            newItem.installmentTo = Int16(itemsInstallmentTo[index]) ?? 0
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
            HStack {
                Text("Value")
                CurrencyTextField(numberFormatter: numberFormatter, value: $itemsValue[index])
            }
            
            Picker("Type", selection: $itemsType[index]) {
                ForEach(ItemsType.allCases) { itemType in
                    Text(itemType.rawValue.capitalized)
                        .tag(itemType)
                }
            }
            .pickerStyle(.segmented)
            
            if itemsType[index] == .installments {
                HStack {
                    Text("Installments")
                    Spacer()
                    TextField("From", text: $itemsInstallmentFrom[index])
                        .frame(width: 50)
                    Text("/")
                        .font(.caption)
                        .foregroundColor(.gray.opacity(0.5))
                    TextField("To", text: $itemsInstallmentTo[index])
                        .frame(width: 50)
                }
            }
        }
        
    }
}

struct CreditCardAddView_Previews: PreviewProvider {
    static var previews: some View {
        CreditCardAddView()
    }
}
