import Foundation
import Nimble
import XCTest

@testable import Osusume

class RestaurantParserTest: XCTestCase {
    func test_convertingMultipleRestaurants() {
        let restaurantParser = RestaurantParser()

        let json: [[String: AnyObject]] = [
            [
                "name": "first restaurant",
                "id": 1,
                "address": "",
                "cuisine_type": "",
                "offers_english_menu": false,
                "walk_ins_ok": false,
                "accepts_credit_cards": false,
                "notes": "notes",
                "created_at": 1454480320,
                "user": ["name": "Bambi"],
                "photo_urls": [
                    ["url": "http://www.example.com"]
                ]
            ],
            [
                "name": "second restaurant",
                "id": 2,
                "address": "",
                "cuisine_type": "",
                "offers_english_menu": false,
                "walk_ins_ok": false,
                "accepts_credit_cards": false,
                "notes": "notes",
                "created_at": 1454480320,
                "user": ["name": "Bambi"],
                "photo_urls": [
                    ["url": "http://www.example.com"]
                ]
            ]
        ]

        let restaurants: [Restaurant] = restaurantParser.parseList(json).value!

        expect(restaurants.count).to(equal(2))
        expect(restaurants[0].name).to(equal("first restaurant"))
        expect(restaurants[1].name).to(equal("second restaurant"))
    }

    func test_convertingMultipleRestaurants_omittingRestaurantsWithBadData() {
        let restaurantParser = RestaurantParser()

        let json: [[String: AnyObject]] = [
            ["id": 1, "name": "first restaurant"],
            ["bad": "data"]
        ]

        let result = restaurantParser.parseList(json)
        expect(result.error).to(beNil())

        let restaurants = result.value!
        expect(restaurants.count).to(equal(1))
    }

    func test_convertingASingleRestaurant() {
        let restaurantParser = RestaurantParser()

        let json: [String: AnyObject] = [
            "name": "first restaurant",
            "id": 1,
            "address": "",
            "cuisine_type": "",
            "offers_english_menu": false,
            "walk_ins_ok": false,
            "accepts_credit_cards": false,
            "created_at": 1454480320,
            "user": ["name": "Bambi"],
            "photo_urls": [
                ["url": "http://www.example.com"],
                ["url": "my-awesome-url"]
            ],
            "comments": [
                [ "id": 1,
                  "content": "first comment",
                  "restaurant_id": 9
                ]
            ]
        ]

        let restaurant: Restaurant = restaurantParser.parseSingle(json).value!
        expect(restaurant.name).to(equal("first restaurant"))
        expect(restaurant.createdAt!).to(equal(NSDate(timeIntervalSince1970: 1454480320)))
        expect(restaurant.author).to(equal("Bambi"))
        expect(restaurant.photoUrls[0].URLString).to(equal("http://www.example.com"))
        expect(restaurant.photoUrls[1].URLString).to(equal("my-awesome-url"))
    }

    func test_convertingASingleRestaurant_onFailure() {
        let restaurantParser = RestaurantParser()

        let json: [String: AnyObject] = [ "bad": "data" ]

        let parseError: RestaurantParseError = restaurantParser.parseSingle(json).error!

        expect(parseError).to(equal(RestaurantParseError.InvalidField))
    }

    func test_convert_usesDefaultsWhenOptionalFieldsAreMissing() {
        let restaurantParser = RestaurantParser()
        let json: [String: AnyObject] = ["name": "first restaurant", "id": 1]


        let restaurant = restaurantParser.parseSingle(json).value!
        expect(restaurant.address).to(equal(""))
        expect(restaurant.walkInsOk).to(equal(false))
        expect(restaurant.createdAt).to(beNil())
    }

}
