module MultipleChoice exposing (..)

import Html exposing (Html, button, div, hr, label, text, input)
import List exposing (indexedMap, map, member, filter, sort, append, foldl, foldr, product, intersperse)
import Html.Attributes exposing (class, name, style, type_, value, checked, disabled)
import Html.Events exposing (onClick)

type alias Choice = {
  label : String,
  value : String,
  correct: Maybe Bool,
  feedback : Maybe String
}

type alias Complete = {
  min : Int 
}

type alias Config = {
  prompt: String,
  mode: String,
  choiceMode : String,
  choices: List Choice,
  complete : Complete,
  disabled: Bool,
  keyMode: String,
  responseCorrect : Maybe Bool
}

type alias Session = {
  value : List String 
}

type alias Model = {
  config : Config, 
  session : Session,
  isShowingCorrect : Bool
}

type alias ChoiceUi = {
  key: String,
  c : Choice,
  selected : Bool,
  choiceMode : String,
  mode : String, 
  disabled : Bool
}

type Msg = 
  ToggleShowCorrectAnswer 
  | ToggleChoice String
  

initialModel : Model 
initialModel = { 
  config = { 
    prompt = "This is a prompt"
  , responseCorrect = Nothing
  , mode = "gather"
  , choiceMode = "checkbox" 
  , complete = {
    min = 2
  }
  , disabled = False
  , keyMode = "numbers"
  , choices = [
    { 
        label = "one" 
      , value = "one"
      , correct = Nothing
      , feedback = Nothing 
    }
    ]
   }
   , session = {
     value = []
   }
   , isShowingCorrect = False
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


isSelected : Session -> String -> Bool 
isSelected session value = member value session.value 

choiceInput : String -> Bool -> Bool -> Choice -> Html Msg
choiceInput t d selected choice =
  div [] [
    label []
      [ input [ 
        type_ t 
      , disabled d 
      , value choice.value
      , onClick (ToggleChoice choice.value) 
      , checked selected] []
      , text choice.label
      ]
  ] 


feedback : String -> Html msg
feedback msg = 
  div [class "feedback"] [
    text msg
  ]

choice : ChoiceUi -> Html Msg 
choice {c,choiceMode, key, disabled, selected, mode} = 
  let 
    clazz = case (selected, c.correct, mode) of 
      (True, Just True, "evaluate") -> "correct"
      (True, _, "evaluate") -> "incorrect"
      _ -> ""
    fb = case (selected, c.feedback) of 
      (True, Just msg) -> [ feedback msg ]
      _ -> []
  in 
    div [class clazz] (append [ 
      text key 
    , choiceInput choiceMode disabled selected c
    ] fb)
    
correctResponseToUi :  Config -> Int -> Choice -> ChoiceUi 
correctResponseToUi config index choice = 
  choiceUi config (choice.correct == Just True) index choice  

isSelectedToUi : Config -> (String -> Bool) -> Int -> Choice -> ChoiceUi 
isSelectedToUi config isSelected index choice = 
  choiceUi config (isSelected choice.value) index choice

choiceUi : Config -> Bool -> Int -> Choice -> ChoiceUi 
choiceUi {keyMode, choiceMode, mode, disabled} selected index choice = 
  { c = choice,
    key = if keyMode == "numbers" then toString (index + 1) else "?",
    selected = selected,
    choiceMode = choiceMode, 
    mode = mode,
    disabled = disabled }

correctAnswerToggle : Bool -> Maybe Bool -> List Choice -> Html Msg 
correctAnswerToggle isToggled responseCorrect choices = 
  let
    base = ["correct-answer-toggle"]
    withExtras = (append base [
      (if responseCorrect == Just False then "visible" else ""),
      (if isToggled then "toggled" else "")
      ])
    msg = (if isToggled then "Hide" else "Show") ++ " correct answer"
    s = (intersperse " " withExtras)
    clazz = (foldr (++) "" s)
  in 
    div [class clazz, onClick ToggleShowCorrectAnswer] [ text msg ]

update : Msg -> Model -> (Model, Cmd Msg) 
update message model = 
  case message of 
    ToggleShowCorrectAnswer -> 
      ({ model | isShowingCorrect = not model.isShowingCorrect }, Cmd.none)
    ToggleChoice value -> 
      let
        s = model.session 
          |> addValueToSession model.config.choiceMode value 
      in  
        ({ model | session = s }, Cmd.none)

reset : Model -> Model 
reset model = 
  { model | isShowingCorrect = False }

view : Model -> Html Msg 
view model =
  let 
    { config, session } = model

    uiChoices = if model.isShowingCorrect then 
      (indexedMap (correctResponseToUi config) config.choices) 
    else 
      (indexedMap (isSelectedToUi config (isSelected session)) config.choices)
  in 
    div [] 
        [ 
           correctAnswerToggle model.isShowingCorrect model.config.responseCorrect model.config.choices 
         , div [] [ text config.prompt ]
         , hr [] []
         , div [] (map choice uiChoices)
        ]
