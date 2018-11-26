module Main exposing (main)

-- We've exposed 3 new values: sandbox, button, and onClick.
-- The first one is sandbox, which will allow us to write an interactive
-- application instead of just static HTML like before. We've also exposed
-- the button function, which will be displayed as a button element.
-- We are exposing the onClick function from the Html.Events module. We use
-- this similarly to how we use the onclick attribute in native HTML.

import Browser exposing (sandbox)
import Html exposing (Html, button, div, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)



-- We created a new type that we're calling Msg. The Msg type can only be
-- the value Increment.


type Msg
    = Increment



-- We are creating a type alias called Model. Type aliases don't create a new
-- type, they just make it so the program is easier to understand.


type alias Model =
    Int



-- This is the view function. The view function takes the model, which is an
-- integer, then returns an HTML element, which gets displayed on the screen.
-- Every time the model gets updated, the new value for the model will get passed
-- into the view function, which will output the HTML display.
-- So the view function is simply just a pure function that takes in the model
-- state as an argument and returns the HTML view that gets displayed on the page.


view model =
    div [ class "text-center" ]
        [ div [] [ text (String.fromInt model) ]
        , button
            -- The onClick function takes Increment value and will trigger an event
            -- whenever the user clicks on the button.
            -- When an event is triggered, the message value gets passed to the update
            -- function, then the update function returns the new model state.
            -- So whenever a user clicks the button, the onClick event will get triggered
            -- which will pass the Increment value to the update function.
            [ class "btn btn-primary", onClick Increment ]
            [ text "+" ]
        ]



-- The update function will get called whenever an event is triggered. The message value
-- will be passed in as the first value and the current model state will be passed in as
-- the second value. The update function returns the new model state, which will be passed
-- into the view function.


update msg model =
    -- Here we're using a case expression, which is similar to a switch statement in
    -- JavaScript. We are checking to see what value the msg argument is. If the msg
    -- argument is Increment, then we're going to return the model value plus one. So
    -- we are effectively incrementing the model's value by one. This new model value will
    -- be passed into the view function and the view function will return the new HTML
    -- that gets rendered to the page.
    case msg of
        Increment ->
            model + 1



-- We've changed the main value so now instead of being static HTML, it's a sandbox
-- program. We use the sandbox function and pass in a record. The record has
-- to have 3 properties: init, view, and update. The init property is the initial
-- value that the model is set to. The view property is the view function which takes
-- the model and returns the displayed HTML, and the update property is a function
-- that takes a message and the model as arguments and returns the new model.
-- Initially, the model will be passed to the view function as an argument and the
-- view function will return the HTML. The sandbox will handle displaying
-- that HTML to the page so the user can see and interact with that HTML. If the user
-- triggers any events like the onClick event we have, the message and the model will
-- get passed to the update function and then the update function will return the new
-- model. Now that the model is different, the view function will get passed the new
-- model value and return the new HTML. That new HTML will get displayed on the screen.


main =
    sandbox
        { init = 0
        , view = view
        , update = update
        }
