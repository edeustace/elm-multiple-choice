port module MultipleChoiceContainer exposing (..)

import MultipleChoice exposing(addValueToSession) 
import Html exposing (Html, button, div, br, hr, label, text, input)

main =
    Html.program
        { init = init 
        , view = view
        , update = update
        , subscriptions = subscriptions
        }

type alias Model = {
  mc : MultipleChoice.Model
}

type Msg = 
  McMsg MultipleChoice.Msg 
 | ConfigUpdate MultipleChoice.Config
 | SessionUpdate MultipleChoice.Session

-- outgoing
port sessionUpdated : MultipleChoice.Session -> Cmd msg

-- incoming
port configUpdate : (MultipleChoice.Config -> msg) -> Sub msg
port sessionUpdate : (MultipleChoice.Session -> msg) -> Sub msg
   
init = ({ mc = MultipleChoice.initialModel }, Cmd.none)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case Debug.log "got msg" msg of
      McMsg subMsg ->
        let 
          (update, cmd) = MultipleChoice.update subMsg model.mc
          updatedModel = { model | mc = update}
          o = case subMsg of 
            MultipleChoice.ToggleChoice b -> sessionUpdated updatedModel.mc.session 
            _ -> Cmd.none
        in 
          (updatedModel, Cmd.batch [Cmd.map McMsg cmd, o])
      -- mc model sent in ..
      ConfigUpdate newConfig -> 
        let 
          {mc} = model
          newMc = MultipleChoice.reset {mc | config = newConfig}
          update = { model | mc = newMc}
        in 
          (update, Cmd.none)
      SessionUpdate newSession -> 
        let 
          {mc} = model 
          newMc = {mc | session = newSession}
        in 
          ({model | mc = newMc}, Cmd.none)


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch [
    configUpdate ConfigUpdate   
  , sessionUpdate SessionUpdate ]

view : Model -> Html Msg
view model = Html.map McMsg (MultipleChoice.view model.mc)
    
