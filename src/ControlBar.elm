module ControlBar exposing(..)

import Html exposing (Html, button, div, hr, label, text, input)
import Html.Attributes exposing (name, style, type_, value, checked, disabled)
import Html.Events exposing (onClick)
import MultipleChoice exposing(Mode(Radio,Checkbox))
import PieModes as Pm 

gve : (Pm.Mode -> msg) -> Pm.Mode -> Html msg 
gve mkMsg currentMode = 
  div[] [
    lr "radio" (currentMode == Pm.Gather) (mkMsg Pm.Gather) "gather"
    , lr "radio" (currentMode == Pm.View) (mkMsg Pm.View) "view"
    , lr "radio" (currentMode == Pm.Evaluate) (mkMsg Pm.Evaluate) "evaluate"
  ]

lr : String -> Bool -> msg -> String -> Html msg
lr t isChecked msg content = 
    label [] [
      input [
        type_ t 
        , checked isChecked 
        , onClick msg ] []
      , text content 
      ]
  
modeSwitcher : (Mode -> msg)-> Mode -> Html msg
modeSwitcher mkMsg mode = 
  div[][
    lr "radio" (mode == Radio) (mkMsg Radio) "Radio"
  , lr "radio" (mode == Checkbox) (mkMsg Checkbox) "Checkbox"
  ]

view : msg -> (Mode -> msg) -> Mode -> (Pm.Mode -> msg) -> Pm.Mode -> Bool -> Html msg
view msg chooseMode mode choosePieMode pieMode disabled = 
  div [] [
    label [] [
      input [ 
        type_ "checkbox" 
      , checked disabled
      , onClick msg ] [ ]
      , text "Disabled?"
    ]
    , modeSwitcher chooseMode mode 
    , gve choosePieMode pieMode 
  ]