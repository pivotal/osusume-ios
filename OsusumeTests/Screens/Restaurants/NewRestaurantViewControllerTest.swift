import XCTest
import Nimble
import BrightFutures
import Result
import BSImagePicker
import Photos

@testable import Osusume

class NewRestaurantViewControllerTest: XCTestCase {
    var newRestaurantVC: NewRestaurantViewController!
    var fakeRouter: FakeRouter!
    var fakeRestaurantRepo: FakeRestaurantRepo!
    var fakePhotoRepo: FakePhotoRepo!

    override func setUp() {
        UIView.setAnimationsEnabled(false)

        fakeRouter = FakeRouter()
        fakeRestaurantRepo = FakeRestaurantRepo()
        fakePhotoRepo = FakePhotoRepo()
        newRestaurantVC = NewRestaurantViewController(
            router: fakeRouter,
            restaurantRepo: fakeRestaurantRepo,
            photoRepo: fakePhotoRepo
        )

        newRestaurantVC.view.setNeedsLayout()
    }

    // MARK: - View Controller Lifecycle
    func test_viewDidLoad_initializesSubviews() {
        expect(self.newRestaurantVC.formView.findRestaurantButton).to(beAKindOf(UIButton))
        expect(self.newRestaurantVC.formView.findCuisineButton).to(beAKindOf(UIButton))
        expect(self.newRestaurantVC.formView.priceRangeButton).to(beAKindOf(UIButton))
    }

    // MARK: - Navigation Bar
    func test_viewDidLoad_setsTitle() {
        expect(self.newRestaurantVC.title).to(equal("Add Restaurant"))
    }

    // MARK: - Actions
    func test_tappingDoneButton_savesRestaurant() {
        newRestaurantVC.formView.nameTextField.text = "Some Restaurant"
        newRestaurantVC.formView.cuisineTypeValueLabel.text = "Restaurant Cuisine Type"
        newRestaurantVC.formView.notesTextField.text = "Notes"
        fakePhotoRepo.uploadPhotos_returnValue = ["apple", "truck"]


        let doneButton = newRestaurantVC.navigationItem.rightBarButtonItem!
        tapNavBarButton(doneButton)


        let newRestaurant = fakeRestaurantRepo.create_args
        expect(newRestaurant.name).to(equal("Some Restaurant"))
        expect(newRestaurant.address).to(equal(""))
        expect(newRestaurant.cuisineType).to(equal("Restaurant Cuisine Type"))
        expect(newRestaurant.offersEnglishMenu).to(equal(false))
        expect(newRestaurant.walkInsOk).to(equal(false))
        expect(newRestaurant.acceptsCreditCards).to(equal(false))
        expect(newRestaurant.notes).to(equal("Notes"))
        expect(newRestaurant.photoUrls).to(equal(["apple", "truck"]));
    }

    func test_tappingDoneButton_returnsToListScreen() {
        let doneButton = newRestaurantVC.navigationItem.rightBarButtonItem!


        tapNavBarButton(doneButton)
        NSRunLoop.osu_advance()


        expect(self.fakeRouter.dismissPresentedNavigationController_wasCalled).to(beTrue())
    }

    func test_tappingCancelButton_dismissesToListScreen() {
        let cancelButton = newRestaurantVC.navigationItem.leftBarButtonItem!


        tapNavBarButton(cancelButton)
        NSRunLoop.osu_advance()


        expect(self.fakeRouter.dismissPresentedNavigationController_wasCalled).to(beTrue())
    }

    func test_tappingFindRestaurantButton_showsFindRestaurantScreen() {
        tapButton(newRestaurantVC.formView.findRestaurantButton)


        expect(self.fakeRouter.showFindRestaurantScreen_wasCalled).to(beTrue())
    }

    func test_tappingFindCuisine_showsFindCuisineScreen() {
        tapButton(newRestaurantVC.formView.findCuisineButton)


        expect(self.fakeRouter.showFindCuisineScreen_wasCalled).to(beTrue())
    }

    func test_tappingPriceRange_showsPriceRangeListScreen() {
        tapButton(newRestaurantVC.formView.priceRangeButton)


        expect(self.fakeRouter.showPriceRangeListScreen_wasCalled).to(beTrue())
    }

    // MARK: - Find Restaurant
    func test_selectSearchResultRestaurant_populatesNameAndAddressTextfields() {
        let selectedSearchResultRestaurant = SearchResultRestaurant(
            id: "1",
            name: "Afuri",
            address: "Roppongi Hills 5-2-1"
        )


        newRestaurantVC.formView.searchResultRestaurantSelected(selectedSearchResultRestaurant)


        expect(self.newRestaurantVC.formView.nameTextField.text).to(equal("Afuri"))
        expect(self.newRestaurantVC.formView.addressTextField.text).to(equal("Roppongi Hills 5-2-1"))
    }

    // MARK: - Select Cuisine
    func test_selectCuisine_populatesCuisineTextfield() {
        let selectedCuisine = Cuisine(id: 1, name: "Hamburger")


        newRestaurantVC.formView.cuisineSelected(selectedCuisine)


        expect(self.newRestaurantVC.formView.cuisineTypeValueLabel.text).to(equal("Hamburger"))
    }

    func test_selectCuisine_setsSelectedCuisinePropertyValue() {
        let selectedCuisine = Cuisine(id: 1, name: "Hamburger")


        newRestaurantVC.formView.cuisineSelected(selectedCuisine)


        expect(self.newRestaurantVC.formView.selectedCuisine).to(equal(selectedCuisine))
    }

    // MARK: - Price Range
    func test_selectPriceRange_populatesPriceRangeTextfield() {
        let selectedPriceRange = PriceRange(id: 1, range: "0~999")


        newRestaurantVC.formView.priceRangeSelected(selectedPriceRange)


        expect(self.newRestaurantVC.formView.priceRangeValueLabel.text).to(equal("0~999"))
    }

    func test_selectPriceRange_setsSelectedPriceRangePropertyValue() {
        let selectedPriceRange = PriceRange(id: 1, range: "0~999")


        newRestaurantVC.formView.priceRangeSelected(selectedPriceRange)


        expect(self.newRestaurantVC.formView.selectedPriceRange).to(equal(selectedPriceRange))
    }
}
