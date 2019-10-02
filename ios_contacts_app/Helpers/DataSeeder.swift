//
//  DataSeeder.swift
//  ios_contacts_app
//

import Foundation

class DataSeeder {
  static private let firstNames = [
   "Jesus",
   "Clay",
   "Ramon",
   "Eusebio",
   "Faustino",
   "Dorsey",
   "Maurice",
   "Thad",
   "Aaron",
   "Danial",
   "Garry",
   "Daniel",
   "Bryant",
   "Drew",
   "Sung",
   "Wilburn",
   "Mose",
   "Hiram",
   "Trent",
   "Raymond",
   "Basil",
   "Nick",
   "Jean",
   "Guadalupe",
   "Johnson",
   "Eddy",
   "Cory",
   "Stephen",
   "Valentine",
   "Tom",
   "Denver",
   "Antoine",
   "Hosea",
   "Lynn",
   "Gayle",
   "Raymon",
   "Chang",
   "Cruz",
   "Nolan",
   "Arlie",
   "Joel",
   "Neville",
   "Rich",
   "Jayson",
   "Terrence",
   "Amado",
   "Marcel",
   "Ronnie",
   "Weston",
   "Dorian"
  ]
  
  static private let lastNames = [
    "Lyons",
    "Arellano",
    "Holmes",
    "Shepherd",
    "Morrison",
    "Padilla",
    "Knapp",
    "Powers",
    "Wyatt",
    "Henderson",
    "Boyle",
    "Castaneda",
    "Henry",
    "Benton",
    "Flynn",
    "Sutton",
    "Barrera",
    "Finley",
    "Reeves",
    "Mora",
    "Middleton",
    "Church",
    "Thompson",
    "Orozco",
    "Rice",
    "Decker",
    "Owens",
    "Ellis",
    "Barton",
    "Hawkins",
    "Hayden",
    "Kennedy",
    "Watkins",
    "Morrow",
    "Mccarty",
    "Spencer",
    "Maynard",
    "Dixon",
    "Li",
    "Villanueva",
    "Webster",
    "Holt",
    "Bonilla",
    "Pace",
    "Ramos",
    "Palmer",
    "Mathis",
    "Maddox",
    "Alvarado",
    "Jensen"
  ]
  
  static private let notes = [
   "She always speaks to him in a loud voice.",
   "She advised him to come back at once.",
   "I am counting my calories, yet I really want dessert.",
   "Wednesday is hump day, but has anyone asked the camel if he’s happy about it?",
   "A song can make or ruin a person’s day if they let it get to them.",
   "Check back tomorrow; I will see if the book has arrived.",
   "It was getting dark, and we weren’t there yet.",
   "She was too short to see over the fence.",
   "Someone I know recently combined Maple Syrup & buttered Popcorn thinking it would taste like caramel popcorn.",
   "I would have gotten the promotion, but my attendance wasn’t good enough.",
   "The old apple revels in its authority.",
   "Christmas is coming.",
   "I really want to go to work, but I am too sick to drive.",
   "I love eating toasted cheese and tuna sandwiches.",
   "I often see the time 11:11 or 12:34 on clocks.",
   "There were white out conditions in the town; subsequently, the roads were impassable.",
   "How was the math test?",
   "We need to rent a room for our party.",
   "The quick brown fox jumps over the lazy dog.",
   "If you like tuna and tomato sauce- try combining the two. It’s really not as bad as it sounds.",
   "I will never be this young again. Ever. Oh damn… I just got older.",
   "The memory we used to share is no longer coherent.",
   "He turned in the research paper on Friday; otherwise, he would have not passed the class.",
   "She wrote him a long letter, but he didn't read it.",
   "She works two jobs to make ends meet; at least, that was her reason for not having time to join us.",
   "What was the person thinking when they discovered cow’s milk was fine for human consumption…",
   "Tom got a small piece of pie.",
   "This is the last random sentence I will be writing and I am going to stop mid-sent",
   "Last Friday in three week’s time I saw a spotted striped blue worm shake hands with a legless lizard.",
   "I am never at home on Sundays.",
   "He didn’t want to go to the dentist, yet he went anyway.",
   "I want to buy a onesie… but know it won’t suit me.",
   "The sky is clear; the stars are twinkling.",
   "She did her best to help him.",
   "I am happy to take your donation; any amount will be greatly appreciated.",
   "Where do random thoughts come from?",
   "Lets all be unique together until we realise we are all the same.",
   "Two seats were vacant.",
   "Rock music approaches at high velocity.",
   "If Purple People Eaters are real… where do they find purple people to eat?",
   "I was very proud of my nickname throughout high school but today- I couldn’t be any different to what my nickname was.",
   "Italy is my favorite country; in fact, I plan to spend two weeks there next year.",
   "Everyone was busy, so I went to the movie alone.",
   "We have a lot of rain in June.",
   "I want more detailed information.",
   "Malls are great places to shop; I can find everything I need under one roof.",
   "Cats are good pets, for they are clean and are not noisy.",
   "When I was little I had a car door slammed shut on my hand. I still remember it quite vividly.",
   "They got there early, and they got really good seats.",
   "Joe made the sugar cookies; Susan decorated them."
  ]
  
  static func seedContacts(count: Int) {
    let storageService = StorageService()
    let ringtoneService = RingtoneService()
    
    let result = storageService.getContacts()
    switch result {
    case .success(let contacts):
      if !contacts.isEmpty {
        return
      }
    case .failure:
      return
    }
    
    for _ in 1...count {
      let contact = Contact(firstName: firstNames.randomElement() ?? "John",
                            lastName: lastNames.randomElement() ?? "Doe",
                            phoneNumber: "+\(Int.random(in: 10000000000...99999999999))",
                            ringtone: ringtoneService.getRingtones().randomElement() ?? "Default",
                            notes: notes.randomElement())
      _ = storageService.saveContact(contact)
    }
  }
}
