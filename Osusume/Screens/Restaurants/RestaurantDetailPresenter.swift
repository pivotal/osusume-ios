struct RestaurantDetailPresenter {
    let restaurant: Restaurant

    var name: String {
        return restaurant.name
    }

    var address: String {
        return restaurant.address
    }

    var cuisineType: String {
        return restaurant.cuisineType
    }

    var offersEnglishMenu: String {
        if restaurant.offersEnglishMenu {
            return "Offers English menu"
        }

        return "Does not offer English menu"
    }

    var walkInsOk: String {
        if restaurant.walkInsOk {
            return "Walk-ins ok"
        }

        return "Walk-ins not recommended"
    }

    var creditCardsOk: String {
        if restaurant.acceptsCreditCards {
            return "Accepts credit cards"
        }

        return "Does not accept credit cards"
    }

    var notes: String {
        return self.restaurant.notes
    }

    var author: String {
        return "Added by \(restaurant.author)"
    }

    var addedOnDate: String {
        return "on \(DateConverter().formattedDate(restaurant.createdAt))"
    }
}