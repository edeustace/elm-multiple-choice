module Icon exposing(open, close)

import Html exposing (Html)
import Svg exposing(..)
import Svg.Attributes exposing (..)

open : Html msg
open = 
  svg [ 
   preserveAspectRatio "xMinYMin meet", 
   version "1.1", 
   viewBox "-283 359 34 35", 
   x "0px", 
   y "0px" ]
        [ g []
          [ node "circle" [ 
            class "hide-icon-background", 
            cx "-266", 
            cy "375.9", 
            r "14" ]
            []
          , Svg.path [ 
            class "hide-icon-background", 
            d "M-280.5,375.9c0-8,6.5-14.5,14.5-14.5s14.5,6.5,14.5,14.5s-6.5,14.5-14.5,14.5S-280.5,383.9-280.5,375.9z M-279.5,375.9c0,7.4,6.1,13.5,13.5,13.5c7.4,0,13.5-6.1 13.5-13.5s-6.1-13.5-13.5-13.5C-273.4,362.4-279.5,368.5-279.5,375.9z" ]
            []
           
    , 
    polygon [  
      class "hide-icon-foreground", 
      points "-265.4,383.1 -258.6,377.2 -261.2,374.2 -264.3,376.9 -268.9,368.7 -272.4,370.6" ]
      []
    ]
  ]

close : Html msg
close = 
   svg [ preserveAspectRatio "xMinYMin meet", 
   version "1.1", 
   viewBox "-129.5 127 34 35", 
   x "0px", 
   y "0px" ]
  [ Svg.path [ class "show-icon-one", 
  d "M-112.9,160.4c-8.5,0-15.5-6.9-15.5-15.5c0-8.5,6.9-15.5,15.5-15.5s15.5,6.9,15.5,15.5 C-97.4,153.5-104.3,160.4-112.9,160.4z" ]
    []
  , Svg.path [ class "show-icon-two", 
  d "M-113.2,159c-8,0-14.5-6.5-14.5-14.5s6.5-14.5,14.5-14.5s14.5,6.5,14.5,14.5S-105.2,159-113.2,159z" ]
    []
  , circle [ 
    class "show-icon-background", 
    cx "-114.2", 
    cy "143.5", 
    r "14" ]
    []
  , Svg.path [ 
    class "show-icon-border", 
    d "M-114.2,158c-8,0-14.5-6.5-14.5-14.5s6.5-14.5,14.5-14.5s14.5,6.5,14.5,14.5S-106.2,158-114.2,158z M-114.2,130c-7.4,0-13.5,6.1-13.5,13.5s6.1,13.5,13.5,13.5s13.5-6.1,13.5-13.5S-106.8,130-114.2,130z" ]
    []
  , polygon [ 
    class "show-icon-foreground",  
    points "-114.8,150.7 -121.6,144.8 -119,141.8 -115.9,144.5 -111.3,136.3 -107.8,138.2" ]
    []
  ]