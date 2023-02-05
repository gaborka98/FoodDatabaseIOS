//
//  StorageView.swift
//  FoodDatabase
//
//  Created by Gábor Horváth on 2023. 01. 01..
//

import Foundation
import SwiftUI
import AlertToast
import CodeScanner

struct StorageView: View {
    @State var foods : [StorageFood] = []
    @State var errorMsg: String = ""
    @State var ShowErrorToast: Bool = false
    @State private var offset = CGSize.zero
    
    @State private var isPresentingScanner = true
    @State private var isGalleryPresented = false
    @State private var showToast = false
    @State private var isTorchOn = false
    @State private var isAdd = true
    @State private var showErrorToast = false
    @State private var isShowScannedFoodView = false
    
    @State var food : Food?
    
    var body: some View {
        NavigationStack {
            VStack{
//                NavigationLink(destination: ScannedFoodView(food: food, isPresentingScanner: $isPresentingScanner), isActive: $isShowScannedFoodView){
//                    EmptyView()
//                }
                List(foods, id: \.self.food.id) { food in
                    FoodItemView(food: food)
                        .swipeActions(edge: .trailing) {
                            Button(role:.destructive) {
                                delete(food: food)
                            } label: {
                                Image(systemName: "trash")
                                Text("Delete")
                            }
                        }
                        .swipeActions(edge: .leading) {
                            Button(role: .destructive) {
                                deleteAll(food: food)
                            } label: {
                                Label("Delete all", systemImage: "trash")
                            }
                        }
                        .listRowInsets(.init(top: 0, leading: 0, bottom: 10, trailing: 0))
                }
                .frame(maxWidth: .infinity)
                .edgesIgnoringSafeArea(.horizontal)
                .listStyle(GroupedListStyle())
            }
            .navigationDestination(isPresented: $isShowScannedFoodView) {
                ScannedFoodView(food: food, isPresentingScanner: $isPresentingScanner)
            }
            .navigationTitle("Storage")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing){
                    Button {
                        isPresentingScanner = true
                    } label: {
                        Image(systemName: "barcode.viewfinder")
                    }
                    .foregroundColor(Color(UIColor.label))
                }
            }
            .navigationBarBackButtonHidden(true)
        }
        .sheet(isPresented: $isPresentingScanner) {
            ZStack(alignment: .bottom) {
                CodeScannerView(codeTypes: [.ean13, .ean8, .pdf417], scanMode: .once,showViewfinder: false, simulatedData: "5449000214911", isTorchOn: isTorchOn, isGalleryPresented: $isGalleryPresented) { response in
                    switch response {
                    case .success(let result):
                        let scannedCode = result.string
                        
                        ApiCaller.shared.getFood(barcode: scannedCode) { result in
                            switch result {
                            case .success(let data):
                                self.food = data
                                isPresentingScanner = false
                                isShowScannedFoodView = true
                            case .failure(let error):
                                errorMsg = error.localizedDescription
                                print(errorMsg)
                                showErrorToast = true
                            }
                        }
                    case .failure(let error):
                        errorMsg = error.localizedDescription
                        showErrorToast = true
                    }
                }
                HStack(alignment: .bottom){
                    Button{
                        isGalleryPresented = true
                    } label: {
                        Image(systemName: "photo.stack")
                    }
                    .frame(width: 20)
                    .padding()
                    .background(Color.black.opacity(0.6))
                    .foregroundColor(Color.white)
                    .font(.title3)
                    .cornerRadius(10)
                    
                    Button {
                        isTorchOn.toggle()
                    } label: {
                        if isTorchOn {
                            Image(systemName: "flashlight.on.fill")
                        } else {
                            Image(systemName: "flashlight.off.fill")
                        }
                    }
                    .frame(width: 20)
                    .padding()
                    .background(Color.black.opacity(0.6))
                    .foregroundColor(Color.white)
                    .font(.title3)
                    .cornerRadius(10)
                }
            }
            .toast(isPresenting: $showErrorToast, duration: 4) {
                AlertToast(type:.error(Color.red), title: "Error", subTitle: errorMsg)
            } completion: {
                showErrorToast = false
            }
        }
        .toast(isPresenting: $ShowErrorToast, duration: 4, tapToDismiss: true, alert: {
            AlertToast(type:.error(Color.red), title: "Error", subTitle: errorMsg)
        }, completion: { self.ShowErrorToast = false})
        .onAppear(perform: fetchData)
        .onChange(of: isShowScannedFoodView) { newValue in
            if !newValue {
                fetchData()
            }
        }
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
    
    func delete(food: StorageFood) -> Void {
        ApiCaller.shared.deleteFood(food: food.food) { result in
            if result { foods.removeAll(where: {$0.food.id == food.food.id}) }
        }
    }
    
    func deleteAll(food: StorageFood) -> Void {
        ApiCaller.shared.deleteStorageFood(food: food.food) { res in
            if res { foods.removeAll(where: {$0.food.barcode == food.food.barcode}) }
        }
    }
}

struct StorageView_preview: PreviewProvider {
    static var previews: some View {
        StorageView(foods: [
            StorageFood(totalCount: 500, count: 5, food: Food(id: "asd123", name: "TestFood", quantity: 500, barcode: "1234567", allergens: [], ingredients: [], photo: nil))
        ,
            StorageFood(totalCount: 1000, count: 10, food: Food(id: "dsa321", name: "TestPasta", quantity: 1000, barcode: "7654321", allergens: [], ingredients: [], photo: nil))
        ])
    }
}
