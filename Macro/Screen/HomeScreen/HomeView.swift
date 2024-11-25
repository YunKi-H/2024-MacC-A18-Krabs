//
//  HomeView.swift
//  Macro
//
//  Created by Yunki on 11/12/24.
//

import SwiftUI

struct HomeView: View {
    
    @Environment(Router.self) var router
    
    @State private var appState: AppState = .shared
    
    @State private var viewModel: HomeViewModel = DIContainer.shared.homeViewModel
    @State private var isSelectedJangdan: Bool = false
    @State private var buttonPressedStates: [Jangdan: Bool] = [:]
    
    let columns: [GridItem] = [GridItem(.flexible()), GridItem(.flexible())]
    var body: some View {
        if self.appState.didLaunchedBefore {
            NavigationStack(path: Binding(
                get: { router.path },set: { router.path = $0 }
            ))
            {
                VStack {
                    HStack {
                        Menu {
                            Button("북") {
                                self.appState.setInstrument(.북)
                                self.viewModel.effect(action: .changeSoundType)
                            }
                            Button("장구") {
                                self.appState.setInstrument(.장구)
                                self.viewModel.effect(action: .changeSoundType)
                            }
                        } label: {
                            HStack(spacing: 12) {
                                Text("\(self.appState.selectedInstrument.rawValue)")
                                    .font(.Callout_R)
                                Image(systemName: "chevron.down")
                            }
                            .padding(.horizontal, 14)
                            .frame(width: 87, height: 42)
                            .background {
                                RoundedRectangle(cornerRadius: 35)
                                    .stroke(lineWidth: 4)
                                    .clipShape(RoundedRectangle(cornerRadius: 35))
                            }
                            .foregroundStyle(.buttonReverse)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "tray.full.fill")
                            .aspectRatio(contentMode: .fit)
                            .foregroundStyle(.textSecondary)
                            .onTapGesture {
                                router.push(.customJangdanList)
                            }
                            .frame(width: 44, height: 44)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 17)
                    
                    ScrollView() {
                        // MARK: - 기본 장단 목록 (2칸씩 수직 그리드)
                        VStack {
                            LazyVGrid(columns: [GridItem(.flexible(), spacing: 7.5), GridItem(.flexible())], spacing: 7.5) {
                                ForEach(self.appState.selectedInstrument.defaultJangdans, id: \.self) { jangdan in
                                    
                                    NavigationLink(destination: MetronomeView(viewModel: DIContainer.shared.metronomeViewModel, jangdanName: jangdan.rawValue)) {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 16)
                                                .fill(buttonPressedStates[jangdan] == true ? .buttonActive : .backgroundCard) // 배경색 설정
                                                .shadow(radius: 5) // 그림자 효과
                                                .overlay {
                                                    jangdan.jangdanLogoImage
                                                        .resizable()
                                                        .foregroundStyle(buttonPressedStates[jangdan] == true ? .sobakSegmentSobak : .backgroundNavigationBar)
                                                        .frame(width: 225, height: 225)
                                                        .offset(y: -100)
                                                }
                                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                            
                                            Text(jangdan.name)
                                                .font(buttonPressedStates[jangdan] == true ? .Title1_B : .Title1_R)
                                                .foregroundStyle(buttonPressedStates[jangdan] == true ? .textButtonEmphasis : .textDefault)
                                                .bold(((buttonPressedStates[jangdan] == true ? 1 : 0) != 0))
                                                .offset(y: -2.5)
                                            
                                            Text(jangdan.bakInformation)
                                                .font(.Body_R)
                                                .foregroundStyle(buttonPressedStates[jangdan] == true ? .textButtonEmphasis : .textDefault)
                                                .bold(((buttonPressedStates[jangdan] == true ? 1 : 0) != 0))
                                                .offset(y: 30)
                                        }
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        .aspectRatio(1, contentMode: .fill)
                                    }
                                    .contentShape(Rectangle())
                                    .buttonStyle(StaticButtonStyle())
                                    .simultaneousGesture(
                                        DragGesture(minimumDistance: 0)
                                            .onChanged { _ in
                                                buttonPressedStates[jangdan] = true
                                            } // 특정 id의 상태를 true로 변경
                                            .onEnded { _ in
                                                buttonPressedStates[jangdan] = false
                                            } // 특정 id의 상태를 false로 변경
                                    )
                                }
                            }
                        }
                        .padding(.top, 34)
                    }
                    .scrollIndicators(.hidden)
                    .padding(.horizontal, 16)
                    .navigationDestination(for: Route.self) { path in
                        router.view(for: path)
                    }
                }
            }
        } else {
            InstrumentsSelectView()
        }
    }
}

#Preview {
    HomeView()
        .environment(Router().self)
}

struct StaticButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 1.0 : 1.0) // 눌림 상태에도 변경 없음
    }
}
