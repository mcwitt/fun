module Main where

import Control.Monad (guard)
import Data.List (delete)
import Data.List.NonEmpty (NonEmpty ((:|)))
import qualified Data.List.NonEmpty as NonEmpty
import qualified Data.Map as Map

perms :: Eq a => Int -> [a] -> [[a]]
perms _ [] = [[]]
perms 0 _ = [[]]
perms n xs = [x : p | x <- xs, p <- perms (n - 1) (delete x xs)]

fromDecimal :: NonEmpty Int -> Int
fromDecimal xs =
  sum $
    NonEmpty.zipWith
      (*)
      xs
      (do p <- 0 :| [1 ..]; pure $ 10 ^ p)

toDecimal :: Int -> NonEmpty Int
toDecimal =
  NonEmpty.unfoldr
    ( \n -> case n `divMod` 10 of
        (n', r) | n' == 0 -> (r, Nothing)
        (n', r) -> (r, Just n')
    )

splits :: [a] -> [(NonEmpty a, NonEmpty a)]
splits (x : x1 : xs) = (x :| [], x1 :| xs) : [(NonEmpty.cons x xs, ys) | (xs, ys) <- splits (x1 : xs)]
splits _ = []

hasDuplicates :: Eq a => NonEmpty a -> Bool
hasDuplicates xs = xs /= NonEmpty.nub xs

pandigitalProducts =
  Map.fromList $ do
    xs <- perms 5 [1 .. 9]
    (xs, ys) <- splits xs
    let a = fromDecimal xs
        b = fromDecimal ys
        c = a * b
        zs = toDecimal c
        ws = xs <> ys <> zs
    guard $ not (0 `elem` zs) && not (hasDuplicates ws) && length ws == 9
    pure (c, (a, b))

answer = sum $ Map.keys pandigitalProducts

main :: IO ()
main = print answer
