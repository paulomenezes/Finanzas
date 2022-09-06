//
//  ContentView.swift
//  Finanzas
//
//  Created by Paulo Menezes on 03/09/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "chart.xyaxis.line")
                }
            BillView()
                .tabItem {
                    Label("Transactions", systemImage: "arrow.left.arrow.right")
                }
            BankAccountView()
                .tabItem {
                    Label("Accounts", systemImage: "banknote")
                }
            CreditCardView()
                .tabItem {
                    Label("Credit Cards", systemImage: "creditcard")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
