module MultipleChoiceExample exposing (..)

import List exposing (map)
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
  formDisabled: Bool
} 

type Msg 
  = Toggle String Bool 
  | ToggleDisable


model = { 
  mc = { 
    prompt = "what is 1 + 1"
  , choices = [
    { 
        label = "one" 
      , value = "one"
      , selected = True
      , correctness = MultipleChoice.Unknown
      , feedback = Nothing }
    , 
    { 
        label = "two" 
      , value = "two"
      , selected = False 
      , correctness = MultipleChoice.Unknown
      , feedback = Nothing }
    ]
   }
    , formDisabled = False
   }


    
update : Msg -> Model -> Model
update msg model =
    case msg of
        Toggle value selected -> 
          let 
            newMc = model.mc
                    |> setChoices (map (toggleChoice value selected) model.mc.choices) 
          in  
            { model | mc = newMc }
        ToggleDisable -> 
          { model | formDisabled = not model.formDisabled} 


view : Model -> Html Msg
view model = 
  div [] [ text "mc below"
  , hr [] []
  , ControlBar.view ToggleDisable model.formDisabled
  , MultipleChoice.view model.mc model.formDisabled Toggle 
  ]
