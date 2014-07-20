{-

hSolve2048
A Haskell implementation of an expetimax solver for 2018.

Bill Murphy

last update:
2014-07-19

Please consult the file README for further information
on this program.

-}

module Solve2048 where

import Prelude hiding (Left, Right)
import Data.List (genericLength, sortBy)
import Data.Ord (comparing)
import System.IO (hSetBuffering, stdin, BufferMode(..))

import H2048 hiding (gameLoop, main)


type Probability = Double
type Utility = Double
type Distribution a = [(Probability, a)]

expectedUtility :: (a -> Utility) -> Distribution a -> Utility
expectedUtility utility = sum . map expected
    where expected x = (fst x) * (utility $ snd x)

data EXTree a = DecisionNode a [EXTree a]
              | RandomNode a (Distribution (EXTree a))
              | Leaf a
              deriving (Show, Eq)

currentState :: EXTree a -> a
currentState node = case node of
        Leaf state           -> state
        RandomNode state _   -> state
        DecisionNode state _ -> state

bestChoice :: (Eq a) => (a -> Utility) -> EXTree a -> a
bestChoice utils node = case node of
        Leaf state             -> state
        RandomNode state _     -> state
        DecisionNode state ds  -> currentState . bestTree . filtered state $ ds
    where filtered s = filter (\x -> currentState x /= s)
          bestTree   = head . reverse . sortBy (comparing $ treeUtility utils)

treeUtility :: (a -> Double) -> EXTree a -> Double
treeUtility utility node = case node of
        Leaf state        -> utility state
        RandomNode _ dist -> expectedUtility (treeUtility utility) dist
        DecisionNode _ ds -> maximum $ map (treeUtility utility) ds

buildEXTree :: (a -> Bool) -> (a -> [a]) -> (a -> Distribution a) -> Int -> a -> EXTree a
buildEXTree movesLeft allMoves allEvents depth state
    | (not $ movesLeft state) || (depth <= 0) = Leaf state
    | otherwise                               = options state
    where options s = DecisionNode s . map runEnvironment . allMoves $ s
          runEnvironment s = RandomNode s . map next . allEvents $ s
          next (p, s) = (p, buildEXTree movesLeft allMoves allEvents (depth-1) s)

heuristicGridValue :: Grid -> Utility
heuristicGridValue grid
    | check2048 grid = 10 ** 100
    | otherwise      = fromIntegral . sum . map (^2) . concat $ grid

placeDistribution :: Grid -> Distribution Grid
placeDistribution grid = concat . map spotDistribution . getZeroes $ grid
    where spotDistribution spot = [(0.9 / numSpots, setSquare grid spot 2),
                                   (0.1 / numSpots, setSquare grid spot 4)]
          numSpots = genericLength . getZeroes $ grid

nextMoves :: Grid -> [Grid]
nextMoves grid = map (flip move $ grid) [Up, Down, Left, Right]

gameLoop :: Grid -> IO ()
gameLoop grid
    | isMoveLeft grid = do
        printGrid grid
        if check2048 grid
        then putStrLn "You won!"
        else let new_grid = bestDir . build2048Tree $ grid
             in if grid /= new_grid
                then addTile new_grid >>= gameLoop
                else gameLoop grid
    | otherwise = do
        printGrid grid
        putStrLn "Game over"
    where build2048Tree = buildEXTree isMoveLeft nextMoves placeDistribution 2
          bestDir = bestChoice heuristicGridValue

main :: IO ()
main = do
    hSetBuffering stdin NoBuffering
    grid <- start
    gameLoop grid
