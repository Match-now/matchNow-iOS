//
//  MatchRowView.swift
//  matchNow
//
//  Created by hyunMac on 4/9/25.
//

import SwiftUI

struct MatchRowView: View {
    let match: Match
    let onTap: () -> Void
    let onFavoriteTap: () -> Void
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Button(action: onTap) {
                VStack {
                    Text(match.noticeMessage)
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 80)
                        .padding(.top, 16)
                    
                    HStack {
                        Spacer()
                        
                        VStack {
                            imageForTeam(teamName: match.homeTeamName)
                                .resizable()
                                .frame(width: 30,height: 30)
                            VStack {
                                Text(match.homeTeamName)
                                Text("(\(match.homeTeamRank))")
                            }.font(.footnote)
                        }
                        
                        Spacer()
                        HStack {
                            Text(match.homeScore)
                                .font(.title2)
                                .padding(.horizontal,20)
                            
                            ZStack {
                                viewForStatus(status: match.status)
                                Text(match.statusMessage)
                                    .fontWeight(.bold)
                                    .font(.footnote)
                                    .foregroundStyle(.white)
                            }
                            
                            Text(match.awayScore)
                                .font(.title2)
                                .padding(.horizontal,20)
                        }
                        
                        Spacer()
                        
                        VStack {
                            imageForTeam(teamName: match.awayTeamName)
                                .resizable()
                                .frame(width: 30,height: 30)
                            VStack {
                                Text(match.awayTeamName)
                                Text("(\(match.awayTeamRank))")
                            }.font(.footnote)
                        }
                        
                        Spacer()
                    }
                    
                    HStack {
                        imageForTriangle(odds: match.odds, target: "home")
                        Text(match.odds[0])
                        
                        Text("|").foregroundStyle(.gray)
                        Text(match.odds[1])
                        Text("|").foregroundStyle(.gray)
                        
                        imageForTriangle(odds: match.odds, target: "away")
                        Text(match.odds[2])
                    }
                    .font(.footnote)
                    .padding(4)
                    
                    Rectangle()
                        .frame(height: 2)
                        .foregroundStyle(.gray.opacity(0.12))
                }
            }
            .buttonStyle(.plain)
            
            Button(action: onFavoriteTap) {
                Image(systemName: "star.fill")
                    .foregroundStyle(.yellow)
                    .padding(.trailing, 16)
                    .padding(.top, 8)
                
            }
            .buttonStyle(.plain)
        }
    }
    
    private func imageForTeam(teamName: String) -> Image {
        switch teamName {
        case "맨유":
            return Image(systemName: "person.fill")
        case "맨시티":
            return Image(systemName: "personalhotspot.circle.fill")
        default:
            return Image(systemName: "person.fill.turn.right")
        }
    }
    
    private func viewForStatus(status: String) -> some View {
        let color: Color
        var conerSize = CGSize(width: 2, height: 2)
        
        switch status {
        case "expected":
            color = .blue
        case "progress":
            color = .red
            conerSize = CGSize(width: 10, height: 10)
        case "end":
            color = .gray
        default:
            color = .clear
        }
        
        return RoundedRectangle(cornerSize: conerSize)
            .fill(color)
            .frame(width: 56,height: 20)
    }
    
    private func imageForTriangle(odds: [String], target: String) -> AnyView {
        guard odds.count >= 3, let homeTeamOdd = Double(odds[0]), let awayTeamOdd = Double(odds[2]) else {
            return AnyView(EmptyView())
        }
        
        let color: Color
        let imageName: String
        
        if target == "home" {
            if homeTeamOdd > awayTeamOdd {
                color = .red
                imageName = "arrowtriangle.up.fill"
            } else {
                color = .blue
                imageName = "arrowtriangle.down.fill"
            }
        } else {
            if homeTeamOdd < awayTeamOdd {
                color = .red
                imageName = "arrowtriangle.up.fill"
            } else {
                color = .blue
                imageName = "arrowtriangle.down.fill"
            }
        }
        
        return AnyView(Image(systemName: imageName)
            .resizable()
            .frame(width: 9,height: 8)
            .foregroundStyle(color))
    }
}



#Preview {
    MatchRowView(match: Match(id: 1, league: "EPL", noticeMessage: "맨체스터의 주인은 맨시티다..?\n 이거는 이제 반박 못 할 것 같은데요 맨유팬\n 여러분 인정 하시나요??", status: "progress", statusMessage: "전반 12", homeTeamName: "맨유", homeTeamRank: "14위", awayTeamName: "맨시티", awayTeamRank: "5위", homeScore: "1", awayScore: "2", odds: ["5.06","4.20","1.55"]), onTap: {}, onFavoriteTap: {})
}
