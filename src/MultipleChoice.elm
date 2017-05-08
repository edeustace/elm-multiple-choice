module MultipleChoice exposing (..)

import Html exposing (Html, button, div, hr, label, text, input)
import List exposing (map)
import Html.Attributes exposing (name, style, type_, value, checked, disabled)
import Html.Events exposing (onClick)

type Correctness = Correct | Incorrect | Unknown 

type Mode = Radio | Checkbox 

type alias Choice = {
  label : String
  , value : String
  , selected : Bool
  , correctness : Correctness
  , feedback : Maybe String
}

type alias Data = {
  prompt: String,
  mode : Mode,
  choices: List Choice
}

setMode : Mode -> Data -> Data 
setMode  m d = { d | mode = m}

setChoices : List Choice -> Data -> Data 
setChoices c d = 
  {d | choices = c}

toggleChoice : String -> Bool -> Mode -> Choice -> Choice
toggleChoice v selected mode choice = 
  if choice.value == v then 
    { choice | selected = not choice.selected}
  else
    let 
      selected = if mode == Radio then False else choice.selected 
    in 
      { choice | selected = selected } 

type alias MakeMsg msg = (String -> Bool -> msg)

radio : String -> MakeMsg msg -> Bool -> Choice -> Html msg
radio t makeMsg d choice =
  div [] [
    label []
      [ input [ 
        type_ t 
      , disabled d 
      , value choice.value
      , onClick (makeMsg choice.value choice.selected) 
      , checked choice.selected] []
      , text choice.label
      ]
  ] 


view : Data -> Bool -> (MakeMsg msg) -> Html msg 
view data disabled makeMsg =
  let 
    choiceType = if data.mode == Radio then "radio" else "checkbox" 
  in 
    div [] 
        [ div [] [ text data.prompt ]
        , hr [] []
        , div [] (map (radio choiceType makeMsg disabled) data.choices) ]
