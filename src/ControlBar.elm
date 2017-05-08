module ControlBar exposing(..)

import Html exposing (Html, button, div, hr, label, text, input)
import Html.Attributes exposing (name, style, type_, value, checked, disabled)
import Html.Events exposing (onClick)
import MultipleChoice exposing(Mode(Radio,Checkbox))

modeSwitcher : (Mode -> msg)-> Mode -> Html msg
modeSwitcher mkMsg mode = 
  div[][
    
    label [] [
      input [
        type_ "radio"
        , checked (mode == Radio)
        , onClick (mkMsg Radio) ] []
      , text "Radio"
      ]
    , label [] [
      input [
        type_ "radio"
        , checked (mode == Checkbox)
        , onClick (mkMsg Checkbox) ] []
      , text "checkbox"
      ]
  ]

view : msg -> (Mode -> msg) -> Mode -> Bool -> Html msg
view msg chooseMode mode disabled = 
  div [] [
    label [] [
      input [ 
        type_ "checkbox" 
      , checked disabled
      , onClick msg ] [ ]
      , text "Disabled?"
    ]
    , modeSwitcher chooseMode mode 
  ]