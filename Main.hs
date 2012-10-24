-- Copyright © 2012 Julian Blake Kongslie <jblake@omgwallhack.org>
-- Licensed under the MIT license.

{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}

module Main
where

import Control.Monad
import Data.Conduit.Network hiding
  ( Application
  )
import qualified Data.ByteString.Lazy as LBS
import Data.Text hiding
  ( length
  )
import Data.Text.Encoding
import Data.Text.Read
import Network.HTTP.Types
import Network.Wai
import Network.Wai.Handler.Warp
import Network.Wai.Middleware.Gzip
import Network.Wai.Middleware.RequestLogger
import Prelude hiding
  ( concat
  , null
  )

import FizzBuzz

main :: IO ()
main = flip runSettings fbApp $ defaultSettings
  { settingsHost = HostAny
  , settingsPort = 8080
  }

fbApp :: Application
fbApp = gzip def $ logStdoutDev $ realApp
  where

    realApp :: Application
    realApp (Request {..}) | requestMethod == methodGet && length pathInfo == 2 && pathInfo !! 0 == "fizzbuzz" = return $ fb $ pathInfo !! 1
                           | otherwise                                                                         = return $ responseLBS notFound404 [] LBS.empty

fb :: Text -> Response
fb params =
  case readParams params of
    Just (l, h) -> responseLBS ok200 [("Content-type", "text/plain")] $ LBS.fromChunks [ encodeUtf8 $ concat [ pack $ fizzbuzz n | n <- [l..h] ] ]
    _ -> responseLBS internalServerError500 [] $ LBS.empty

readParams :: Text -> Maybe (Integer, Integer)
readParams t = do
  (l, t') <- getInteger t
  guard $ l /= 0
  (c, t'') <- uncons t'
  guard $ c == ','
  (h, t''') <- getInteger t''
  guard $ h /= 0
  guard $ null t'''
  guard $ l <= h
  return $ (l, h)

  where

    getInteger x = case decimal x of
      Right (i, x') -> return (i, x')
      _ -> Nothing
