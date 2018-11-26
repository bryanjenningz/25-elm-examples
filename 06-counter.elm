module Main exposing (main)

import Browser exposing (sandbox)
import Html exposing (Html, button, div, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)


type Msg
    = Increment


type alias Model =
    Int



-- I added the type declaration to the view function so it's easier to understand.
-- The view function takes a Model type and returns HTML.


view : Model -> Html Msg
view model =
    div [ class "text-center" ]
        [ div [] [ text (String.fromInt model) ]
        , button
            [ class "btn btn-primary", onClick Increment ]
            [ text "+" ]
        ]



-- The type declaration for the update function means that the update function takes
-- a Msg type and a Model type and then returns a Model type.


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            model + 1



-- The main value is a Program type which doesn't have any flags, so the flags value
-- is of type (). We'll talk more about flags later. For now, just know that we
-- aren't using them, so we give them type (). Our model is of type Model and our
-- message type is of type Msg. It's okay if this doesn't make much sense right now,
-- you'll get used to these type declarations as you write more Elm code.


main : Program () Model Msg
main =
    sandbox
        { init = 0
        , view = view
        , update = update
        }
