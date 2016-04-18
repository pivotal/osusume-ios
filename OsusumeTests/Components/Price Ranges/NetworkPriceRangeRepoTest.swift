import XCTest
import BrightFutures
import Result
import Nimble
@testable import Osusume

class FakePriceRangeListParser: DataListParser {
    typealias ParsedObject = [PriceRange]

    var parse_arg: [[String : AnyObject]]!
    var parse_returnValue = Result<[PriceRange], ParseError>(value: [])
    func parse(json: [[String : AnyObject]]) -> Result<[PriceRange], ParseError> {
        parse_arg = json
        return parse_returnValue
    }
}

class NetworkPriceRangeRepoTest: XCTestCase {
    let fakeHttp = FakeHttp()
    let fakePriceRangeListParser = FakePriceRangeListParser()
    var priceRangeRepo: PriceRangeRepo!
    let promise = Promise<AnyObject, RepoError>()

    override func setUp() {
        fakeHttp.get_returnValue = promise.future

        priceRangeRepo = NetworkPriceRangeRepo(
            http: fakeHttp,
            parser: fakePriceRangeListParser
        )
    }

    func test_getAll_hitsExpectedEndpoint() {
        priceRangeRepo.getAll()


        expect(self.fakeHttp.get_args.path).to(equal("/priceranges"))
    }

    func test_getAll_parsesHttpOutputJson() {
        priceRangeRepo.getAll()

        let httpReturnValue = [
            [
                "id" : 1,
                "range" : "Price Range #1"
            ],
            [
                "id" : 2,
                "range" : "Price Range #2"
            ]
        ]
        promise.success(httpReturnValue)

        NSRunLoop.osu_advance()

        expect(self.fakePriceRangeListParser.parse_arg).to(equal(httpReturnValue))
    }

    func test_getAll_returnsParsedPriceRangeResult() {
        let getAllPriceRangesFuture = priceRangeRepo.getAll()
        let expectedPriceRangeList: [PriceRange] = [
            PriceRange(id: 1, range: "Price Range #1"),
            PriceRange(id: 2, range: "Price Range #2")
        ]
        fakePriceRangeListParser.parse_returnValue = Result.Success(expectedPriceRangeList)
        promise.success([[:]])


        NSRunLoop.osu_advance()


        expect(getAllPriceRangesFuture.value).to(equal(expectedPriceRangeList))
    }
}