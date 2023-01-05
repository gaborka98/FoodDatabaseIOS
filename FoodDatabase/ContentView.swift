//
//  ContentView.swift
//  FoodDatabase
//
//  Created by Gábor Horváth on 2022. 12. 25..
//

import SwiftUI
import Foundation
import CodeScanner
import AlertToast

struct ContentView: View {
    @State private var isPresentingScanner = true
    @State private var isGalleryPresented = false
    @State private var showToast = false
    @State private var isTorchOn = false
    @State private var isAdd = true
    @State private var errorMsg: String = ""
    @State private var showErrorToast = false
    @State private var isShowScannedFoodView = false
    
    @State var food : Food?
    
    var body: some View {
        StorageView(isPresentingScanner: $isPresentingScanner)
        .sheet(isPresented: $isPresentingScanner) {
            ZStack(alignment: .bottom) {
                CodeScannerView(codeTypes: [.ean13, .ean8, .pdf417], scanMode: .continuous,showViewfinder: false, simulatedData: "5449000214911", isTorchOn: isTorchOn, isGalleryPresented: $isGalleryPresented) { response in
                    switch response {
                    case .success(let result):
                        let scannedCode = result.string
                        
                        ApiCaller.shared.getFood(barcode: scannedCode) { result in
                            switch result {
                            case .success(let data):
                                food = data
                                isPresentingScanner = false
                                ScannedFoodView(food: food, isPresentingScanner: $isPresentingScanner)
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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
