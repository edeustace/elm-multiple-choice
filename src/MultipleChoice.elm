module MultipleChoice exposing (..)
-- import ListUtils exposing (mapFirst, mapExceptFirst)

import Html exposing (Html, button, div, hr, label, text, input)
import List exposing (map, member, filter, sort, append)
import Html.Attributes exposing (name, style, type_, value, checked, disabled)
import Html.Events exposing (onClick)

type Correctness = Correct | Incorrect | Unknown 

type Mode = Radio | Checkbox 

type alias Choice = {
  label : String,
  value : String
}

type alias Complete = {
  min : Int 
}

type alias Model = {
  prompt: String,
  mode: String,
  choiceMode : String,
  choices: List Choice,
  complete : Complete,
  disabled: Bool,
  keyMode: String
}

type alias Session = {
  value : List String 
}


addValueToSession : String -> String -> Session -> Session 
addValueToSession choiceMode value session =
  if member value session.value then 
    -- remove it 
    { session | value = filter (\n -> n /= value) session.value }
  else 
    -- add it 
    if choiceMode == "radio" then 
      { session | value = [value] }  
    else 
      { session | value = sort (append session.value [value]) }


  
-- deselectAllButFirst : Mode -> Model -> Model  
-- deselectAllButFirst mode d =
--     let
--       isSelected = (\c -> c.selected == True) 
--       deselect = (\c -> {c | selected = False}) 
--       newChoices = mapExceptFirst isSelected deselect d.choices
--     in
--       { d | choices = newChoices }

-- newMode : Mode -> Model ->Model 
-- newMode m d = 
--   { d | mode = m}

-- setMode : Mode -> Model -> Model 
-- setMode  mode data = 
--   data 
--    |> (\d -> if mode == Checkbox then d else deselectAllButFirst mode d) 
--    |> newMode mode

-- setChoices : List Choice -> Model -> Model 
-- setChoices c d = 
--   {d | choices = c}

-- toggleChoice : String -> Bool -> Mode -> Choice -> Choice
-- toggleChoice v selected mode choice = 
--   if choice.value == v then 
--     { choice | selected = not choice.selected}
--   else
--     let 
--       selected = if mode == Radio then False else choice.selected 
--     in 
--       { choice | selected = selected } 

type alias MakeMsg msg = (String -> msg)

isSelected : String -> Session -> Bool 
isSelected v session = member v session.value 

radio : String -> MakeMsg msg -> Bool -> Session -> Choice -> Html msg
radio t makeMsg d session choice=

  let 
    selected = isSelected choice.value session 
  in 
    div [] [
      label []
        [ input [ 
          type_ t 
        , disabled d 
        , value choice.value
        , onClick (makeMsg choice.value) 
        , checked selected] []
        , text choice.label
        ]
    ] 


view : Model -> Session -> (MakeMsg msg) -> Html msg 
view model session makeMsg =
  div [] 
      [ div [] [ text model.prompt ]
      , hr [] []
      , div [] (map (radio model.choiceMode makeMsg model.disabled session) model.choices) ]
