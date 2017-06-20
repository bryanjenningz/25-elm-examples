module Main exposing (..)

import Html exposing (Html, text)

-- We can also declare what type each value is. Since the main value is just
-- an HTML text node, it has the type (Html msg). If the value isn't that type,
-- then we will get a compile error, which is helpful for guaranteeing our
-- program is correct. Type declarations aren't required, but most people like
-- writing type declarations so their code is easier to understand.
main : Html msg
main =
    text "Hello, World!"
