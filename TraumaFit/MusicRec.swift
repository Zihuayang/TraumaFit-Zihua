import SwiftUI

struct MusicRec: View {
    
    @State private var currentSong: String = "Press Generate to get a song"
    @State private var selectedGenre: String = "EDM"
    
    var body: some View {
        ZStack {
            
            Image("music_logo")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .opacity(1)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                
                Text("Song of the Day")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.top, 38)
                    .shadow(color: .black, radius: 2, x: 0, y: 0)
                
                
                Text(currentSong)
                    .font(.title2)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(Color.black.opacity(0.4))
                    .cornerRadius(15)
                    .padding(.horizontal)
                    .padding(.top, 148)
                
                Spacer()
                
                
                Picker("Select Genre", selection: $selectedGenre) {
                    ForEach(genres, id: \.self) { genre in
                        Text(genre).tag(genre)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(Color.white.opacity(0.2))
                .cornerRadius(10)
                .padding()
                
                
                Button(action: generateSong) {
                    Text("Generate")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .shadow(color: .black, radius: 1, x: 0, y: 0)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(red: 0.4, green: 0.7, blue: 0.4),
                                    Color(red: 0.0, green: 0.6, blue: 0.0)
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(15)
                        .padding(.horizontal, 50)
                }
                .padding(.bottom, 50)
            }
        }
    }
    
    
    func generateSong() {
        if let songs = songsByGenre[selectedGenre] {
            currentSong = songs.randomElement() ?? "No songs available"
        } else {
            currentSong = "No songs available"
        }
    }
}

struct MusicRec_Previews: PreviewProvider {
    static var previews: some View {
        MusicRec()
    }
}


let genres = ["EDM", "Hip-pop", "Pop", "R&B"]


