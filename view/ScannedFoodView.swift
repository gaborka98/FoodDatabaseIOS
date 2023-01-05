//
//  ScannedFoodView.swift
//  FoodDatabase
//
//  Created by Gábor Horváth on 2023. 01. 05..
//

import SwiftUI
import AlertToast

struct ScannedFoodView: View {
    var food: Food?
    @State var showToast: Bool = false
    @State var errorMsg: String = ""
    @State var showErrorToast: Bool = false
    
    @Binding var isPresentingScanner: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            if let food = food {
                Text("name: \(food.name)")
                Text("barcode: \(food.barcode)")
                Text("quantity: \(food.quantity) g")
                Text("allergens:")
                ForEach(food.allergens, id: \.self) {allergen in
                    Text("\t \(allergen.replacingOccurrences(of: "en:", with: ""))")
                }
                Text("ingredients:")
                ForEach(food.ingredients, id: \.self) { ing in
                    Text("\t \(ing)")
                }
                
                Spacer()
                HStack {
                    Button("Close") {
                        isPresentingScanner = true
                    }
                    .font(.largeTitle)
                    .background(Color.red.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    Button("Add to storage") {
                        ApiCaller.shared.addFood(food: food) {result in
                            switch result {
                            case .success(let food):
                                if food.id != nil {
                                    showToast = true
                                }
                            case .failure(let error):
                                errorMsg = error.localizedDescription
                                showErrorToast = true
                            }
                        }
                    }
                    .font(.largeTitle)
                    .background(Color.green.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            } else {
                Text("cannot find food")
            }
        }
        .toast(isPresenting: $showToast,duration: 1, alert: {
            AlertToast(type:.complete(Color.green), title: "Food added")
        }, completion: {
            isPresentingScanner = true
        })
        .toast(isPresenting: $showErrorToast, duration: 4) {
            AlertToast(type:.error(Color.red), title: "Error", subTitle: errorMsg)
        }
    }
}

struct ScannedFoodView_Previews: PreviewProvider {
    static var previews: some View {
        ScannedFoodView(food: Food(id: nil, name: "testFood", quantity: 500, barcode: "1234567", allergens: ["test1", "test2", "test3"], ingredients: ["test1", "test2", "test3"]), isPresentingScanner: .constant(false))
    }
}
