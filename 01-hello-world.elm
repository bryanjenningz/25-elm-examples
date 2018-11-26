-- This is how you write single-line comments in Elm.
{-
   This is how you
   write multi-line comments
   in Elm.
-}
-- This is how you declare what your module name is and what values it exports.
-- We've chosen to name our module Main and we are exporting the value main that
-- we have defined below.


module Main exposing (main)

-- We're importing the Html module the text value available in our file, so we
-- can just reference it if we want.

import Html exposing (text)



-- The main value manages what gets displayed on the page. If we set the main
-- value to (text "Hello, World!"), then a text node with the string "Hello, World!"
-- will display on the page.


main =
    text "Hello, World!"
