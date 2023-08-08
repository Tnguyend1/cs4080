//
//  SwiftUIView.swift
//  WordGame
//
//  Created by Nguyen Thoa on 8/7/23.
//

import SwiftUI

struct WordGameView: View {
    @State private var selectedLevel = "Beginner"
    @Binding var playerName: String
    
    let wordGame = WordGame()
    var wordPairs: [WordList] { wordGame.getWordLists(for: selectedLevel) }
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Word Game")
                    .font(.largeTitle)
                    .padding()
                
                Text("Player: \(playerName)") // Use the binding here
                    .font(.headline)
                    .padding()
                
                Picker("Select Level", selection: $selectedLevel) {
                    Text("Beginner").tag("Beginner")
                    Text("Intermediate").tag("Intermediate")
                    Text("Expert").tag("Expert")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                ForEach(Array(wordGame.levels.keys), id: \.self) { level in
                    NavigationLink(destination: LevelView(wordPairs: wordGame.getWordLists(for: level), levelTitle: "\(level) Level", playerName: $playerName)) {
                        Text(level)
                    }
                }
            }
        }
    }
}

struct PlayerNameView: View {
    @Binding var playerName: String
    
    var body: some View {
        VStack {
            Text("Welcome to Word Game")
                .font(.largeTitle)
                .padding()
            
            Text("Enter Your Name")
                .font(.title)
                .padding()
            
            TextField("Your Name", text: $playerName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            NavigationLink("Start Game", destination: WordGameView(playerName: $playerName))
                .padding()
        }
        .padding()
    }
}
@main
struct WordGameApp: App {
    @State private var playerName = ""

    var body: some Scene {
        WindowGroup {
            NavigationView {
                TabView {
                    PlayerNameView(playerName: $playerName)
                        .tabItem {
                            Label("Player Name", systemImage: "person.fill")
                        }
                }
                .background(Color.brown) //  background color
            }
            .background(Color.brown) //  background color
        }
    }
}

