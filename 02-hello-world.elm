module Main exposing (main)

-- We are now importing the Html type constructor from the Html module so that
-- we can use it to annotate the main value's type.

import Html exposing (Html, text)



-- In Elm, we can explicitly say what any value's type is. Since the main value
-- is just an HTML text node, it has the type (Html msg). If the value isn't
-- that type, then we will get a compile error, which is helpful for
-- guaranteeing our program is correct. Type declarations aren't required, but
-- most people like writing type declarations so their code is easier to understand.


main : Html msg
main =
    text "Hello, World!"
