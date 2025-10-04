import SwiftUI

public struct ContentView: View {
    public init() {}

    public var body: some View {
        Text("Hello, World!")
            .padding()
            .font(.pretend(type: .extraBold, size: 20))
//            .font(.pretend(type: .medium, size: 20))
    }
}

#Preview {
    ContentView()
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
