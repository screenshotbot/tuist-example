//
//  ContentView.swift
//  SimpleProject
//
//  Created by Arnold Noronha on 1/5/24.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.locale) private var locale

    var body: some View {
        ConversationListView(conversations: SampleData.conversations(strings))
            .environment(\.strings, strings)
    }

    private var strings: Strings {
        Strings.forLocale(locale)
    }
}

#Preview {
    ContentView()
}
