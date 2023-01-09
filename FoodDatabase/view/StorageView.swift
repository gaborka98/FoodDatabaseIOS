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
            VStack{
                ForEach(foods, id: \.self.id) { food in
                    FoodItemView(food: food)
                }
                Spacer()
            }
            .navigationTitle("Storage")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing){
                    Button {
                        isPresentingScanner = true
                    } label: {
                        Image(systemName: "barcode.viewfinder")
                            .foregroundColor(.none)
                    }
                }
            }
        }
    }
}

struct StorageView_preview: PreviewProvider {
    static var previews: some View {
        StorageView(isPresentingScanner: .constant(false), foods: [
        Food(id: "asd123", name: "TestFood", quantity: 500, barcode: "1234567", allergens: [], ingredients: []),
        Food(id: "dsa321", name: "TestPasta", quantity: 1000, barcode: "7654321", allergens: [], ingredients: [])
        ])
    }
}
