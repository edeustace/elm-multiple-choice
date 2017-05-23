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
  mc : MultipleChoice.Model
}

init = ({ mc = MultipleChoice.initialModel }, Cmd.none)


type Msg = 
  McMsg MultipleChoice.Msg 
 | ConfigUpdate MultipleChoice.Config
 | SessionUpdate MultipleChoice.Session

port sessionUpdated : MultipleChoice.Session -> Cmd msg
   
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case Debug.log "got msg" msg of
      McMsg subMsg ->
        let 
          (update, cmd) = MultipleChoice.update subMsg model.mc
          o = case subMsg of 
            MultipleChoice.ToggleShowCorrectAnswer b -> sessionUpdated model.mc.session 
            _ -> Cmd.none
        in 

          ({ model | mc = update }, Cmd.batch [Cmd.map McMsg cmd, o])
      -- mc model sent in ..
      ConfigUpdate newConfig -> 
        let 
          {mc} = model
          newMc = {mc | config = newConfig}
          update = { model | mc = newMc}
        in 
          (update, Cmd.none)
      SessionUpdate newSession -> 
        let 
          {mc} = model 
          newMc = {mc | session = newSession}
        in 
          ({model | mc = newMc}, Cmd.none)

port configUpdate : (MultipleChoice.Config -> msg) -> Sub msg
port sessionUpdate : (MultipleChoice.Session -> msg) -> Sub msg

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch [
    configUpdate ConfigUpdate   
  , sessionUpdate SessionUpdate
  ]


view : Model -> Html Msg
view model = 
  let 
    m = Debug.log "got model" model
  in 
    div [] [ text "mc below -----"
    , hr [] []
    , Html.map McMsg (MultipleChoice.view model.mc)
    ]
