//
//  ListenSobakToggleView.swift
//  Macro
//
//  Created by Lee Wonsun on 10/10/24.
//

import SwiftUI

struct ListenSobakToggleView: View {
    @Binding var isSobakOn: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            Image(.listenSobak)
                .aspectRatio(contentMode: .fit)
                .padding(.trailing, 10)
            
            Text("소박 듣기")
                .font(.Title3_R)
                .foregroundColor(.textSecondary)
            
            Spacer()
            
            Toggle("", isOn: $isSobakOn)
                .labelsHidden()
                .toggleStyle(SwitchToggleStyle(tint: .buttonToggleOn))
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.backgroundCard)
        )
        .padding(.horizontal, 16)
    }
}


#Preview {
    @Previewable @State var isSobakOn: Bool = false
    ListenSobakToggleView(isSobakOn: $isSobakOn)
}
