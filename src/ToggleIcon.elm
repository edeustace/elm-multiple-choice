module ToggleIcon exposing(..)

import Html exposing(Html, div, text)
import Html.Events exposing (onClick)
import Html.Attributes exposing (class, classList)
import List exposing(map)
import Task 
import Process 


type Msg = 
  Toggle
  | StateChange State

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
  case (Debug.log ">>msg" msg) of 
    Toggle ->
      if model.state == Enter || model.state == Leave then 
        -- do nothing
        (model, Cmd.none)
      else  
        let
          state = if model.toggled then Leave else Enter
          endState = if model.toggled then LeaveActive else EnterActive 
          t = Task.perform (\n -> (StateChange endState)) (Process.sleep <| 2000)  
        in
          ({model | state = state }, t )
    StateChange s -> 
      case s of 
        Enter -> (model, Cmd.none)
        Leave -> (model, Cmd.none)
        EnterActive -> ({model | toggled = True, state = s}, Cmd.none)
        LeaveActive -> ({model | toggled = False, state = s}, Cmd.none)


view : Model -> Html Msg
view model =
  let
    classes = case model.state of 
      Enter -> ["enter"]
      EnterActive -> ["enter" ,"enter-active"]
      Leave -> ["leave"]
      LeaveActive -> ["leave", "leave-active"]
    expanded = (map (\c -> (c, True)) classes)
    clazz  = classList expanded 
  in 
    div [clazz, onClick Toggle] [text (if model.toggled then "showing!" else "not showing!" )]