{-# LANGUAGE OverloadedStrings #-}
module Main (main) where

import qualified Data.Map.Strict as Map
import qualified Data.Text as Text
import Nagare.Dsl.Access (requireLogin)
import qualified Nagare.Dsl.Application as App
import Nagare.Dsl.Build (BuildSpec (PrebuiltImage), mkTag)
import Nagare.Dsl.Config (emitApplication)
import Nagare.Dsl.Presets (webService)
import qualified Nagare.Dsl.Types as D
import System.Environment (lookupEnv)

application :: Text.Text -> Either Text.Text App.Application
application release = do
  if Text.length release == 16 && Text.take 4 release == "git-" && Text.all (`elem` ("0123456789abcdef" :: String)) (Text.drop 4 release)
    then Right () else Left "DOCS_IMAGE_TAG must be git- followed by the 12 lowercase hexadecimal characters of a clean source revision"
  tag <- mkTag release
  service <- webService "okf-profiles" "okf-profiles-web"
  name <- D.mkServiceName "okf-profiles"
  namespace <- D.mkNamespace "personal"
  image <- D.mkImageRef "okf-profiles-web"
  domains <- D.mkDomains [("okf-profiles.labs.topagentnetwork.net", True)]
  health <- D.httpHealthCheck "/healthz"
  scale <- D.mkScale 0 2
  let deployment = service { D.namespace = namespace, D.build = PrebuiltImage tag, D.domains = domains, D.healthCheck = Just health, D.scale = Just scale, D.access = Just requireLogin }
  App.mkApplication App.Application
    { App.name = name
    , App.logicalKey = Nothing
    , App.namespace = namespace
    , App.image = image
    , App.env = Map.empty
    , App.databases = []
    , App.brokers = []
    , App.access = Just requireLogin
    , App.service = Just deployment
    , App.workers = []
    , App.tasks = []
    }

main :: IO ()
main = do
  value <- lookupEnv "DOCS_IMAGE_TAG"
  case value of
    Nothing -> ioError (userError "DOCS_IMAGE_TAG is required; use nix eval --raw .#lib.docsImageTag")
    Just release -> either (ioError . userError . Text.unpack) emitApplication (application (Text.pack release))
