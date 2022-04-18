//
//  CourseView.swift
//  SetApp
//
//  Created by Emilio Roman on 18/4/22.
//

import SwiftUI

struct CourseView: View {
    
    var namespace: Namespace.ID
    @Binding var show: Bool
    
    var body: some View {
        
        ZStack {
            
            ScrollView {
                cover
            }
            .background(Color(red: 0.113, green: 0.031, blue: 0.16))
            .ignoresSafeArea()
            
            Button {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    show.toggle()
                }
            } label: {
                Image(systemName: "arrow.left")
                    .font(.body.weight(.bold))
                    .foregroundColor(.secondary)
                    .padding(10)
                    .background(.ultraThinMaterial, in: Circle())
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding(20)
            .padding(.top, 80)
            .ignoresSafeArea()
        }
    }
    
    var cover: some View {
        
        VStack {
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .frame(height: 500)
        .foregroundStyle(.black)
        /*
        .background(
            Image("publi")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .matchedGeometryEffect(id: "image", in: namespace)
        )
         */
        .background(
            Image("publi")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .matchedGeometryEffect(id: "background", in: namespace)
        )
        .mask(
            
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .matchedGeometryEffect(id: "mask", in: namespace)
        )
        .overlay(
            
            VStack(alignment: .leading, spacing: 12) {
                
                Text("SwiftUI")
                    .font(.largeTitle.weight(.bold))
                    .matchedGeometryEffect(id: "title", in: namespace)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("LG".uppercased())
                    .font(.footnote.weight(.semibold))
                    .matchedGeometryEffect(id: "subtitle", in: namespace)
                Text("UltraGear")
                    .font(.footnote)
                    .matchedGeometryEffect(id: "text", in: namespace)
                Divider()
                HStack {
                    
                    Image("publi")
                        .resizable()
                        .frame(width: 26.0, height: 26.0)
                        .cornerRadius(10)
                        .padding(8)
                        .background(.ultraThinMaterial, in:
                                        RoundedRectangle(cornerRadius: 18, style: .continuous))
                    
                    Text("By Emilio Roman")
                        .font(.footnote)
                }
            }
                .padding(20)
                .background(
                    
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
                        .matchedGeometryEffect(id: "blur", in: namespace)
                )
                .offset(y: 250)
                .padding(20)
        )
    }
}

struct CourseView_Previews: PreviewProvider {
    
    @Namespace static var namespace
    
    static var previews: some View {
        CourseView(namespace: namespace, show: .constant(true))
    }
}
