//
//  wordpair.swift
//  WordGame
//
//  Created by Nguyen Thoa on 8/7/23.
//
import SwiftUI

struct WordList {
    let incorrectWord: String
    let correctWord: String
}

class WordGame {
    let levels: [String: [WordList]] = [
           "Beginner": [
               WordList(incorrectWord: "erwid", correctWord: "weird"),
               WordList(incorrectWord: "cerivee", correctWord: "receive"),
               WordList(incorrectWord: "nefidatyel", correctWord: "definitely"),
               WordList(incorrectWord: "occured", correctWord: "occurred"),
               WordList(incorrectWord: "pxeercanie", correctWord: "experience"),
               WordList(incorrectWord: "olelH", correctWord: "Hello"),
               WordList(incorrectWord: "yobGde", correctWord: "Goodbye"),
               WordList(incorrectWord: "elPase", correctWord: "Please"),
               WordList(incorrectWord: "Srryo", correctWord: "Sorry"),
               WordList(incorrectWord: "peHl", correctWord: "Help")
           ],
           "Intermediate": [
               WordList(incorrectWord: "mccoaodate", correctWord: "accommodate"),
               WordList(incorrectWord: "derepaset", correctWord: "separated"),
               WordList(incorrectWord: "yompcletl", correctWord: "completely"),
               WordList(incorrectWord: "nuneycescsar", correctWord: "unnecessary"),
               WordList(incorrectWord: "llnexeet", correctWord: "excellent"),
               WordList(incorrectWord: "cocansio", correctWord: "occasion"),
               WordList(incorrectWord: "lyserapete", correctWord: "separately"),
               WordList(incorrectWord: "shysicp", correctWord: "physics"),
               WordList(incorrectWord: "dadress", correctWord: "address"),
               WordList(incorrectWord: "mapertan", correctWord: "apartment")
           ],
           "Expert": [
               WordList(incorrectWord: "xeistcnee", correctWord: "existence"),
               WordList(incorrectWord: "ferperred", correctWord: "preferred"),
               WordList(incorrectWord: "tepelasery", correctWord: "separately"),
               WordList(incorrectWord: "sonccious", correctWord: "conscious"),
               WordList(incorrectWord: "griviplede", correctWord: "privilege"),
               WordList(incorrectWord: "mcacoodation", correctWord: "accommodation"),
               WordList(incorrectWord: "gexareate", correctWord: "exaggerate"),
               WordList(incorrectWord: "oamung", correctWord: "among"),
               WordList(incorrectWord: "bgengini", correctWord: "beginning"),
               WordList(incorrectWord: "dinepandent", correctWord: "independent")
           ]
       ]
    func getWordLists(for level: String) -> [WordList] {
        return levels[level] ?? []
    }
}

class TimerManager: ObservableObject {
    @Published var elapsedTime: TimeInterval = 0
    var timer: Timer? // Expose the timer
    
    init() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [unowned self] _ in
            self.elapsedTime += 1
        }
    }
    deinit {
        timer?.invalidate()
    }
}

struct LevelView: View {
    @State private var currentIndex = 0
    @State private var userAnswer = ""
    @State private var score = 0
    
    let wordPairs: [WordList]
    let levelTitle: String
    
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var playerName: String
    
    @ObservedObject private var timerManager = TimerManager() // Use the TimerManager
    
    // Time limit for each level
    var timeLimit: TimeInterval {
        switch levelTitle {
        case "Beginner Level":
            return 20
        case "Intermediate Level":
            return 15
        case "Expert Level":
            return 10
        default:
            return 20 // Default to 20 seconds
        }
    }
    
    var body: some View {
        if timerManager.elapsedTime >= timeLimit {
            // Game over screen
            VStack {
                Text("Game Over")
                    .font(.largeTitle)
                    .padding()
                
                Text("Time's up! You exceeded the time limit.")
                    .font(.headline)
                    .padding()
                
                Button("Quit") {
                    presentationMode.wrappedValue.dismiss()
                }
                .font(.headline)
                .padding()
            }
            .padding()
        } else {
            // Game view
            VStack {
                Text(levelTitle)
                    .font(.largeTitle)
                    .padding()
                
                Text("\(currentIndex + 1) / \(wordPairs.count)")
                
                Text(" \(wordPairs[currentIndex].incorrectWord)")
                    .font(.title)
                    .padding()
                
                TextField("Enter Correct Word", text: $userAnswer)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button("Check Answer") {
                    if userAnswer.lowercased() == wordPairs[currentIndex].correctWord.lowercased() {
                        currentIndex += 1
                        userAnswer = ""
                        score += 1
                        if currentIndex >= wordPairs.count {
                            currentIndex = 0
                        }
                        
                        // Reset the timer for the next word
                        timerManager.elapsedTime = 0
                        
                        showAlert = true
                        alertTitle = "Correct!"
                        alertMessage = "Great job! Your answer is correct."
                    } else {
                        showAlert = true
                        alertTitle = "Incorrect"
                        alertMessage = "Sorry, your answer is incorrect."
                    }
                }
                .padding()
                .alert(isPresented: $showAlert) {
                    Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
                
                Text("Score: \(score)")
                    .font(.headline)
                    .padding()
                
                Text("Time: \(formattedTime(timerManager.elapsedTime))")
                    .font(.headline)
                    .padding()
                
                Button("Quit") {
                    presentationMode.wrappedValue.dismiss()
                }
                .font(.headline)
                .padding()
            }
            .padding()
        }
    }
    
    // Helper function to format time
    func formattedTime(_ timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
