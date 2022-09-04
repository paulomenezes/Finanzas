//
//  ContentView.swift
//  Finanzas
//
//  Created by Paulo Menezes on 03/09/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                TabView {
                    Text("teste")
                        .tabItem {
                            Label("Dashboard", systemImage: "chart.xyaxis.line")
                        }
                    Text("teste 2")
                        .tabItem {
                            Label("Bills", systemImage: "doc.text.image")
                        }
                    Text("teste 2")
                        .tabItem {
                            Label("Accounts", systemImage: "banknote")
                        }
                    CreditCardView()
                        .tabItem {
                            Label("Credit Card", systemImage: "creditcard")
                        }
                        .navigationTitle("Credit Card")
                }
            }
            .navigationTitle("Finanzas")
            .toolbar {
                Button("Teste") {
                    
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
