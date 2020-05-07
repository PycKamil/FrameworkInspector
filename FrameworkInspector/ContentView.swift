import SwiftUI

struct ContentView: View
{
    
    @State private var dropActive = false
    
    @ObservedObject private var manager = FrameworkManager()

    var body: some View
    {
        contentView()
    }
    
    private func contentView() -> AnyView
    {
        let defaultText = "Drag and drop a .framework"
        
        switch manager.state
        {
        case .waiting:
            return AnyView(
                DragAndDropView(text: defaultText, dropActive: dropActive)
                    .onDrop(of: [(kUTTypeFileURL as String)], delegate: self)
            )

        case .loaded(let frameworkDescription):
            return AnyView(FrameworkInfoView(frameworkDescription: frameworkDescription))
        }
    }
}

extension ContentView: DropDelegate
{
    func performDrop(info: DropInfo) -> Bool
    {
        return manager.onDrop(info: info)
    }
    
    func dropEntered(info: DropInfo)
    {
        dropActive = true
    }
    
    func dropExited(info: DropInfo)
    {
        dropActive = false
    }
}

struct ContentView_Previews: PreviewProvider
{
    static var previews: some View
    {
        ContentView()
    }
}
