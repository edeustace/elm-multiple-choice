module MultipleChoice exposing (..)

import Html exposing (Html, button, div, hr, label, text, input)
import List exposing (map)
import Html.Attributes exposing (name, style, type_, value, checked, disabled)
import Html.Events exposing (onClick)

type Correctness = Correct | Incorrect | Unknown 

type alias Choice = {
  label : String
  , value : String
  , selected : Bool
  , correctness : Correctness
  , feedback : Maybe String
}

type alias Data = {
  prompt: String,
  choices: List Choice
}


setChoices : List Choice -> Data -> Data 
setChoices c d = 
  {d | choices = c}

toggleChoice : String -> Bool -> Choice -> Choice
toggleChoice v selected choice = 
  if choice.value == v then 
    { choice | selected = not choice.selected}
  else 
    choice

type alias MakeMsg msg = (String -> Bool -> msg)

radio : MakeMsg msg -> Bool -> Choice -> Html msg
radio makeMsg d choice =
  div [] [
    label []
      [ input [ 
        type_ "radio"
      , disabled d 
      , value choice.value
      , onClick (makeMsg choice.value choice.selected) 
      , checked choice.selected] []
      , text choice.label
      ]
  ] 


view : Data -> Bool -> (MakeMsg msg) -> Html msg 
view data disabled makeMsg = 
  div [] 
      [ div [] [ text data.prompt ]
      , hr [] []
      , div [] (map (radio makeMsg disabled) data.choices) ]
