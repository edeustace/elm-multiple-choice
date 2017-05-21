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


port sessionUpdated : MultipleChoice.Session -> Cmd msg
   
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case Debug.log "got msg" msg of
      McMsg subMsg ->
        let 
          (update, cmd) = MultipleChoice.update subMsg model.mc
          o = case subMsg of 
            MultipleChoice.ToggleShowCorrectAnswer b -> sessionUpdated model.mc.session 
        in 

          ({ model | mc = update }, Cmd.batch [Cmd.map McMsg cmd, o])


-- port modelUpdate : (Model -> msg) -> Sub msg

subscriptions : Model -> Sub Msg
subscriptions model =
   Sub.none  


view : Model -> Html Msg
view model = 
  let 
    m = Debug.log "got model" model
  in 
    div [] [ text "mc below -----"
    , hr [] []
    , Html.map McMsg (MultipleChoice.view model.mc)
    ]
