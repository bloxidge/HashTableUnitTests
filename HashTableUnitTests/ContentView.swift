//
//  ContentView.swift
//  HashTableUnitTests
//
//  Created by Dan Ellis on 26/09/2024.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var vm: ContentViewModel = ContentViewModel()
    
    var body: some View {
        VStack {
            HStack {
                Text("Observer Count")
                Button("Refresh",
                       action: vm.refreshCount)
            }
            Text("\(vm.observerCount) observers")
            Divider()
            Text("testBasicAddAndRemove")
            HStack {
                Button("Add Observer", 
                       action: vm.addObserver)
                Button("Pop Observer",
                       action: vm.popObserver)
            }
            
            Divider()
            Text("testRemoveObjectThatIsNotIn")
            HStack {
                Button("Remove New Observer",
                       action: vm.removeNewObserver)
            }
            
            Divider()
            Text("testRemoveCalledDuringDeinit")
            HStack {
                Button("Remove New Observer",
                       action: vm.removeDuringDeinit)
            }
            
            Divider()
            Text("testRemoveTwiceOnDifferentThreads")
            HStack {
                Button("Remove On Multiple Threads",
                       action: vm.removeMultipleThreads)
            }
            
            Divider()
            Text("testRemoveManyTimesOnDifferentThreads")
            HStack {
                Button("Remove On MANY Threads",
                       action: vm.removeManyThreads)
            }
            
            Divider()
            Text("testFix????")
            HStack {
                Button("Remove On MANY Threads via MainActor",
                       action: vm.mainActorRemoveManyThreads
)
            }
            
            Divider()
            Text("testFix????")
            HStack {
                Button("Remove On MANY Threads via MainActor Deinit",
                       action: vm.mainActorRemoveManyThreadsDeinit
)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
