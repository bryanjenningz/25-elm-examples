-- This is how you write single-line comments in Elm.

{-
  This is how you
  write multi-line comments
  in Elm.
-}

-- This is how you declare what your module name is and what values to export.
-- We've chosen to name our module Main and we are exporting all of the
-- module's values.
module Main exposing (..)

-- We're importing the Html module and we're making the Html and text values
-- global to our file, so we can just reference them as Html and text if we want.
import Html exposing (Html, text)


-- The main value manages what gets displayed on the page. If we set the main
-- value to (text "Hello, World!"), then a text node with the string "Hello, World!"
-- will display on the page.
main =
    text "Hello, World!"
