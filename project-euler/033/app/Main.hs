module Main where

import Data.Ratio (denominator, (%))

digitCancellingFractions :: [(Integer, Integer)]
digitCancellingFractions =
  [ (n, d)
    | d <- [11 .. 99],
      d `mod` 10 /= 0,
      n <- [1 .. d],
      (n', d') <- cancel (digits n) (digits d),
      n' % d' == n % d
  ]
  where
    digits = (`divMod` 10)
    cancel (a, b) (c, d)
      | a == c = [(b, d)]
      | b == d = [(a, c)]
      | a == d = [(b, c)]
      | b == c = [(a, d)]
      | otherwise = []

main :: IO ()
main = do
  let ans = denominator (product [n % d | (n, d) <- digitCancellingFractions])
  print ans
