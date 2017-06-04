import Html exposing (div,text,button,Html)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import ToggleIcon
import List exposing(range, map)
import Task exposing(perform)
import Process

-- MODEL

type alias Model = 
  { value : Int,
    toggleIcon : ToggleIcon.Model
  }


-- UPDATE

type Msg 
  = AddIcon 
  | FinishEntry Int
  | ToggleIconMsg ToggleIcon.Msg



update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case (Debug.log "msg" msg) of
    ToggleIconMsg tm ->
      let 
        (tModel, tCmd) = ToggleIcon.update tm model.toggleIcon
        out = {model | toggleIcon = tModel}
      in 
        (out, Cmd.map ToggleIconMsg tCmd)

    FinishEntry v -> (model, Cmd.none)
    AddIcon -> 
      let 
        t = Task.perform (\n -> FinishEntry model.value) (Process.sleep <| 3000)   
      in
        ({ model | value = model.value + 1}, t)


view : Model -> Html Msg
view model =
  div [] [
    Html.map ToggleIconMsg (ToggleIcon.view model.toggleIcon)
  ]

subscriptions : a -> Sub msg
subscriptions model = Sub.none

-- APP
init : ( Model, Cmd msg )
init = (
  { value = 0,
    toggleIcon = ToggleIcon.initialModel
  }, Cmd.none)

main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions 
    } 