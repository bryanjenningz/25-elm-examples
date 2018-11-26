module Main exposing (main)

-- I'm importing the Html.Attributes module, which has all the HTML attributes
-- we need. I'm exposing the class attribute, which we can use for adding classes
-- to HTML elements.

import Html exposing (Html, div, text)
import Html.Attributes exposing (class)



-- Now the main value has a div element which has a class of "text-center". Since
-- we're using Bootstrap, this will make it so the child text node is centered. So
-- now the "Hello, World!" message is centered.


main : Html msg
main =
    div [ class "text-center" ] [ text "Hello, World!" ]
