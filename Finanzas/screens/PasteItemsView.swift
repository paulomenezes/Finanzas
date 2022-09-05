//
//  PasteItemsView.swift
//  Finanzas
//
//  Created by Paulo Menezes on 04/09/22.
//

import SwiftUI

struct PasteItemsView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var content = ""
    
    public var callback: ([PasteItem]) -> Void
    
    var body: some View {
        NavigationView {
            TextEditor(text: $content)
                .lineLimit(999999999)
                .foregroundColor(.secondary)
                .font(.caption)
                .padding()
                .navigationTitle("Paste items")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            let lines = content.trimmingCharacters(in: .whitespacesAndNewlines).split(whereSeparator: \.isNewline)
                            
                            var pasteItems: [PasteItem] = []
                            
                            for index in stride(from: 0, to: lines.count, by: 2) {
                                let dateString = lines[index]
                                let nameValue = lines[index + 1]
                                
                                if let date = String(dateString).toDate(withFormat: "dd MMM") {
                                    let nameParts = String(nameValue).split(separator: "\t")
                                    var name = ""
                                    var value = ""
                                    var installmentFrom = ""
                                    var installmentTo = ""
                                    
                                    if nameParts.count == 2 {
                                        name = String(nameParts[0])
                                        value = String(nameParts[1])
                                    } else {
                                        name = String(nameParts[0])
                                        value = "0"
                                    }
                                    
                                    value = value.replacingOccurrences(of: ".", with: "").replacingOccurrences(of: ",", with: ".")
                                    
                                    let numberValue = Double(value) ?? 0
                                    
                                    if name.contains("/") {
                                        let installmentParts = name.split(separator: "/")
                                        
                                        if installmentParts.count == 2 {
                                            let installmentFromParts = installmentParts[0].split(separator: " ")
                                            
                                            installmentFrom = String(installmentFromParts.last ?? "")
                                            installmentTo = String(installmentParts[1])
                                        }
                                    }
                                    
                                    print("date: \(date) name: \(name) value: \(numberValue) - \(installmentFrom)/\(installmentTo)")
                                    
                                    pasteItems.append(PasteItem(date: date, name: name, value: numberValue, installmentFrom: installmentFrom.isEmpty ? nil : installmentFrom, installmentTo: installmentTo.isEmpty ? nil : installmentTo))
                                }
                            }
                            
                            callback(pasteItems)
                            dismiss()
                        }
                    }
                }
            
        }
    }
}

struct PasteItemsView_Previews: PreviewProvider {
    static var previews: some View {
        PasteItemsView { content in
            
        }
    }
}
