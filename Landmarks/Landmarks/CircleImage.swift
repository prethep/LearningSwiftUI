//
//  CircleImage.swift
//  Landmarks
//
//  Created by PP on 25.06.19.
//  Copyright © 2019 PP. All rights reserved.
//

import SwiftUI

struct CircleImage: View {
    var body: some View {
        Image("turtlerock")
            .clipShape(Circle())
            .overlay(
                Circle().stroke(Color.white, lineWidth: 4)
            )
            .shadow(radius: 10)
    }
}
