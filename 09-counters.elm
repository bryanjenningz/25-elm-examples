module Main exposing (main)

import Browser exposing (sandbox)
import Html exposing (Html, button, div, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)



-- Before, we had just one counter, but now we are working with multiple
-- counters.
-- Before, we had the Msg type as Increment, which was enough information for
-- us to know that we can increment our counter. Now that we have multiple
-- counters, we need to pass information about which counter we want to
-- increment. So now we have (Increment Int) as our Msg type, where the Int
-- value will indicate the index of the counter we want to increment. So if we
-- want to increment the counter at index 0, we can have the onClick event
-- trigger the message (Increment 0). If we want to increment the counter at
-- index 1, we can trigger the message (Increment 1).


type Msg
    = Increment Int



-- We've changed the Model alias so that it's a list of integers. Each integer
-- represents a counter's count in a list of counters.


type alias Model =
    List Int



-- This is a function that takes the index value, the count value, and returns
-- the HTML that represents the counter. When the button is clicked, it will
-- trigger an onClick event which will pass (Increment index) as the message to
-- the update function. The index value is the index that the button is at in
-- the list of buttons.


viewCount : Int -> Int -> Html Msg
viewCount index count =
    div [ class "mb-2" ]
        [ text (String.fromInt count)
        , button
            [ class "btn btn-primary", onClick (Increment index) ]
            [ text "+" ]
        ]



-- The view function returns a div element that has a list of counters
-- as its child. The List.indexedMap function takes a function and a list
-- and returns a mapped version of the list that it took as an argument.
-- List.indexedMap is similar to Array.prototype.map in JavaScript.
-- The list index will get passed as the first argument to the function and
-- the list value will get passed as the second argument to the function.


view : Model -> Html Msg
view model =
    div [ class "text-center" ]
        (List.indexedMap viewCount model)



-- We only need to deal with one type of message which is the (Increment Int)
-- value message. Whenever a counter is clicked, it will trigger an event which
-- passes the (Increment Int) value into the update function.
-- We map the model, which is a list and we update the value at the index that
-- got clicked by using the List.indexedMap function.


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment index ->
            List.indexedMap
                (\i count ->
                    if i == index then
                        count + 1

                    else
                        count
                )
                model



-- We set the model value to initially be [ 0, 0 ], so our view will display
-- 2 counters that each have the value 0 in the beginning.


main : Program () Model Msg
main =
    sandbox
        { init = [ 0, 0 ]
        , view = view
        , update = update
        }
