module Lib
    ( someFunc
    ) where

import Control.Concurrent.Async

someFunc :: IO ()
someFunc = do
  w <- pooledCheck 2
  if w == 2
    then putStrLn "Success"
    else putStrLn "Bug in implementation"

check :: Int -> Int -> IO Int
check step = go
  where
    go n =
      if even n
        then return n
        else go (n + step)

pooledCheck :: Int -> IO Int
pooledCheck step = do
  let f = check step
  either id id <$> race (f 1) (f 2)


-- pooledCheck :: Int -> IO Int
-- pooledCheck step = do
--   let checkers = Concurrently . check step <$> [1 .. step]
--   runConcurrently (asum checkers)



-- check :: Int -> Int -> Int
-- check step = go
--   where
--     go n =
--       if even n
--         then n
--         else go (n + step)

-- pooledCheck :: Int -> IO Int
-- pooledCheck step = do
--   let checkers = Concurrently . pure . check step <$> [1 .. step]
--   runConcurrently (asum checkers)




-- pooledCheck :: Int -> IO Int
-- pooledCheck step = do
--   let f = pure . check step
--   either id id <$> race (f 1) (f 2)


-- stopValue :: Int
-- stopValue = 16 + 1

-- someFunc :: IO ()
-- someFunc = do
--   w <- pooledGeneration 0
--   if w == stopValue
--     then putStrLn "Success"
--     else putStrLn "Bug in implementation"


-- checkWork :: Int -> Int -> Int
-- checkWork step = go
--   where
--     go nonce =
--       if nonce == stopValue
--         then nonce
--         else go (nonce + step)


-- pooledGeneration :: Int -> IO Int
-- pooledGeneration nonce = do
--   step <- max 1 <$> getNumCapabilities
--   let checkers =
--         fmap (Concurrently . pure . checkWork step . (+ nonce)) [0 .. step - 1]
--   runConcurrently (asum checkers)



-- someFunc :: IO ()
-- someFunc = do
--   w <- pooledGeneration 0x1E6B3B4C936D10B0
--   if w == 0x1e6b3b4c936d327e
--     then putStrLn "Success"
--     else putStrLn "Bug in implementation"


-- checkWork :: Word64 -> Word64 -> Word64
-- checkWork step = go
--   where
--     go nonce =
--       if nonce == 0x1e6b3b4c936d327e
--         then nonce
--         else go (nonce + step)


-- pooledGeneration :: Word64 -> IO Word64
-- pooledGeneration nonce = do
--   n <- max 1 <$> getNumCapabilities
--   let step = fromIntegral n
--       checkers =
--         fmap (Concurrently . pure . checkWork step . (+ nonce)) [0 .. step - 1]
--   runConcurrently (asum checkers)
