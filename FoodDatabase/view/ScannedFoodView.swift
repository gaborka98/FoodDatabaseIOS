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
    
    @Environment(\.dismiss) var dismiss
    
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
                    
                    if let photo = food.photo {
                        Image(data: Data(base64Encoded: photo)!)
                    }
                    
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            isPresentingScanner = true
                            dismiss()
                        } label: {
                            Image(systemName: "arrow.left")
                        }
                        .frame(width: 50, height: 50)
                        .font(.largeTitle)
                        .background(Color.red.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        
                        Button {
                            addFood(food: food)
                        } label: {
                            Image(systemName: "plus")
                        }
                        .frame(width: 50, height: 50)
                        .font(.largeTitle)
                        .background(Color.green.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        Spacer()
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
            .toolbar(.hidden)
            .navigationBarBackButtonHidden(true)
        }
    
    func addFood(food: Food) {
        ApiCaller.shared.addFood(food: food) { res  in
            switch res {
            case .success(_):
                print("kiraly")
            case .failure(_):
                print("szar")
            }
        }
        dismiss()
    }
}

struct ScannedFoodView_Previews: PreviewProvider {
    static var previews: some View {
        ScannedFoodView(food: Food(id: nil, name: "testFood", quantity: 500, barcode: "1234567", allergens: ["test1", "test2", "test3"], ingredients: ["test1", "test2", "test3"], photo: ""), isPresentingScanner: .constant(false))
    }
    

}
