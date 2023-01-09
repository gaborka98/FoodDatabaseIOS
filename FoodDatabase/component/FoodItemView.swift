//
//  FoodItemView.swift
//  FoodDatabase
//
//  Created by Gabor Horvath on 2023. 01. 09..
//

import SwiftUI

struct FoodItemView: View {
    @State var food : Food
    
    var body: some View {
        HStack(alignment: .center){
            ZStack{
                Circle().fill(.gray).frame(width: 50, height: 50)
                    .shadow(radius: 15)
                Circle().stroke(AngularGradient(colors: [.red, .yellow, .green, .blue, .purple, .red], center: .center), style: StrokeStyle(lineWidth: 3))
                    .frame(width: 50, height: 50)
            }
                
            VStack(alignment: .leading, spacing: 10){
                Text(food.name)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .shadow(radius: 0.5)
                Text(food.barcode)
                    .fontWeight(.light)
                    .fontDesign(.rounded)
                    .shadow(radius: 0.5)
            }
            Spacer()
            Text("\(food.quantity.formatted()) g").shadow(radius: 0.5)
        }
        .frame(maxWidth: 400)
        .padding(12)
        .background(LinearGradient(colors: [.orange, .purple, .cyan], startPoint: .topLeading, endPoint: .bottomTrailing))
        .cornerRadius(10)
    }
}

struct FoodItemView_Previews: PreviewProvider {
    static var previews: some View {
        FoodItemView(food: Food(id: nil, name: "testFood", quantity: 500, barcode: "1234567", allergens: ["test1", "test2","test3"], ingredients: ["testa","testb","testc"]))
    }
}
