module Main exposing (main)

-- We are now exposing the div function.

import Html exposing (Html, div, text)



-- We've made it so the main value isn't just a text node anymore. It's now
-- a div element with a text node as a child. The Html module has all the
-- HTML elements you need. Each HTML element takes 2 arguments which are both
-- lists. The first list is a list of attributes, the second list is a list of
-- child HTML elements. We can nest elements the same way we normally do with
-- HTML.


main : Html msg
main =
    div [] [ text "Hello, World!" ]


-- Instructions on how to get to lesson 4:
{-
In the html functions provided by elm, you can often add html attributes.
See here: https://package.elm-lang.org/packages/elm/html/latest/Html-Attributes#class

The div method accepts a list of attributes as its first parameter. With that in mind,
let us give this div a particular class: "text-center" - because we want to center that text.

Please review the docoumentation pasted to ensure you understand what is going on, 
and we'll see you in lesson 4.
-}


