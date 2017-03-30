module Main exposing (..)

import Html exposing (Html, button, div, br, label, text, input)
import Html.Attributes exposing (style, name, type_, value, checked)
import Html.Events exposing (onClick)
import List exposing (map)

m : Config -> Model 
m f = {config = f, selection = Maybe.Nothing}

-- This demonstrates rendering the elm component with external data
init : Config -> (Model ,Cmd  Msg)
init flags = (m flags, Cmd.none) 

main : Program Config Model Msg
main =
    Html.programWithFlags
        { init = init
        , subscriptions = always Sub.none
        , view = view
        , update = update
        }



-- MODEL


type alias Choice =
    { label : String
    , value : String
    }


type alias Config =
    { prompt : String
    , choices : List Choice
    }


type alias Selection =
    Maybe String


type alias Model =
    { config : Config
    , selection : Selection
    }


model : Model
model =
    { config =
        { prompt = "Which number is the greatest?"
        , choices =
            [ { label = "One", value = "One" }
            , { label = "Two", value = "Two" }
            , { label = "Three", value = "Three" }
            , { label = "Four", value = "Four" }
            ]
        }
    , selection = Maybe.Nothing
    }

-- UPDATE


type Msg
    = Choose (Maybe String)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Choose (Just value) ->
            ({ config = model.config
            , selection = Maybe.Just value
            }, Cmd.none)

        Choose Nothing ->
            ({ config = model.config
            , selection = Nothing
            }, Cmd.none)


getMsg : Choice -> Selection -> Msg
getMsg c s =
    case s of
        Just value ->
            Choose Nothing

        Nothing ->
            Choose (Just c.value)


radio : Choice -> Selection -> msg -> Html msg
radio c s msg =
    label
        [ style [ ( "padding", "5px" ), ( "display", "block" ) ]
        ]
        [ input [ checked (s == (Just c.value)), type_ "radio", name "groupname", value c.value, onClick msg ] []
        , text c.label
        ]


renderChoice : Selection -> Choice -> Html Msg
renderChoice s c =
    radio c s (getMsg c s)


view : Model -> Html Msg
view model =
    div []
        [ div [] [ text (model.config.prompt) ]
          -- , div [] [ text (toString model.selection) ]
        , div [] (map (renderChoice model.selection) model.config.choices)
        ]
