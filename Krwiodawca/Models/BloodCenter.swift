import Foundation

struct BloodCenter: Identifiable, Hashable {
    let id: String
    let name: String
    let address: String
    let website: String

    var websiteURL: URL? {
        URL(string: website)
    }
}

/// Regionalne Centra Krwiodawstwa i Krwiolecznictwa (RCKiK) w Polsce.
/// Źródło: https://www.gov.pl/web/nck/regionalne-centra-krwiodawstwa-krwiolecznictwa
enum BloodCenters {
    static let all: [BloodCenter] = [
        BloodCenter(id: "bialystok", name: "RCKiK w Białymstoku", address: "ul. Marii Skłodowskiej-Curie 23, Białystok", website: "https://www.rckik.bialystok.pl"),
        BloodCenter(id: "bydgoszcz", name: "RCKiK w Bydgoszczy", address: "ul. Ks. Markwarta 8, Bydgoszcz", website: "https://www.rckik-bydgoszcz.com.pl"),
        BloodCenter(id: "gdansk", name: "RCKiK w Gdańsku", address: "ul. J. Hoene-Wrońskiego 4, Gdańsk", website: "https://www.krew.gda.pl"),
        BloodCenter(id: "kalisz", name: "RCKiK w Kaliszu", address: "ul. Kaszubska 9, Kalisz", website: "https://www.krwiodawstwo.kalisz.pl"),
        BloodCenter(id: "katowice", name: "RCKiK w Katowicach", address: "ul. Raciborska 15, Katowice", website: "https://www.rckik-katowice.pl"),
        BloodCenter(id: "kielce", name: "RCKiK w Kielcach", address: "ul. Jagiellońska 66, Kielce", website: "https://www.rckik-kielce.com.pl"),
        BloodCenter(id: "krakow", name: "RCKiK w Krakowie", address: "ul. Rzeźnicza 11, Kraków", website: "https://www.rckik.krakow.pl"),
        BloodCenter(id: "lublin", name: "RCKiK w Lublinie", address: "ul. Żołnierzy Niepodległej 8, Lublin", website: "https://www.rckik.lublin.pl"),
        BloodCenter(id: "lodz", name: "RCKiK w Łodzi", address: "ul. Franciszkańska 17/25, Łódź", website: "https://www.krwiodawstwo.pl"),
        BloodCenter(id: "olsztyn", name: "RCKiK w Olsztynie", address: "ul. Malborska 2, Olsztyn", website: "https://www.rckikol.pl"),
        BloodCenter(id: "opole", name: "RCKiK w Opolu", address: "ul. Kośnego 55, Opole", website: "https://www.rckik-opole.com.pl"),
        BloodCenter(id: "poznan", name: "RCKiK w Poznaniu", address: "ul. Marcelińska 44, Poznań", website: "https://www.rckik.poznan.pl"),
        BloodCenter(id: "raciborz", name: "RCKiK w Raciborzu", address: "ul. Sienkiewicza 3A, Racibórz", website: "https://www.rckik.pl"),
        BloodCenter(id: "radom", name: "RCKiK w Radomiu", address: "ul. Limanowskiego 42, Radom", website: "https://www.rckik.radom.pl"),
        BloodCenter(id: "rzeszow", name: "RCKiK w Rzeszowie", address: "ul. Wierzbowa 14, Rzeszów", website: "https://www.rckk.rzeszow.pl"),
        BloodCenter(id: "slupsk", name: "RCKiK w Słupsku", address: "ul. Szarych Szeregów 21, Słupsk", website: "https://www.krwiodawstwo.slupsk.pl"),
        BloodCenter(id: "szczecin", name: "RCKiK w Szczecinie", address: "al. Wojska Polskiego 80/82, Szczecin", website: "https://www.krwiodawstwo.szczecin.pl"),
        BloodCenter(id: "walbrzych", name: "RCKiK w Wałbrzychu", address: "ul. B. Chrobrego 31, Wałbrzych", website: "https://www.rckik.walbrzych.pl"),
        BloodCenter(id: "warszawa", name: "RCKiK w Warszawie", address: "ul. Saska 63/75, Warszawa", website: "https://www.rckik-warszawa.com.pl"),
        BloodCenter(id: "wroclaw", name: "RCKiK we Wrocławiu", address: "ul. Czerwonego Krzyża 5/9, Wrocław", website: "https://www.rckik.wroclaw.pl"),
        BloodCenter(id: "zielonagora", name: "RCKiK w Zielonej Górze", address: "ul. Zyty 21, Zielona Góra", website: "https://www.rckik.zgora.pl")
    ]
}
