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
        VStack{
            HStack{
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
            Spacer()
            HStack{
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
                    addFood(food: food!)
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
        }
            
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
        ScannedFoodView(food: Food(id: nil, name: "testFood", quantity: 500, barcode: "1234567", allergens: ["test1", "test2", "test3"], ingredients: ["test1", "test2", "test3"], photo: "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"), isPresentingScanner: .constant(false))
    }
    

}
