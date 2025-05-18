//
//  WidgetSeefood2LiveActivity.swift
//  WidgetSeefood2
//
//  Created by Satria Dafa Putra Wardhana on 16/05/25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct WidgetSeefood2Attributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct WidgetSeefood2LiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: WidgetSeefood2Attributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension WidgetSeefood2Attributes {
    fileprivate static var preview: WidgetSeefood2Attributes {
        WidgetSeefood2Attributes(name: "World")
    }
}

extension WidgetSeefood2Attributes.ContentState {
    fileprivate static var smiley: WidgetSeefood2Attributes.ContentState {
        WidgetSeefood2Attributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: WidgetSeefood2Attributes.ContentState {
         WidgetSeefood2Attributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: WidgetSeefood2Attributes.preview) {
   WidgetSeefood2LiveActivity()
} contentStates: {
    WidgetSeefood2Attributes.ContentState.smiley
    WidgetSeefood2Attributes.ContentState.starEyes
}
