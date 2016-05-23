struct Restaurant {
    let id: Int
    let name: String
    let address: String
    let cuisineType: String
    let cuisine: Cuisine
    let offersEnglishMenu: Bool
    let walkInsOk: Bool
    let acceptsCreditCards: Bool
    let notes: String
    let author: String
    let liked: Bool
    let numberOfLikes: Int
    let priceRange: String
    let createdAt: NSDate?
    let photoUrls: [NSURL]
    var comments: [PersistedComment]

    init(
        id: Int,
        name: String,
        address: String,
        cuisineType: String,
        cuisine: Cuisine,
        offersEnglishMenu: Bool,
        walkInsOk: Bool,
        acceptsCreditCards: Bool,
        notes: String,
        author: String,
        liked: Bool,
        numberOfLikes: Int,
        priceRange: String,
        createdAt: NSDate?,
        photoUrls: [NSURL],
        comments: [PersistedComment]
        )
    {
            self.id = id
            self.name = name
            self.address = address
            self.cuisineType = cuisineType
            self.cuisine = cuisine
            self.offersEnglishMenu = offersEnglishMenu
            self.walkInsOk = walkInsOk
            self.acceptsCreditCards = acceptsCreditCards
            self.notes = notes
            self.author = author
            self.liked = liked
            self.numberOfLikes = numberOfLikes
            self.priceRange = priceRange
            self.createdAt = createdAt
            self.photoUrls = photoUrls
            self.comments = comments
    }

    func newRetaurantWithLikeToggled() -> Restaurant {

        let updatedLikeStatus = !liked
        var updatedNumberOfLikes = numberOfLikes

        if updatedLikeStatus {
            updatedNumberOfLikes += 1
        } else {
            updatedNumberOfLikes -= 1
        }

        return Restaurant(
            id: self.id,
            name: self.name,
            address: self.address,
            cuisineType: self.cuisineType,
            cuisine: self.cuisine,
            offersEnglishMenu: self.offersEnglishMenu,
            walkInsOk: self.walkInsOk,
            acceptsCreditCards: self.acceptsCreditCards,
            notes: self.notes,
            author: self.author,
            liked: updatedLikeStatus,
            numberOfLikes: updatedNumberOfLikes,
            priceRange: self.priceRange,
            createdAt: self.createdAt,
            photoUrls: self.photoUrls,
            comments: self.comments
        )
    }
}

extension Restaurant: Equatable {}

func ==(lhs: Restaurant, rhs: Restaurant) -> Bool {
    return lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.address == rhs.address &&
        lhs.cuisineType == rhs.cuisineType &&
        lhs.cuisine == rhs.cuisine &&
        lhs.offersEnglishMenu == rhs.offersEnglishMenu &&
        lhs.walkInsOk  == rhs.walkInsOk &&
        lhs.acceptsCreditCards == rhs.acceptsCreditCards &&
        lhs.notes == rhs.notes &&
        lhs.author == rhs.author &&
        lhs.liked == rhs.liked &&
        lhs.numberOfLikes == rhs.numberOfLikes &&
        lhs.priceRange == rhs.priceRange &&
        lhs.createdAt == rhs.createdAt &&
        lhs.photoUrls == rhs.photoUrls
}
