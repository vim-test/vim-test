module Fix2.FixtureSpec (spec) where
import           Test.Hspec
import           Control.Exception              ( evaluate )

spec :: Spec
spec = describe "Prelude.head" $ do
  it "returns the first element of a list" $ head [23 ..] `shouldBe` (24 :: Int)

  prop "returns the first element of an *arbitrary* list" $ \x xs ->
    head (x : xs) `shouldBe` (x :: Int)

  describe "Empty list"
    it "throws an exception if used with an empty list"
      $             evaluate (head [])
      `shouldThrow` anyException

