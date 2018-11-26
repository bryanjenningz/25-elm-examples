module Main exposing (main)

-- We're exposing the value attribute.
-- We're exposing the onInput event type.

import Browser exposing (sandbox)
import Html exposing (Html, div, input, text)
import Html.Attributes exposing (class, value)
import Html.Events exposing (onInput)



-- We have a Msg type that can be the value (UpdateText String).


type Msg
    = UpdateText String



-- We made our model type a record that has a property called text.
-- The text property has to be a String type.
-- For example, our model can be the value { text = "hello" }.
-- Records are similar to objects in JavaScript.


type alias Model =
    { text : String }



-- We have an input box that listens for an onInput event. When a user
-- types in the input box, an onInput event will get triggered and the input
-- box's text value will get passed with the UpdateText as a string. That's
-- why the Msg type has the value (UpdateText String). The string that gets
-- passed along with the message to the update function is the string of
-- text that's in the input box.
-- We display the model.text value in a div element underneath the input box.


view : Model -> Html Msg
view model =
    div [ class "text-center" ]
        [ input [ onInput UpdateText, value model.text ] []
        , div [] [ text model.text ]
        ]



-- We just have to handle one case for our message. All we do is set the
-- text property in the model to the string that is currently in the input box.


update : Msg -> Model -> Model
update msg model =
    case msg of
        UpdateText newText ->
            { model | text = newText }



-- We set the initial model value to { text = "" }, so the input box value
-- is initially an empty string.


main : Program () Model Msg
main =
    sandbox
        { init = { text = "" }
        , view = view
        , update = update
        }
