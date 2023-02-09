//
//  Copyright (c) 2023 Ashish Bhandari
//

import AuthAppBusinessDomain
import SwiftUI

struct WelcomeView: View {
    @ObservedObject var viewModel: WelcomeViewModel

    var body: some View {
        NavigationView {
            List(viewModel.items) { item in
                ListItemView(item: item)
            }
            .navigationTitle(AppConstants.welcomeBackText)
            .listStyle(.grouped)
        }
        .onAppear {
            viewModel.getFeedData?()
        }
    }
}

private struct ListItemView: View {
    let item: ListItem
    
    var body: some View {
        HStack {
            Image(uiImage: UIImage(size: .init(width: 44, height: 44)))
                .resizable()
                .clipShape(Capsule())
                .padding()
            VStack {
                HStack {
                    Text(item.title)
                        .bold()
                        .font(.headline)
                        .lineLimit(1)
                    Spacer()
                }
                .padding(.vertical)
                HStack {
                    Text(item.description)
                        .font(.body)
                        .lineLimit(nil)
                    Spacer()
                }
                .padding(.bottom)
            }
            Spacer()
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView(viewModel: WelcomeViewModel())
    }
}

private extension UIImage {
    convenience init(color: UIColor = .init(red: .random(in: 0...1),
                                            green: .random(in: 0...1),
                                            blue: .random(in: 0...1),
                                            alpha: 1.0),
                     size: CGSize = .init(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.init(cgImage: image.cgImage!)
    }
}
