module CorrectAnswerToggle  exposing(..)

import Html exposing (Html, span, button, div, hr, label, text, input)
import List exposing (append, intersperse, foldr)
import Html.Events exposing (onClick)
import Html.Attributes exposing (class)
import Icon exposing (open,close)

view : Bool -> Maybe Bool -> msg -> Html msg 
view isToggled responseCorrect mkMsg = 
  let
    base = ["correct-answer-toggle"]
    withExtras = (append base [
      (if responseCorrect == Just False then "visible" else ""),
      (if isToggled then "toggled" else "")
      ])
    msg = (if isToggled then "Hide" else "Show") ++ " correct answer"
    s = (intersperse " " withExtras)
    clazz = (foldr (++) "" s)
    icon = (if isToggled then open else close)
  in

    div [class clazz, onClick mkMsg] [ 
      span [class "icon-holder"] [ icon ] 
      , text msg ]
