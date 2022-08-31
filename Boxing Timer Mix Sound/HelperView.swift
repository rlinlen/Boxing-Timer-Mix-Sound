//
//  HelperView.swift
//  Boxing Timer Mix Sound
//
//  Created by Len Lin on 2022/8/25.
//

import SwiftUI

struct UseCase: Identifiable {
    var title: String
    var subTitle: String
    var content: String
    var icon: String
    var id: String { title }
}

struct CardView: View {
    @State var useCase: UseCase
    
    var body: some View{
        VStack{
            HStack{
                Image(systemName: useCase.icon)
                    .foregroundColor(.white)
                Text(useCase.title)
                    .font(.title)
                    .foregroundColor(.white)
            }
            Text(useCase.subTitle)
                .font(.title2)
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
            Divider()
            Text(useCase.content)
                .fixedSize(horizontal: false, vertical: true)
                .padding(10)
                .foregroundColor(.white)
            
        }
        .background(
                Rectangle()
                    .fill(Color.black)
                    .cornerRadius(12)
                    .shadow(
                        color: Color.gray.opacity(0.7),
                        radius: 8,
                        x: 0,
                        y: 0
                    )
                )
//        .background(.gray)
//        .overlay(
//                            RoundedRectangle(cornerRadius: 10, style: .circular).stroke(Color(uiColor: .tertiaryLabel), lineWidth: 1)
//                        )
        
    }
}

struct HelperView: View {
    
    @Binding var isDisplay: Bool
    
    var body: some View {
        HStack{
            Spacer()
            Button(action: {
                isDisplay.toggle()
            }){
                Text("Done")
                    .bold()
                    .padding(20)
                    
                
            }
        }
        
        
        List{
            ForEach(K.Helper.useCase){ useCase in
                CardView(useCase: useCase)
                    .padding(10)
            }
        }
        
        
    }
}
