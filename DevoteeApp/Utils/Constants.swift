//
//  Constants.swift
//  DevoteeApp
//
//  Created by Jash Dhinoja on 15/03/2023.
//

import SwiftUI

//MARK: Formatter
let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

//MARK: UI

var backgroundGradient: LinearGradient {
    return LinearGradient(gradient: Gradient(colors: [.pink,.blue]),
                          startPoint: .topLeading,
                          endPoint: .bottomTrailing)
}

//MARK: UX
