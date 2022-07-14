//
//  Home.swift
//  UI-612
//
//  Created by nyannyan0328 on 2022/07/14.
//

import SwiftUI

struct Home: View {
    @State var chat : [Message] = [
    
    
        Message(message: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s"),
        Message(message: "Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old.",isReply: true)
    
    ]
    
    @State var heightlightChat : Message?
    
    @State var showHeight : Bool = false
    var body: some View {
        NavigationView {
            
            ScrollView(.vertical){
                
                VStack(spacing:20){
                    
                    
                    ForEach(chat){chat in
                        
                        VStack(alignment:chat.isReply ? .leading : .trailing){
                            
                            if chat.isEmojiAdded{
                                
                                
                                AnimatedEmoji(emoji: chat.emojiValue,color: chat.isReply ? .blue : Color("Gray"))
                                    .offset(x:chat.isReply ? -15 : 15)
                                    .padding(.bottom,-25)
                                    .zIndex(1)
                                    .opacity(showHeight ? 0 : 1)
                                    
                            }
                            
                            
                            ChatView(msg: chat)
                                .zIndex(0)
                                .anchorPreference(key:BoundsPrefrence.self ,value: .bounds, transform: { anchor in
                                    
                                    return [chat.id : anchor]
                                    
                                })
                            
                            
                                .padding(chat.isReply ? .leading : .trailing,60)
                                .onLongPressGesture {
                                    
                                    
                                    withAnimation {
                                        
                                        showHeight = true
                                        heightlightChat = chat
                                    }
                                    
                                }
                            
                            
                        }
                        .padding(chat.isReply ? .leading : .trailing,60)
                        
                       
                        
                        
                    }
                    
                   
                    
                    
                    
                    
                }
                .padding()
                .padding(.bottom,100)
                .navigationTitle("Transitions")
                .navigationBarTitleDisplayMode(.inline)
             
            }
            .overlay {
                
                if showHeight{
                    
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .environment(\.colorScheme, .dark)
                        .ignoresSafeArea()
                        .onTapGesture {
                            
                            showHeight = false
                            heightlightChat = nil
                        }
                    
                    
                }
            }
            .overlayPreferenceValue(BoundsPrefrence.self) { values in
             
                
                if let heightlightChat,let preference = values.first(where: { item in
                    
                    
                    item.key == heightlightChat.id
                }){
                    
                    
                    GeometryReader{proxy in
                        
                        let rect = proxy[preference.value]
                        
                        
                        ChatView(msg: heightlightChat,showLike: true)
                            .id(heightlightChat.id)
                            .frame(width: rect.width,height: rect.height)
                            .offset(x:rect.minX,y:rect.minY)
                    }
                    .transition(.asymmetric(insertion: .identity, removal: .offset(x:1)))
                
                  
                    
                }
                 
                
            }
        
        }
    }
    @ViewBuilder
    func ChatView(msg : Message,showLike : Bool = false)->some View{
        
        ZStack(alignment: .bottomLeading) {
            
            Text(msg.message)
                .foregroundColor(msg.isReply ? .black : .white)
                .padding(15)
                .background{
                 
                    
                    msg.isReply ? Color("Gray") : Color.blue
                }
                .clipShape(RoundedRectangle(cornerRadius: 10,style: .continuous))
            
            if showLike{
                
                
                EmojiView(hideView: $showHeight, chat: msg) { emoji in
                    
                    
                    withAnimation(.easeInOut){
                        
                        showHeight = false
                        heightlightChat = nil
                        
                    }
                    
                    if let index = chat.firstIndex(where: { chat in
                        
                        chat.id == msg.id
                    }){
                        
                        withAnimation(.easeInOut.delay(0.3)){
                            
                            chat[index].isEmojiAdded = true
                            chat[index].emojiValue = emoji
                            
                        }
                        
                    }
                    
                    
                }
                .offset(y:40)
                
            
            }
            
            
        }
        
        
    }
}

struct EmojiView : View{
    @Binding var hideView : Bool
 
    var emojis : [String] = ["😊","🤔","😉"]
    var chat : Message
    var onTap : (String) -> ()
    
    @State var animatedEmoji : [Bool] = Array(repeating: false, count: 3)
    
    @State var animatedView : Bool = false
    var body: some View{
        
        HStack(spacing:25){
            
            
            ForEach(emojis.indices,id:\.self){index in
                
                
                Text(emojis[index])
                    .font(.system(size: 13))
                    .scaleEffect(animatedEmoji[index] ? 1.5 : 0.01)
                    .onAppear{
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                            
                            
                            withAnimation(.easeInOut.delay(Double(index) * 0.1)){
                                
                                
                                animatedEmoji[index] = true
                            }
                        }
                    }
                    .onTapGesture {
                        
                        onTap(emojis[index])
                    }
                
            }
            
        }
        .padding(.vertical)
        .padding(.horizontal,23)
        .background{
         
            
            Capsule()
                .fill(.white)
                .mask {
                    Capsule()
                        .scaleEffect(animatedView ? 1 : 0,anchor: .leading)
                    
                }
        }
        .onAppear{
            
            
            withAnimation(.easeInOut(duration: 0.2)){
                
                animatedView = true
            }
        }
        .onChange(of: hideView) { newValue in
            
            if !newValue{
                
                withAnimation(.easeInOut(duration: 0.2).delay(0.3)){
                    
                    
                    animatedView = false
                }
                
                for index in emojis.indices{
                    
                    withAnimation(.easeInOut){
                        
                        animatedEmoji[index] = false
                    }
                }
                
            }
        }
        
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct AnimatedEmoji : View{
    
    var emoji : String
    var color : Color = .blue
    
    @State var animationValue : [Bool] = Array(repeating: false, count: 6)
    
    var body: some View{
        
        ZStack{
            
            Text(emoji)
                .font(.system(size: 25))
                .padding(5)
                .background{
                 
                    Circle()
                        .fill(color)
                }
                .scaleEffect(animationValue[0] ? 1 : 0)
                .overlay {
                    
                    Circle()
                        .stroke(color,lineWidth: animationValue[0] ? 0 : 30)
                        .clipShape(Circle())
                        .scaleEffect(animationValue[0] ? 2 : 0.01)
                }
                .overlay {
                    
                    ZStack{
                        
                        ForEach(1...20,id:\.self){index in
                            Circle()
                                .fill(color)
                                .frame(width: .random(in: 3...5),height: .random(in: 3...5))
                                .offset(x:.random(in: -5...5),y:.random(in: -5...5))
                                .offset(x:animationValue[3] ? 45 : 10)
                                .rotationEffect(.init(degrees: Double(index) * 18.0))
                                .scaleEffect(animationValue[2] ? 1 : 0.01)
                                .opacity(animationValue[4] ? 0 : 1)
                            
                        }
                    }
                }
            
            
        }
        .onAppear{
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                
                withAnimation(.easeInOut(duration: 0.25)){
                    
                    animationValue[0] = true
                }
                
                
                withAnimation(.easeInOut(duration: 0.25)){
                    
                    animationValue[1] = true
                }
                
                
                withAnimation(.easeInOut(duration: 0.25)){
                    
                    animationValue[2] = true
                }
                
                
                withAnimation(.easeInOut(duration: 0.35)){
                    
                    animationValue[3] = true
                }
                
                
                withAnimation(.easeInOut(duration: 0.6)){
                    
                    animationValue[4] = true
                }
            }
        }
    }
}
