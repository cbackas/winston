//
//  ListRowBakground.swift
//  winston
//
//  Created by Igor Marcossi on 06/12/23.
//

import SwiftUI

struct ListRowBackground: View, Equatable {
  static func == (lhs: ListRowBackground, rhs: ListRowBackground) -> Bool {
    lhs.theme == rhs.theme && lhs.active == rhs.active && lhs.pressed == rhs.pressed && lhs.shiny == rhs.shiny
  }
  let theme: WinstonTheme
  var active = false
  var pressed = false
  var shiny: Gradient? = nil
  @Environment(\.colorScheme) private var cs
  var body: some View {
    let isActive = active && IPAD
    Group {
      if shiny == nil {
        Rectangle().fill(theme.lists.foreground.blurry ? AnyShapeStyle(.bar) : AnyShapeStyle(isActive ? .blue : theme.lists.foreground.color.cs(cs).color()))
      } else {
        Rectangle().winstonShiny(shiny)
      }
    }
    .overlay(Rectangle().fill(isActive ? Color.accentColor : .primary.opacity(pressed || (!IPAD && active) ? 0.1 : 0)).animation(.default.speed(2), value: active))
  }
}