//
//  LilypodeApp.swift
//  Lilypode
//
//  Created by Saad Anis on 22/02/2025.
//

import SwiftUI
import SwiftData
import HealthKit

@main
struct LilypodeApp: App {
    
    init() {
        UserDefaults.standard.register(defaults: [
            "timerDuration": 60,
            "onboardingComplete": false
        ])
    }
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Entry.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
//    init() {
//        let largeTitle = UIFont.preferredFont(forTextStyle: .extraLargeTitle)
//        let regularTitle = UIFont.preferredFont(forTextStyle: .body)
//
//         // Define descriptor with rounded design
//        let descriptor = largeTitle.fontDescriptor.withDesign(.rounded)!
//        let largeFont = UIFont(descriptor: descriptor, size: largeTitle.pointSize)
//        let regularFont = UIFont(descriptor: descriptor, size: regularTitle.pointSize)
//
//        // For large title
//        UINavigationBar.appearance().largeTitleTextAttributes = [.font : largeFont]
//
//        // For inline title
//        UINavigationBar.appearance().titleTextAttributes = [.font : regularFont]
//    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}

class HealthKitManager: ObservableObject {
    static let shared = HealthKitManager()
    
    var healthStore = HKHealthStore()
    
    let stateOfMindType = HKQuantityType.stateOfMindType()
    
    func authorize() async {
        do {
            if HKHealthStore.isHealthDataAvailable() {
                try await healthStore.requestAuthorization(toShare: [stateOfMindType], read: [HKQuantityType.stateOfMindType()])
            }
        } catch {
            fatalError("*** An unexpected error occurred while requesting authorization: \(error.localizedDescription) ***")
        }
    }
    
    func writeStateOfMind() {
        healthStore.requestAuthorization(toShare: [stateOfMindType], read: nil) { success, error in
            if success {
                
            } else {
                
            }
        }
    }
}

struct K {
    static var entries: [Entry] {
        
        let calendar = Calendar.current
        
        var _entries: [Entry] = []
        
        for i in 1...50 {
            _entries.append(.init(timestamp: calendar.date(byAdding: .day, value: -18-i, to: Date())!,
                  content: "i literally just don't care anymore. why can't i just die rn."))
        }
        
        _entries.append(contentsOf: [
            .init(timestamp: calendar.date(byAdding: .day, value: -1, to: Date())!,
                  content: "ugh. today was literally the worst. like. why do teachers act like i don’t have a life outside of school??? ms. davis had the AUDACITY to assign a five-page essay DUE TOMORROW like be so fr. do i look like someone who has time for that?? also my mom is literally so annoying. she was like “you need to clean your room” like girl WHY do you care??? you don’t even come in here. it’s MY space. let me be messy in PEACE. anyway. i think i’m gonna fail math. which is whatever tbh. like who even uses algebra in real life."),
            .init(timestamp: calendar.date(byAdding: .day, value: -2, to: Date())!,
                  content: "ok so. like. why is everyone so fake. i literally can’t trust ANYONE. i tell mia ONE (1) little secret and now the whole school knows. like omg thanks girl. never trusting again. people act like i’m overreacting but like NO??? if i wanted people to know i would’ve told them myself??? also i swear i’m just meant to be alone forever bc all my “friends” do is talk about me behind my back like i don’t have EARS. whatever. i’m gonna start gatekeeping myself."),
            .init(timestamp: calendar.date(byAdding: .day, value: -4, to: Date())!,
                  content: "literally WHAT is wrong with boys. like. ACTUALLY. why do they say they like you and then act like you don’t exist the next day. Aiden was texting me all last week like “omg you’re so pretty” and now he just left me on read for 12 hours. like hello??? what changed??? i hate everyone. gonna delete social media and become a mysterious loner fr. i just KNOW i was meant to be some kind of dark academia girl living in europe but no i’m stuck in this ugly town with ugly people and ugly vibes."),
            .init(timestamp: calendar.date(byAdding: .day, value: -5, to: Date())!,
                  content: "i need to get out of this house before i lose my mind. my mom keeps saying “you have an attitude” LIKE YEAH MAYBE BC YOU WON’T LEAVE ME ALONE. she literally yells at me for being on my phone too much but then gets mad when i don’t answer her texts. like girl PICK A SIDE. also she keeps saying i spend too much money like okay maybe if you gave me what i wanted i wouldn’t HAVE to buy it myself. idc. i’m moving to new york when i turn 18 and never coming back."),
            .init(timestamp: calendar.date(byAdding: .day, value: -6, to: Date())!,
                  content: "ok. so i found this playlist on spotify called “songs to stare out the window to like you’re in a movie” and it literally changed my life. like i was listening to it on the bus today and it was raining and i literally felt like the main character. i’m not even joking i think i had a spiritual awakening. also. why are the people at school SO embarrassing. like. do you not feel shame. some people just walk around acting like npcs."),
            .init(timestamp: calendar.date(byAdding: .day, value: -7, to: Date())!,
                  content: "i swear my life is a joke. like tell me WHY i spent an hour doing my makeup today and then it starts RAINING. and not like cute little rain. like full on thunderstorm. the universe literally hates me. i just know the ppl in the simulation are laughing at me rn. also i saw mia and sophie whispering in class today and i just KNOW they were talking about me. they’re literally so weird. i’m so over it."),
            .init(timestamp: calendar.date(byAdding: .day, value: -8, to: Date())!,
                  content: "thinking abt running away. not in like a serious way but like. hypothetically. i feel like i was meant to be some kind of rockstar or socialite or idk just someone IMPORTANT but instead i’m sitting here in this dusty ass town doing NOTHING. i need to do something crazy. maybe i should dye my hair. but like. in a cool way. not like the weird box dye way. whatever. gonna go scroll tiktok for 3 hours.")
        ])
        
        return _entries
    }
}
