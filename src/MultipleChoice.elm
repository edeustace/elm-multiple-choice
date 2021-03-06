module MultipleChoice exposing (..)

import Html exposing (Html, button, div, hr, label, text, input)
import List exposing (indexedMap, map, member, filter, sort, append)
import Html.Attributes exposing (class, name, style, type_, value, checked, disabled)
import Html.Events exposing (onClick)

type Correctness = Correct | Incorrect | Unknown 

type Mode = Radio | Checkbox 

type alias Choice = {
  label : String,
  value : String,
  correct: Maybe Bool,
  feedback : Maybe String
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

isSelected :  Session -> String -> Bool 
isSelected session value = member value session.value 

choiceInput : String -> MakeMsg msg -> Bool -> Bool -> Choice -> Html msg
choiceInput t makeMsg d selected choice =

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

type alias ChoiceUi msg  = {
  key: String,
  c : Choice,
  selected : Bool,
  choiceMode : String, 
  mkMsg : (MakeMsg msg),
  disabled : Bool
}
feedback : String -> Html msg
feedback msg = 
  div [class "feedback"] [
    text msg
  ]

choice : ChoiceUi msg -> Html msg 
choice {c,choiceMode, key, mkMsg, disabled, selected} = 
  let 
    clazz = case (selected, c.correct) of 
      (True, Just True) -> "correct"
      (True, _) -> "incorrect"
      _ -> ""
    fb = case (selected, c.feedback) of 
      (True, Just msg) -> [ feedback msg ]
      _ -> []
  in 
    div [class clazz] (append [ 
      text key 
    , choiceInput choiceMode mkMsg disabled selected c
    ] fb)
    

toUi : String -> String -> (MakeMsg msg) -> Bool -> (String -> Bool) -> Int -> Choice -> ChoiceUi msg 
toUi choiceMode keyMode mkMsg disabled isSelected index choice = 
  { c = choice,
  key = if keyMode == "numbers" then toString (index + 1) else "?",
  selected = isSelected choice.value,
  choiceMode = choiceMode, 
  mkMsg = mkMsg,
  disabled = disabled }


view : Model -> Session -> (MakeMsg msg) -> Html msg 
view model session makeMsg =
  let 
    { choices, choiceMode, keyMode, disabled} = model 
    cui = (indexedMap 
      (toUi choiceMode keyMode makeMsg disabled (isSelected session) ) 
      model.choices)
  in 
    div [] 
        [ div [] [ text model.prompt ]
        , hr [] []
        , div [] (map choice cui)
        -- , div [] (map (radio model.choiceMode makeMsg model.disabled session) model.choices) 
        ]
