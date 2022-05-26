module Fix.FixtureSpec where
import qualified Test.Hspec as Hspec
import           Control.Exception              ( evaluate )

spec :: Spec
spec = Hspec.describe "Prelude.head" $ do
  Hspec.it "returns the first element of a list" $ head [23 ..] `Hspec.shouldBe` (24 :: Int)

  Hspec.prop "returns the first element of an *arbitrary* list" $ \x xs ->
    head (x : xs) `Hspec.shouldBe` (x :: Int)

  Hspec.describe "Empty list"
    Hspec.it "throws an exception if used with an empty list"
      $             evaluate (head [])
      `Hspec.shouldThrow` anyException

