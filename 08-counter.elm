module Main exposing (main)

import Browser exposing (sandbox)
import Html exposing (Html, button, div, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)



-- We've added another new Msg value that we're going to call Reset.


type Msg
    = Increment
    | Decrement
    | Reset


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
            , button
                [ class "btn btn-danger", onClick Decrement ]
                [ text "-" ]

            -- We added a new button that will trigger an event
            -- that will pass the Reset value as a message to the
            -- update function.
            , button
                [ class "btn btn-default", onClick Reset ]
                [ text "Reset" ]
            ]
        ]



-- We added a new entry in the case expression that checks for if the message
-- is Reset. If it is, then the new model value will be 0.


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            model + 1

        Decrement ->
            model - 1

        Reset ->
            0


main : Program () Model Msg
main =
    sandbox
        { init = 0
        , view = view
        , update = update
        }
