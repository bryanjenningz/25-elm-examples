module Main exposing (main)

import Browser exposing (sandbox)
import Html exposing (Html, button, div, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)



-- We've added a new value called Decrement that is type Msg.
-- Think of the Msg type as a type that can either be Increment
-- or it can be Decrement. We use "|" between all the possible values a Msg type can be.


type Msg
    = Increment
    | Decrement


type alias Model =
    Int


view : Model -> Html Msg
view model =
    div [ class "text-center" ]
        [ div [] [ text (String.fromInt model) ]
        , div [ class "btn-group" ]
            [ button
                [ class "btn btn-primary", onClick Increment ]
                [ text "+" ]

            -- We added a new button that will trigger a Decrement
            -- value as the message when the button is clicked. The
            -- Decrement value will get passed into the update function
            -- whenever this button gets clicked.
            , button
                [ class "btn btn-danger", onClick Decrement ]
                [ text "-" ]
            ]
        ]



-- Now that there are 2 possible Msg values, we added a new entry to the case
-- expression that deals with messages that are equal to the Decrement value.
-- When the message is a Decrement value, the new model value that's returned
-- is one less than what it was. After the new model state is returned, the view
-- function will get passed the new model value and return the new HTML, which
-- will get displayed for the user to see.


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            model + 1

        Decrement ->
            model - 1


main : Program () Model Msg
main =
    sandbox
        { init = 0
        , view = view
        , update = update
        }
