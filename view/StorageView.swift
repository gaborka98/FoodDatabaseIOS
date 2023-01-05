//
//  StorageView.swift
//  FoodDatabase
//
//  Created by Gábor Horváth on 2023. 01. 01..
//

import Foundation
import SwiftUI

struct StorageView: View {
    @Binding var isPresentingScanner : Bool
    @State var foods : [Food] = []
    
    var body: some View {
        NavigationView {
            Text("List of items")
            
            .navigationTitle("Storage")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing){
                    Button {
                        isPresentingScanner = true
                    } label: {
                        Image(systemName: "barcode.viewfinder")
                            .foregroundColor(.black)
                    }
                }
            }
        }
    }
}

struct StorageView_preview: PreviewProvider {
    static var previews: some View {
        StorageView(isPresentingScanner: .constant(false))
    }
}
