//
//  ProgressView.swift
//  ProgressView
//
//  Created by Shubham on 24/11/20.
//
//Borrowed from https://github.com/shubham14896/swiftUI_widget_progress_bar/blob/main/ProgressView/ProgressView.swift
//
import SwiftUI

struct CustomProgressView: View {
	var progress: CGFloat
	var bgColor = Color.black.opacity(0.2)
	var filledColor = Color.blue

	var body: some View {
		GeometryReader { geometry in
			let height = geometry.size.height
			let width = geometry.size.width
			ZStack(alignment: .leading) {
				Rectangle()
					.foregroundColor(bgColor)
					.frame(width: width,
						   height: height)
					.cornerRadius(height / 2.0)

				Rectangle()
					.foregroundColor(filledColor)
					.frame(width: width * self.progress,
						   height: height)
					.cornerRadius(height / 2.0)
			}
		}
	}
}

struct CustomProgressView_Previews: PreviewProvider {
	static var previews: some View {
		CustomProgressView(progress: 0.6)
	}
}
