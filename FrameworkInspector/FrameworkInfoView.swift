//
//  FrameworkInfoView.swift
//  FrameworkInspector
//
//  Created by Kamil Pyc on 07/05/2020.
//  Copyright © 2020 Kamil Pyc. All rights reserved.
//

import SwiftUI

struct FrameworkInfoView: View
{
    
    var frameworkDescription: FrameworkDescription

    var body: some View
    {
        HStack {
            Image("frameworkIcon").resizable()
            .frame(width: 60, height: 60, alignment: .leading)
            Spacer()
            VStack {
                Text(frameworkDescription.name).padding()
                frameworkType()
                List(frameworkDescription.architectures, id: \.self) { string in
                    Text(string) .frame(maxWidth: .infinity, alignment: .center)
                }
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity)

    }
    
    private func frameworkType() -> AnyView
      {          
        switch frameworkDescription.type
          {
          case .dynamic:
            return AnyView(Text("Dynamic").bold())
        case .staticLink:
            return AnyView(Text("Static").bold())
        case .unknown(let error):
              return AnyView(Text(error))
          }
      }
}
