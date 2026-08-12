import XCTest

@testable import SimpleProject

/// Localisation lookup, including the fallback that keeps unsupported locales
/// rendering something sensible.
final class StringsTests: XCTestCase {

    private func strings(_ identifier: String) -> Strings {
        Strings.forLocale(Locale(identifier: identifier))
    }

    func testEveryShippedLanguageIsTranslated() {
        let english = strings("en_US")
        for identifier in ["es_ES", "de_DE", "ja_JP", "ar_EG"] {
            XCTAssertNotEqual(strings(identifier).appTitle, english.appTitle,
                              "\(identifier) should not fall back to English")
        }
    }

    func testUnsupportedLocaleFallsBackToEnglish() {
        XCTAssertEqual(strings("is_IS").appTitle, strings("en_US").appTitle)
    }

    func testRegionalVariantsResolveToTheirLanguage() {
        XCTAssertEqual(strings("es_MX").appTitle, strings("es_ES").appTitle)
    }
}
