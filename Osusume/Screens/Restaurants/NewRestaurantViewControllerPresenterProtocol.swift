protocol NewRestaurantViewControllerPresenterProtocol {
    func showFindCuisineScreen(delegate: CuisineSelectionDelegate)
    func showFindRestaurantScreen(delegate: SearchResultRestaurantSelectionDelegate)
    func showPriceRangeScreen(delegate: PriceRangeSelectionDelegate)
}
