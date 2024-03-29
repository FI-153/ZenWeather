//
//  BackgroundView.swift
//  Weather displayer
//
//  Created by Federico Imberti on 02/02/22.
//

import SwiftUI

struct BackgroundView: View {
	
	var body: some View {
		LinearGradient(	colors: [.pink.opacity(0.5), .blue.opacity(0.6)],
						startPoint: .topLeading,
						endPoint: .bottomTrailing
		)
        .ignoresSafeArea()
	}
}

struct BackgroundView_previews: PreviewProvider {
    static var previews: some View {
        BackgroundView()
    }
}
