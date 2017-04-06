module Main exposing (..)

import Html exposing (Html, button, div, br, label, text, input)
import List exposing (map)
import Material
import Material.Scheme
import Common exposing(Msg(..))
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
  { selection = Maybe.Nothing
  , mdl = Material.model
  , config = {
      prompt = "Which number is the greatest?"
      , choices = [
          {label = "One", value = "One"}
            , { label = "Two", value = "Two" }
            , { label = "Three", value = "Three" }
            , { label = "Four", value = "Four" }
      ]
    }
  }


-- UPDATE

type alias Mdl =
    Material.Model


update : Msg -> Model -> Model
update msg model =
    case msg of
        Toggle value selected ->
            { config = model.config
            , selection = if selected then Maybe.Nothing else Maybe.Just value
            , mdl = model.mdl
            }

        Mdl msg_ ->
            { config = model.config
            , selection = model.selection
            , mdl = model.mdl
            }

isSelected : String -> Selection -> Bool 
isSelected v s = 
    case s of 
        Just selected -> selected == v 
        Nothing -> False

mkRadio : Selection -> Mdl -> Choice -> Html Msg 
mkRadio selection mdl choice =  
  radio choice (isSelected choice.value selection) mdl

view : Model -> Html Msg
view model =
  div []
    [ div [] [ text (model.config.prompt) ]
    , div [] (map (mkRadio model.selection model.mdl) model.config.choices)
    ] 
    |> Material.Scheme.top


