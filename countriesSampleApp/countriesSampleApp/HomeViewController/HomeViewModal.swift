import Foundation

class HomeViewModel {
    
    private var allCountries: [Country] = []
    var filteredCountries: [Country] = []
    
    private let apiService = APIService()
    
    var didUpdateCountries: (() -> Void)?
    var didFailWithError: ((Error) -> Void)?
    
    private var searchText: String = ""
    private var populationFilter: Int?
    
    // Fetch countries from API
    func fetchCountries() {
        apiService.fetchCountries { [weak self] result in
            switch result {
            case .success(let countries):
                self?.allCountries = countries
                self?.applyFilters()
            case .failure(let error):
                self?.didFailWithError?(error)
            }
        }
    }
    
    // Set search text and apply filters
    func searchCountry(by name: String) {
        searchText = name
        applyFilters()
    }
    
    // Set population filter and apply filters
    func filterCountries(byPopulationRange range: Int) {
        populationFilter = range
        applyFilters()
    }
    
    // Apply search and filter criteria
    private func applyFilters() {
        var filtered = allCountries
        
        if !searchText.isEmpty {
            filtered = filtered.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
        
        if let filterRange = populationFilter {
            filtered = filtered.filter { $0.population ?? 0 < filterRange }
        }
        
        filteredCountries = filtered
        didUpdateCountries?()
    }
    
    func formattedCurrentDateTime() -> String {
        // Get the current date and time
        let now = Date()
        
        // Create a DateFormatter instance
        let dateFormatter = DateFormatter()
        
        
        dateFormatter.isLenient = true

        
        // Set the date and time style
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        // Set the time zone to the device's current time zone
        dateFormatter.timeZone = TimeZone.current
        
        // Create a date format string
        dateFormatter.dateFormat = "d MMM h:mm a zzz"
        
        // Get the formatted date string
        dateFormatter.locale =  Locale(identifier: "en_US_POSIX")
        let formattedDate = dateFormatter.string(from: now)
        
        // Convert the date to include ordinal suffix
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "d"
        let day = dayFormatter.string(from: now)
        let dayWithSuffix = ordinalSuffix(for: Int(day) ?? 1)
        
        // Replace the day number in the formatted date with the day with suffix
        let result = formattedDate.replacingOccurrences(of: day, with: dayWithSuffix)
        
        return result
    }

    private func ordinalSuffix(for day: Int) -> String {
        switch day {
        case 1, 21, 31:
            return "\(day)st"
        case 2, 22:
            return "\(day)nd"
        case 3, 23:
            return "\(day)rd"
        default:
            return "\(day)th"
        }
    }
}

