//
//  EmptyView.swift
//  Finanzas
//
//  Created by Paulo Menezes on 05/09/22.
//

import SwiftUI

struct EmptyView: View {
    public var title: String
    
    var body: some View {
        Spacer()
        VStack {
            Image(systemName: "tray")
                .font(.largeTitle)
            Text(title)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(.gray.opacity(0.3))
        )
        Spacer()
    }
}

struct EmptyView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView(title: "No transactions found")
    }
}
