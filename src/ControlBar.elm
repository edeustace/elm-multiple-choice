module ControlBar exposing(..)

import Html exposing (Html, button, div, hr, label, text, input)
import Html.Attributes exposing (name, style, type_, value, checked, disabled)
import Html.Events exposing (onClick)


view : msg -> Bool -> Html msg
view msg disabled = 
  div [] [
    label [] [
      input [ 
        type_ "checkbox" 
      , checked disabled
      , onClick msg ] [ ]
      , text "Disabled?"
    ]
  ]