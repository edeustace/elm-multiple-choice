port module MultipleChoiceExample exposing (..)

import List exposing (map)
import MultipleChoice exposing(..)
import ControlBar exposing(..)
import PieModes 
import Html exposing (Html, button, div, br, hr, label, text, input)


port pieModeChange : String -> Cmd msg
-- port modelUpdate : String -> Cmd msg


main =
    Html.program
        { init = init 
        , view = view
        , update = update
        , subscriptions = subscriptions
        }

type alias RawModel = {
  mc: MultipleChoice.RawData,
  formDisabled: Bool,
  pieMode : String
}

type alias Model = {
  mc : MultipleChoice.Data,
  formDisabled: Bool,
  pieMode : PieModes.Mode
} 

type Msg 
  = Toggle String Bool 
  | ToggleDisable
  | ChooseMode Mode
  | ChoosePieMode PieModes.Mode
  | PieModelUpdate RawModel


init = ({ 
  mc = { 
    prompt = "what is 1 + 1"
  , mode = MultipleChoice.Checkbox
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
    , pieMode = PieModes.Gather
    , formDisabled = False
   }, Cmd.none)


choiceFromRaw : RawChoice -> Choice 
choiceFromRaw rc = 
  {
    label = rc.label
    , value = rc.value 
    , selected = rc.selected
    , correctness = if rc.correctness == "correct" then Correct else Unknown
    , feedback = Nothing
  }

modeToString : PieModes.Mode -> String
modeToString mode = case mode of 
  PieModes.Gather -> "gather"
  PieModes.View -> "view"
  PieModes.Evaluate -> "evaluate"


pieModeFromString ms = case ms of 
  "gather" -> PieModes.Gather 
  "view" -> PieModes.View
  "evaluate" -> PieModes.Evaluate
  _ -> PieModes.Gather

modeFromString ms = 
  case ms of 
    "radio" -> Radio 
    "checkbox" -> Checkbox 
    _ -> Radio 

fromRaw : RawData -> Data 
fromRaw mc = 

   
  { 
    mode = modeFromString mc.mode
    , prompt = mc.prompt
    , choices = (map choiceFromRaw mc.choices)
  } 

toModel : RawModel -> Model
toModel raw = 
  {
    formDisabled = raw.formDisabled
    , pieMode = pieModeFromString raw.pieMode 
    , mc = fromRaw raw.mc
  }

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Toggle value selected -> 
          let 
            newMc = model.mc
                    |> setChoices (map (toggleChoice value selected model.mc.mode) model.mc.choices) 
          in  
            ({ model | mc = newMc }, Cmd.none)
        
        ToggleDisable -> 
          ({ model | formDisabled = not model.formDisabled} , Cmd.none)
        
        ChooseMode m ->
          let 
            newMc = model.mc |> setMode m 
           in
            ({ model | mc = newMc}, pieModeChange "view")
        
        ChoosePieMode m -> 
          ({ model | pieMode = m}, pieModeChange (modeToString m))
        
        PieModelUpdate raw -> (toModel raw, Cmd.none)

port modelUpdate : (RawModel -> msg) -> Sub msg

subscriptions : Model -> Sub Msg
subscriptions model =
   modelUpdate PieModelUpdate 


view : Model -> Html Msg
view model = 
  div [] [ text "mc below -----"
  , hr [] []
  , ControlBar.view ToggleDisable ChooseMode model.mc.mode ChoosePieMode model.pieMode model.formDisabled
  , MultipleChoice.view model.mc model.formDisabled Toggle 
  ]
