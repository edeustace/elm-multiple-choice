module ToggleIcon exposing(..)

import Html exposing(Html, div, text)
import Html.Events exposing (onClick)
import Html.Attributes exposing (class, classList)
import List exposing(map)
import Task 
import Process 


type Msg = 
  Toggle

type State = 
  Enter 
  | EnterActive 
  | Leave
  | LeaveActive 

type alias Model = {
  toggled : Bool,
  state : State
}

initialModel : Model
initialModel = { 
  toggled = False, 
  state = LeaveActive }

update : Msg -> Model -> (Model, Cmd Msg) 
update msg model =
  let 
    o = (Debug.log ">model" model)
  in  
    case (Debug.log ">>msg" msg) of 
      Toggle ->
        if model.state == Enter || model.state == Leave then 
          -- do nothing
          (model, Cmd.none)
        else  
          let
            state = if model.toggled then LeaveActive else EnterActive 
          in
            ({model | toggled = not model.toggled, state = state }, Cmd.none )


show model = 
  let 
    classes = case model.state of 
      Enter -> ["enter"]
      EnterActive -> ["enter", "enter-active"]
      Leave -> ["leave"]
      LeaveActive -> ["leave", "leave-active"]
    expanded = (map (\c -> (c, True)) classes)
    clazz = classList expanded 
  in 
    div [clazz] [text "show"]
  
hide model = 
  let 
    classes = case model.state of 
      Enter -> ["leave"]
      EnterActive -> ["leave", "leave-active"]
      Leave -> ["enter"]
      LeaveActive -> ["enter", "enter-active"]
    expanded = (map (\c -> (c, True)) classes)
    clazz = classList expanded 
  in 
    div [clazz] [text "hide"]

view : Model -> Html Msg
view model =
  div [class "toggle-icon-root", onClick Toggle] [
      show model, 
      hide model
    ]