protocol Router : class {
    func showNewRestaurantScreen()
    func showRestaurantListScreen()
    func showRestaurantDetailScreen(id: Int)
    func showEditRestaurantScreen(restaurant: Restaurant)
    func showLoginScreen()
}