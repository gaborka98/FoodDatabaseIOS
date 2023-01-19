//
//  StorageView.swift
//  FoodDatabase
//
//  Created by Gábor Horváth on 2023. 01. 01..
//

import Foundation
import SwiftUI
import AlertToast

struct StorageView: View {
    @Binding var isPresentingScanner : Bool
    @State var foods : [StorageFood] = []
    @State var errorMsg: String = ""
    @State var ShowErrorToast: Bool = false
    
    var body: some View {
        NavigationView {
            VStack{
                ForEach(foods, id: \.self.food.id) { food in
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
        }.toast(isPresenting: $ShowErrorToast, duration: 4, tapToDismiss: true, alert: {
            AlertToast(type:.error(Color.red), title: "Error", subTitle: errorMsg)
        }, completion: { self.ShowErrorToast = false})
        .onAppear(perform: fetchData)
    }
    
    func fetchData() {
        ApiCaller.shared.getAllFood(completion: { res in
            switch res{
            case.success(let storage):
                foods = storage.content
            case.failure(let error):
                print(error.localizedDescription)
                errorMsg = error.localizedDescription
                ShowErrorToast = true
            }
        })
    }
}

struct StorageView_preview: PreviewProvider {
    static var previews: some View {
        StorageView(isPresentingScanner: .constant(false), foods: [
            StorageFood(totalCount: 500, count: 5, food: Food(id: "asd123", name: "TestFood", quantity: 500, barcode: "1234567", allergens: [], ingredients: []))
        ,
        StorageFood(totalCount: 1000, count: 10, food: Food(id: "dsa321", name: "TestPasta", quantity: 1000, barcode: "7654321", allergens: [], ingredients: []))
        ])
    }
}
