module MultipleChoiceExample exposing (..)

import MultipleChoice exposing(..)
import ControlBar exposing(..)

import Html exposing (Html, button, div, br, hr, label, text, input)

main =
    Html.beginnerProgram
        { model = model
        , view = view
        , update = update
        }

type alias Model = {
  mc : MultipleChoice.Data,
  selected: Maybe String,
  formDisabled: Bool
} 

type Msg 
  = Toggle String Bool 
  | ToggleDisable


model = { 
  mc = { 
  prompt = "hi prompt"
  , choices = [
    { label = "one" , value = "one"}
    , {label = "two", value = "two" }]}
    , selected = Just "one" 
    , formDisabled = False
  }

update : Msg -> Model -> Model
update msg model =
    case msg of
        Toggle value selected -> 
          let 
            newSelection = if selected then Nothing else Just value
          in  
            { model | selected = newSelection }
        ToggleDisable -> 
          { model | formDisabled = not model.formDisabled} 


view : Model -> Html Msg
view model = 
  div [] [ text "mc below"
  , hr [] []
  , ControlBar.view ToggleDisable model.formDisabled
  , MultipleChoice.view model.mc model.selected model.formDisabled Toggle 
  ]
