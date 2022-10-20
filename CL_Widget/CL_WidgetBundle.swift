//
//  CL_WidgetBundle.swift
//  CL_Widget
//
//  Created by Andreas Loizides on 20/10/2022.
//

import WidgetKit
import SwiftUI

@main
struct CL_WidgetBundle: WidgetBundle {
    var body: some Widget {
        CL_Widget()
        CL_WidgetLiveActivity()
    }
}
