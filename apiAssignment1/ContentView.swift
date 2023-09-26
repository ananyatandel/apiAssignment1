//
//  ContentView.swift
//  apiAssignment1
//
//  Created by Ananya Tandel on 9/25/23.
//

import SwiftUI

struct Joke: Codable, Identifiable {
  var id: Int
  var category: String
  var type: String
  var joke: String
}

struct JokesView: View {
  @State var jokes = [Joke]()

  func getAllJokes() async {
    do {
      let url = URL(string: "https://v2.jokeapi.dev/joke/Any?amount=20")!
      let (data, _) = try await URLSession.shared.data(from: url)

      let decodedData = try JSONDecoder().decode([Joke].self, from: data)
      jokes = decodedData
    } catch {
      print("Error: \(error.localizedDescription)")
    }
  }

  var body: some View {
    NavigationView {
      List(jokes) { joke in
        NavigationLink(destination: JokeDetailView(joke: joke)) {
          VStack(alignment: .leading) {
            Text(joke.category)
            Text(joke.joke)
          }
        }
      }
      .onAppear {
        Task {
          await getAllJokes()
        }
      }
      .navigationTitle("Jokes")
    }
  }
}

struct JokeDetailView: View {
  let joke: Joke

  var body: some View {
    VStack {
      Text(joke.category)
        .font(.headline)
      Text(joke.joke)
        .padding()
    }
    .navigationTitle("Joke Detail View")
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    JokesView()
  }
}

