# Krwiodawca

Aplikacja iOS (SwiftUI) wspierająca honorowych dawców krwi. Pozwala śledzić historię
oddawania krwi, sprawdzać kiedy można oddać krew ponownie oraz zdobywać osiągnięcia
i odznaki za regularne krwiodawstwo.

## Funkcje

- **Pulpit** — podsumowanie statystyk (liczba donacji, oddana ilość krwi, szacowana
  liczba osób, którym pomogła krew) oraz karty "kiedy możesz oddać krew" dla krwi
  pełnej, osocza i płytek krwi.
- **Statystyki** — wykresy donacji w czasie i podziału na składniki krwi (Swift Charts),
  średnia częstotliwość oddawania krwi.
- **Osiągnięcia** — roadmapa z odznakami (m.in. tytuł Honorowego Dawcy Krwi, odznaki
  "Zasłużony HDK" brąz/srebro/złoto) wraz z listą przysługujących benefitów.
- **Historia** — pełna lista donacji z możliwością dodawania, edycji i usuwania.

Reguły kwalifikacji (minimalne odstępy między donacjami, roczne limity) oraz progi
odznak są oparte na uproszczonych, orientacyjnych wytycznych polskich RCKiK — przed
oddaniem krwi zawsze warto potwierdzić aktualne zasady w punkcie poboru krwi.

## Wymagania

- Xcode 16+ (projekt korzysta z formatu synchronizowanych grup plików)
- iOS 17+ (SwiftData, Swift Charts)

## Uruchomienie

Otwórz `Krwiodawca.xcodeproj` w Xcode i uruchom schemat **Krwiodawca** na dowolnym
symulatorze iPhone.

## Architektura

```
Krwiodawca/
├── Models/       // Donation (SwiftData), BloodComponentType, DonorProfile, Achievement
├── Services/      // EligibilityCalculator, DonationStatistics
└── Views/         // DashboardView, StatsView, AchievementsView, HistoryView, ...
```

Dane przechowywane są lokalnie na urządzeniu (SwiftData + UserDefaults dla profilu) —
aplikacja nie korzysta z żadnego backendu.
