import Foundation

struct BloodCenter: Identifiable, Hashable {
    let id: String
    let name: String
    let address: String
}

/// Regionalne Centra Krwiodawstwa i Krwiolecznictwa (RCKiK) w Polsce.
/// Źródło: https://www.gov.pl/web/nck/regionalne-centra-krwiodawstwa-krwiolecznictwa
enum BloodCenters {
    static let all: [BloodCenter] = [
        BloodCenter(id: "bialystok", name: "RCKiK w Białymstoku", address: "ul. Marii Skłodowskiej-Curie 23, Białystok"),
        BloodCenter(id: "bydgoszcz", name: "RCKiK w Bydgoszczy", address: "ul. Ks. Markwarta 8, Bydgoszcz"),
        BloodCenter(id: "gdansk", name: "RCKiK w Gdańsku", address: "ul. J. Hoene-Wrońskiego 4, Gdańsk"),
        BloodCenter(id: "kalisz", name: "RCKiK w Kaliszu", address: "ul. Kaszubska 9, Kalisz"),
        BloodCenter(id: "katowice", name: "RCKiK w Katowicach", address: "ul. Raciborska 15, Katowice"),
        BloodCenter(id: "kielce", name: "RCKiK w Kielcach", address: "ul. Jagiellońska 66, Kielce"),
        BloodCenter(id: "krakow", name: "RCKiK w Krakowie", address: "ul. Rzeźnicza 11, Kraków"),
        BloodCenter(id: "lublin", name: "RCKiK w Lublinie", address: "ul. Żołnierzy Niepodległej 8, Lublin"),
        BloodCenter(id: "lodz", name: "RCKiK w Łodzi", address: "ul. Franciszkańska 17/25, Łódź"),
        BloodCenter(id: "olsztyn", name: "RCKiK w Olsztynie", address: "ul. Malborska 2, Olsztyn"),
        BloodCenter(id: "opole", name: "RCKiK w Opolu", address: "ul. Kośnego 55, Opole"),
        BloodCenter(id: "poznan", name: "RCKiK w Poznaniu", address: "ul. Marcelińska 44, Poznań"),
        BloodCenter(id: "raciborz", name: "RCKiK w Raciborzu", address: "ul. Sienkiewicza 3A, Racibórz"),
        BloodCenter(id: "radom", name: "RCKiK w Radomiu", address: "ul. Limanowskiego 42, Radom"),
        BloodCenter(id: "rzeszow", name: "RCKiK w Rzeszowie", address: "ul. Wierzbowa 14, Rzeszów"),
        BloodCenter(id: "slupsk", name: "RCKiK w Słupsku", address: "ul. Szarych Szeregów 21, Słupsk"),
        BloodCenter(id: "szczecin", name: "RCKiK w Szczecinie", address: "al. Wojska Polskiego 80/82, Szczecin"),
        BloodCenter(id: "walbrzych", name: "RCKiK w Wałbrzychu", address: "ul. B. Chrobrego 31, Wałbrzych"),
        BloodCenter(id: "warszawa", name: "RCKiK w Warszawie", address: "ul. Saska 63/75, Warszawa"),
        BloodCenter(id: "wroclaw", name: "RCKiK we Wrocławiu", address: "ul. Czerwonego Krzyża 5/9, Wrocław"),
        BloodCenter(id: "zielonagora", name: "RCKiK w Zielonej Górze", address: "ul. Zyty 21, Zielona Góra")
    ]
}
