port module MultipleChoiceContainer exposing (..)

import List exposing (map)
import MultipleChoice exposing(..)
import ControlBar exposing(..)
import PieModes 
import Html exposing (Html, button, div, br, hr, label, text, input)


main =
    Html.program
        { init = init 
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
-- {"id":"1","element":"corespring-choice","defaultLang":"en-US","langs":["en-US","es-ES","zh-CN"],"prompt":"Which of these northern European countries are EU members?","choiceMode":"checkbox","keyMode":"numbers","choices":[{"value":"sweden","label":"Sweden"},{"value":"iceland","label":"Iceland"},{"value":"norway","label":"Norway"},{"value":"finland","label":"Finland"}],"complete":{"min":2},"disabled":false,"mode":"gather"}"

type alias Model = {
  model : MultipleChoice.Model
  , session : MultipleChoice.Session
}

init = ({ 
  model = { 
    prompt = "This is a prompt"
  , choiceMode = "checkbox" 
  , complete = {
    min = 2
  }
  , disabled = False
  , mode = "gather"
  , keyMode = "numbers"
  , choices = [
    { 
        label = "one" 
      , value = "one"
    }
     
    ]
   }
   , session = {
     answers = []
   }
   }, Cmd.none)






   
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

port modelUpdate : (Model -> msg) -> Sub msg

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
