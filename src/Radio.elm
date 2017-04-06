module Radio exposing (..)

import Material.Toggles as Toggles
import Material.Options as Options exposing (css, cs)
import Material
import Html exposing (Html, button, div, br, label, text, input)
import Common exposing (Msg(Mdl, Toggle))

type alias Choice = {
  label : String
  , value : String 
}


radio : Choice -> Bool -> Material.Model -> Html Msg
radio choice selected mdl =
  div []
  [
    Toggles.radio Mdl [0] mdl 
          [ Toggles.value selected 
          , Toggles.ripple
          , Options.onClick (Toggle choice.value selected)
          ]
          [ text choice.label ]
  ]