let songsByGenre: [String: [String]] = [
    "EDM": [
        "Wake Me Up - Avicii",
        "Levels - Avicii",
        "Clarity - Zedd",
        "Don't You Worry Child - Swedish House Mafia",
        "Animals - Martin Garrix",
        "Lean On - Major Lazer & DJ Snake",
        "Get Lucky - Daft Punk",
        "Strobe - Deadmau5",
        "Stay the Night - Zedd ft. Hayley Williams",
        "Summer - Calvin Harris",
        "Where Are Ü Now - Skrillex & Diplo with Justin Bieber",
        "Titanium - David Guetta ft. Sia",
        "Turn Down for What - DJ Snake & Lil Jon",
        "Firestone - Kygo ft. Conrad Sewell",
        "Reload - Sebastian Ingrosso & Tommy Trash ft. John Martin",
        "Scary Monsters and Nice Sprites - Skrillex",
        "This Is What It Feels Like - Armin van Buuren ft. Trevor Guthrie",
        "I Took a Pill in Ibiza (Seeb Remix) - Mike Posner",
        "Faded - Alan Walker",
        "The Middle - Zedd, Maren Morris & Grey",
        "One More Time - Daft Punk",
        "Don't Let Me Down - The Chainsmokers ft. Daya",
        "Closer - The Chainsmokers ft. Halsey",
        "Sun & Moon - Above & Beyond ft. Richard Bedford",
        "Calling (Lose My Mind) - Sebastian Ingrosso & Alesso ft. Ryan Tedder",
        "You & Me (Flume Remix) - Disclosure",
        "Stay - Kygo ft. Maty Noyes",
        "Runaway (U & I) - Galantis",
        "Pompeii (Audien Remix) - Bastille",
        "Feel So Close - Calvin Harris",
        "Cinema - Benny Benassi ft. Gary Go",
        "Fade Into Darkness - Avicii",
        "Save the World - Swedish House Mafia",
        "The Veldt - Deadmau5 ft. Chris James",
        "Sweet Nothing - Calvin Harris ft. Florence Welch",
        "Bad - David Guetta & Showtek ft. Vassy",
        "Latch - Disclosure ft. Sam Smith",
        "You Make Me - Avicii",
        "Find You - Zedd ft. Matthew Koma & Miriam Bryant",
        "Silhouettes - Avicii",
        "Tsunami - DVBBS & Borgeous",
        "Hey Brother - Avicii",
        "Under Control - Calvin Harris & Alesso ft. Hurts",
        "Gold Skies - Sander van Doorn, Martin Garrix & DVBBS ft. Aleesia",
        "Turn Up the Speakers - Afrojack & Martin Garrix",
        "All of Me (Tiesto's Birthday Treatment Remix) - John Legend",
        "In the Name of Love - Martin Garrix & Bebe Rexha",
        "There for You - Martin Garrix & Troye Sivan",
        "Something Just Like This - The Chainsmokers & Coldplay",
        "Scared to Be Lonely - Martin Garrix & Dua Lipa"

    ],
    
    "Hip-pop": [
        "God's Plan - Drake",
        "Sicko Mode - Travis Scott",
        "Rockstar - Post Malone ft. 21 Savage",
        "HUMBLE. - Kendrick Lamar",
        "Bad and Boujee - Migos ft. Lil Uzi Vert",
        "Old Town Road - Lil Nas X ft. Billy Ray Cyrus",
        "Lucid Dreams - Juice WRLD",
        "Bodak Yellow - Cardi B",
        "XO Tour Llif3 - Lil Uzi Vert",
        "Mask Off - Future",
        "DNA. - Kendrick Lamar",
        "Panda - Desiigner",
        "All The Stars - Kendrick Lamar & SZA",
        "Nonstop - Drake",
        "Goosebumps - Travis Scott ft. Kendrick Lamar",
        "No Limit - G-Eazy ft. A$AP Rocky & Cardi B",
        "Stir Fry - Migos",
        "Godzilla - Eminem ft. Juice WRLD",
        "Yes Indeed - Lil Baby & Drake",
        "Ric Flair Drip - Offset & Metro Boomin",
        "Life Is Good - Future ft. Drake",
        "Money In The Grave - Drake ft. Rick Ross",
        "Drip Too Hard - Lil Baby & Gunna",
        "The Box - Roddy Ricch",
        "ROCKSTAR - DaBaby ft. Roddy Ricch",
        "Suge - DaBaby",
        "Highest In The Room - Travis Scott",
        "Toosie Slide - Drake",
        "Franchise - Travis Scott ft. Young Thug & M.I.A.",
        "WAP - Cardi B ft. Megan Thee Stallion",
        "Savage Remix - Megan Thee Stallion ft. Beyoncé",
        "Laugh Now Cry Later - Drake ft. Lil Durk",
        "What's Next - Drake",
        "Way 2 Sexy - Drake ft. Future & Young Thug",
        "Industry Baby - Lil Nas X ft. Jack Harlow",
        "Thot Shit - Megan Thee Stallion",
        "Up - Cardi B",
        "Montero (Call Me By Your Name) - Lil Nas X",
        "Rapstar - Polo G",
        "Kiss Me More - Doja Cat ft. SZA",
        "Need To Know - Doja Cat",
        "Family Ties - Baby Keem ft. Kendrick Lamar",
        "Knife Talk - Drake ft. 21 Savage & Project Pat",
        "Late At Night - Roddy Ricch",
        "Fair Trade - Drake ft. Travis Scott",
        "Essence - Wizkid ft. Tems",
        "Girls Want Girls - Drake ft. Lil Baby",
        "What's Poppin - Jack Harlow",
        "Ransom - Lil Tecca",
        "Ballin' - Mustard ft. Roddy Ricch"
    ],
    
    "Pop": [
        "Die With A Smile - Lady Gaga and Bruno Mars",
        "Watermelon Sugar - Harry Styles",
        "Don't Start Now - Dua Lipa",
        "Levitating - Dua Lipa",
        "Bad Guy - Billie Eilish",
        "Someone You Loved - Lewis Capaldi",
        "Shallow - Lady Gaga & Bradley Cooper",
        "Circles - Post Malone",
        "Señorita - Shawn Mendes & Camila Cabello",
        "Dance Monkey - Tones and I",
        "Shape of You - Ed Sheeran",
        "Perfect - Ed Sheeran",
        "Thank U, Next - Ariana Grande",
        "Havana - Camila Cabello ft. Young Thug",
        "Can't Stop the Feeling! - Justin Timberlake",
        "Girls Like You - Maroon 5 ft. Cardi B",
        "Adore You - Harry Styles",
        "Stuck with U - Ariana Grande & Justin Bieber",
        "Positions - Ariana Grande",
        "Bad Habits - Ed Sheeran",
        "Peaches - Justin Bieber ft. Daniel Caesar & Giveon",
        "Good 4 U - Olivia Rodrigo",
        "Drivers License - Olivia Rodrigo",
        "Stay - The Kid LAROI & Justin Bieber",
        "Butter - BTS",
        "Dynamite - BTS",
        "Save Your Tears - The Weeknd",
        "Intentions - Justin Bieber ft. Quavo",
        "Sunflower - Post Malone & Swae Lee",
        "Before You Go - Lewis Capaldi",
        "7 Rings - Ariana Grande",
        "Lovely - Billie Eilish & Khalid",
        "Everything I Wanted - Billie Eilish",
        "Someone Like You - Adele",
        "Hello - Adele",
        "Rolling in the Deep - Adele",
        "Easy on Me - Adele",
        "As It Was - Harry Styles",
        "Shivers - Ed Sheeran",
        "Heat Waves - Glass Animals",
        "About Damn Time - Lizzo",
        "Unholy - Sam Smith & Kim Petras",
        "Anti-Hero - Taylor Swift",
        "Flowers - Miley Cyrus",
        "Chandelier - Sia",
        "Cheap Thrills - Sia ft. Sean Paul",
        "Uptown Funk - Mark Ronson ft. Bruno Mars",
        "24K Magic - Bruno Mars",
        "That's What I Like - Bruno Mars"
    ],
    
    "R&B": [
        "Blinding Lights - The Weeknd",
        "Leave The Door Open - Silk Sonic",
        "Heartbreak Anniversary - Giveon",
        "Good Days - SZA",
        "Damage - H.E.R.",
        "Pick Up Your Feelings - Jazmine Sullivan",
        "Talk - Khalid",
        "Best Part - Daniel Caesar ft. H.E.R.",
        "Boo'd Up - Ella Mai",
        "Adorn - Miguel",
        "Redbone - Childish Gambino",
        "Exchange - Bryson Tiller",
        "Don't - Bryson Tiller",
        "Come Through - H.E.R. ft. Chris Brown",
        "Earned It - The Weeknd",
        "Can't Feel My Face - The Weeknd",
        "Wild Thoughts - DJ Khaled ft. Rihanna & Bryson Tiller",
        "No Guidance - Chris Brown ft. Drake",
        "Call Out My Name - The Weeknd",
        "Thinkin Bout You - Frank Ocean",
        "Self Control - Frank Ocean",
        "I Like That - Janelle Monáe",
        "Trip - Ella Mai",
        "Come Thru - Summer Walker ft. Usher",
        "Love Galore - SZA ft. Travis Scott",
        "The Weekend - SZA",
        "Needed Me - Rihanna",
        "Work - Rihanna ft. Drake",
        "Kiss It Better - Rihanna",
        "Feelings - Snoh Aalegra",
        "Focus - H.E.R.",
        "Permission - Ro James",
        "Roll Some Mo - Lucky Daye",
        "Get You - Daniel Caesar ft. Kali Uchis",
        "Love Lies - Khalid & Normani",
        "Over It - Summer Walker",
        "While We're Young - Jhené Aiko",
        "Do It - Chloe x Halle",
        "Ungodly Hour - Chloe x Halle",
        "Love Me Now - John Legend",
        "All of Me - John Legend",
        "Sky Walker - Miguel ft. Travis Scott",
        "Lotus Flower Bomb - Wale ft. Miguel",
        "Shea Butter Baby - Ari Lennox ft. J. Cole",
        "BMO - Ari Lennox",
        "OTW - Khalid ft. Ty Dolla $ign & 6LACK",
        "BS - Jhené Aiko ft. H.E.R.",
        "Put You On - Amber Mark ft. DRAM",
        "Essence - Wizkid ft. Tems",
        "Fool For You - Snoh Aalegra"

    ]
]
