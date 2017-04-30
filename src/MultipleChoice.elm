module MultipleChoice exposing (..)

import Html exposing (Html, button, div, hr, label, text, input)
import List exposing (map)
import Html.Attributes exposing (name, style, type_, value, checked, disabled)
import Html.Events exposing (onClick)


type alias Choice = {
  label : String
  , value : String
}

type alias Data = {
  prompt: String,
  choices: List Choice
}

isSelected value choice = 
  case value of 
    Nothing -> False 
    Just v -> v == choice.value

radio : msg -> Maybe String -> Bool -> Choice -> Html msg
radio msg selectedValue d choice =

  let 
    selected = isSelected selectedValue choice 
  in
    div [] [
      label []
        [ input [ 
          type_ "radio"
        , disabled d 
        , value choice.value
        -- , onClick (Toggle choice.value selected)
        , onClick msg 
        , checked selected] []
        , text choice.label
        ]
    ] 


view : Data -> Maybe String -> Bool -> (String -> Bool -> msg) ->Html msg 
view data selectedValue disabled mkMsg = 
  div [] 
      [ div [] [ text data.prompt ]
      , hr [] []
      , div [] (map (radio (mkMsg "one" True) selectedValue disabled) data.choices) ]
