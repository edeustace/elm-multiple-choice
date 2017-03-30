module Main exposing (..)

import Html exposing (Html, button, div, br, label, text, input)
import Html.Attributes exposing (style, name, type_, value, checked)
import Html.Events exposing (onClick)
import List exposing (map)
import Material
import Material.Scheme
import Material.Button as Button
import Material.Options as Options exposing (css)
import Radio exposing(radio, Choice)

main =
    Html.beginnerProgram
        { model = model
        , view = view
        , update = update
        }

type alias Selection = Maybe String

-- MODEL


type alias Config =
    { prompt : String
    , choices : List Choice
    }

type alias Model =
    { config : Config
    , selection : Selection
    , mdl : Material.Model
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
    , mdl = Material.model
    }



-- UPDATE


type Msg
    = Choose (Maybe String)
    | Mdl (Material.Msg Msg)
    | RM (Radio.Msg)


type alias Mdl =
    Material.Model


update : Msg -> Model -> Model
update msg model =
    case msg of
        Choose (Just value) ->
            { config = model.config
            , selection = Maybe.Just value
            , mdl = model.mdl
            }

        Choose Nothing ->
            { config = model.config
            , selection = Nothing
            , mdl = model.mdl
            }

        Mdl msg_ ->
            { config = model.config
            , selection = model.selection
            , mdl = model.mdl
            }

getMsg : Radio.Model -> Selection -> Radio.Msg
getMsg c s =
    case (isSelected c s) of
      True -> Radio.Deselect 
      False -> Radio.Select c.choice.value 

isSelected : Radio.Model -> Selection -> Bool 
isSelected c s = 
    case s of 
        Just v -> v == c.choice.value 
        Nothing -> False

renderChoice : Selection -> Radio.Model -> Html Radio.Msg
renderChoice s c =
    radio c (isSelected c s) (getMsg c s)

toRadioModel : Material.Model -> Choice -> Radio.Model 
toRadioModel mdl c =  {mdl = mdl, choice = c}
  
view : Model -> Html Radio.Msg
view model =
  div []
    [ div [] [ text (model.config.prompt) ]
    , div [] (map (renderChoice model.selection) (map (toRadioModel model.mdl) model.config.choices))
    ] 


