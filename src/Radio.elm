module Radio exposing (..)

import Material.Toggles as Toggles
import Material.Options as Options exposing (css, cs)
import Material
import Html exposing (Html, button, div, br, label, text, input)
import Html.Attributes exposing (style, name, type_, value, checked)
import Html.Events exposing (onClick)

type alias Choice = {
  label:String 
  ,value:String
}

type alias Model =
  { mdl : Material.Model
    , choice : Choice
  }



type Msg 
  = Mdl (Material.Msg Msg)
  | Select String
  | Deselect 

radio : Model -> Bool -> Msg -> Html Msg
radio m selected msg =
  div []
  [
    Toggles.radio Mdl [0] m.mdl 
          [ Toggles.value selected
          , Toggles.group "MyRadioGroup"
          , Toggles.ripple
          , Options.onToggle msg
          ]
          [ text m.choice.label ]
  ]
    -- label
    --     [ style [ ( "padding", "5px" ), ( "display", "block" ) ] ]
    --     [ 
    --       input [ 
    --         checked (selected == True), 
    --         type_ "radio", 
    --         name "groupname", 
    --         value choice.value, 
    --         onClick msg ] []
    --       , text choice.label
    --     ]
