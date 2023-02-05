//
//  FoodItemView.swift
//  FoodDatabase
//
//  Created by Gabor Horvath on 2023. 01. 09..
//

import SwiftUI

struct FoodItemView: View {
    var food : StorageFood
    
    var body: some View {
        HStack(alignment: .center){
            ZStack{
                if let photo = food.food.photo {
                    Image(data: Data(base64Encoded: photo)!)?.resizable().aspectRatio(1.0, contentMode: .fill).clipShape(Circle()).frame(width: 50, height: 50)
                } else {Circle().fill(.gray).frame(width: 50, height: 50)
                    .shadow(radius: 15)}
                Circle().stroke(AngularGradient(colors: [.red, .yellow, .green, .blue, .purple, .red], center: .center), style: StrokeStyle(lineWidth: 3))
                    .frame(width: 50, height: 50)
            }
                
            VStack(alignment: .leading, spacing: 10){
                Text(food.food.name)
                    .foregroundColor(Color(.white))
                    .fontWeight(.bold)
                    .shadow(radius: 0.5)
                Text(food.food.barcode)
                    .fontWeight(.light)
                    .fontDesign(.rounded)
                    .shadow(radius: 0.5)
                    .foregroundColor(.black)
            }
            Spacer()
            Text("\(food.count)x\(food.food.quantity.formatted()) g").shadow(radius: 0.5).foregroundColor(.black)
        }
        .frame(maxWidth: .infinity, minHeight: 60)
        .padding(12)
        .background(LinearGradient(colors: [.orange, .purple, .cyan], startPoint: .topLeading, endPoint: .bottomTrailing))
        .cornerRadius(10)
    }
}

struct FoodItemView_Previews: PreviewProvider {
    static var previews: some View {
        FoodItemView(food: StorageFood(totalCount: 500, count: 5, food: Food(id: nil, name: "testFood", quantity: 100, barcode: "1234567", allergens: ["test1", "test2","test3"], ingredients: ["testa","testb","testc"], photo:  "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")))
    }
}
