module MultipleChoice exposing (..)
import ListUtils exposing (mapFirst, mapExceptFirst)

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

type alias RawChoice = {
  label : String
  , value: String 
  , selected: Bool 
  , correctness: String
  , feedback: Maybe String 
}

type alias RawData = {
  prompt: String, 
  mode: String,
  choices: List RawChoice 
}
      
  
deselectAllButFirst : Mode -> Data -> Data
deselectAllButFirst mode d =
    let
      isSelected = (\c -> c.selected == True) 
      deselect = (\c -> {c | selected = False}) 
      newChoices = mapExceptFirst isSelected deselect d.choices
    in
      { d | choices = newChoices }

newMode : Mode -> Data -> Data
newMode m d = 
  { d | mode = m}

setMode : Mode -> Data -> Data 
setMode  mode data = 
  data 
   |> (\d -> if mode == Checkbox then d else deselectAllButFirst mode d) 
   |> newMode mode

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
