//import SwiftUI
//
//public struct SwiftUIImageViewer: View {
//
//    let image: Image
//
//    @State private var scale: CGFloat = 1
//    @State private var lastScale: CGFloat = 1
//    private var maxScale: CGFloat = 10
//
//    @State private var offset: CGPoint = .zero
//    @State private var lastTranslation: CGSize = .zero
//
//    public init(image: Image) {
//        self.image = image
//    }
//
//    public var body: some View {
//        GeometryReader { proxy in
//            ZStack {
//                image
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .scaleEffect(scale)
//                    .offset(x: offset.x, y: offset.y)
//                    .gesture(makeDragGesture(size: proxy.size))
//                    .gesture(makeMagnificationGesture(size: proxy.size))
//            }
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//            .edgesIgnoringSafeArea(.all)
//        }
//    }
//
//    private func makeMagnificationGesture(size: CGSize) -> some Gesture {
//        MagnificationGesture()
//            .onChanged { value in
//                let delta = value / lastScale
//                lastScale = value
//
//                // To minimize jittering
//                if abs(1 - delta) > 0.001 {
//                    scale *= delta
//                }
//            }
//            .onEnded { _ in
//                lastScale = 1
//                if scale < 1 {
//                    withAnimation {
//                        scale = 1
//                    }
//                }
//                if scale > maxScale {
//                    withAnimation {
//                        scale = maxScale
//                    }
//                }
//                adjustMaxOffset(size: size)
//            }
//    }
//
//    private func makeDragGesture(size: CGSize) -> some Gesture {
//        DragGesture()
//            .onChanged { value in
//                let diff = CGPoint(
//                    x: value.translation.width - lastTranslation.width,
//                    y: value.translation.height - lastTranslation.height
//                )
//                offset = .init(x: offset.x + diff.x, y: offset.y + diff.y)
//                lastTranslation = value.translation
//            }
//            .onEnded { _ in
//                adjustMaxOffset(size: size)
//            }
//    }
//
//    private func adjustMaxOffset(size: CGSize) {
//        let maxOffsetX = (size.width * (scale - 1)) / 2
//        let maxOffsetY = (size.height * (scale - 1)) / 2
//
//        var newOffsetX = offset.x
//        var newOffsetY = offset.y
//
//        if abs(newOffsetX) > maxOffsetX {
//            newOffsetX = maxOffsetX * (abs(newOffsetX) / newOffsetX)
//        }
//        if abs(newOffsetY) > maxOffsetY {
//            newOffsetY = maxOffsetY * (abs(newOffsetY) / newOffsetY)
//        }
//
//        let newOffset = CGPoint(x: newOffsetX, y: newOffsetY)
//        if newOffset != offset {
//            withAnimation {
//                offset = newOffset
//            }
//        }
//        self.lastTranslation = .zero
//    }
//}



import SwiftUI
import PDFKit

struct SwiftUIImageViewer: UIViewRepresentable {
    let image: UIImage

    func makeUIView(context: Context) -> PDFView {
        let view = PDFView()
        view.document = PDFDocument()
        guard let page = PDFPage(image: image) else { return view }
        view.document?.insert(page, at: 0)
        view.maxScaleFactor = 10.0
        view.minScaleFactor = 1.0
        view.autoScales = true
        return view
    }

    func updateUIView(_ uiView: PDFView, context: Context) {
        // empty
    }
}


struct SwiftUIImageViewer_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIImageViewer(image: UIImage(named: "Logo") ?? UIImage())
    }
}
