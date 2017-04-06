module Common exposing(Msg(..)) 

import Material


type alias Mdl = Material.Model

type Msg
    =  Mdl (Material.Msg Msg)
    | Toggle String Bool