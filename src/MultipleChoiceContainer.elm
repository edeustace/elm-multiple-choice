port module MultipleChoiceContainer exposing (..)

import List exposing (map)
import MultipleChoice exposing(addValueToSession) 
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
  model : MultipleChoice.Model,
  session : MultipleChoice.Session
}

init = ({ 
  model = { 
    prompt = "This is a prompt"
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
    }
     
    ]
   }
   , session = {
     value = []
   }
   }, Cmd.none)


type Msg = 
   Toggle String 
 | ModelUpdate Model


port sessionUpdated : MultipleChoice.Session -> Cmd msg
   
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case Debug.log "got msg" msg of
        Toggle value -> 
          let
            s = model.session 
              |> addValueToSession model.model.choiceMode value 
          in  
            ({ model | session = s }, sessionUpdated s)

        ModelUpdate m -> (m, Cmd.none)

port modelUpdate : (Model -> msg) -> Sub msg

subscriptions : Model -> Sub Msg
subscriptions model =
   modelUpdate ModelUpdate 


view : Model -> Html Msg
view model = 
  let 
    m = Debug.log "got model" model
  in 
    div [] [ text "mc below -----"
    , hr [] []
    , MultipleChoice.view model.model model.session Toggle 
    ]
