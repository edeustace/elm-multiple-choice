module ListUtils exposing(mapFirst, mapExceptFirst)

import List exposing (head, tail, append, foldr, foldl)
import Maybe exposing (withDefault)

type alias Predicate a = a -> Bool 
type alias Fn a = a -> a 

innerMapFirst : Predicate a -> Fn a -> Bool -> List a -> List a -> List a 
innerMapFirst predicate mapFn hasMapped output rest =
  if hasMapped then 
    append output rest 
  else
    case head rest of
      Just(h) -> 
        if predicate h then 
          let 
            newOutput = append output [(mapFn h)]
          in 
            innerMapFirst predicate mapFn True newOutput (withDefault [] (tail rest))
        else 
          innerMapFirst predicate mapFn False (append output [h]) (withDefault [] (tail rest))
      Nothing -> output

mapFirst : Predicate a -> Fn a -> List a -> List a 
mapFirst predicate mapFn list = innerMapFirst predicate mapFn False [] list


-- maps all the values except the first element that matches the predicate.
mapExceptFirst : Predicate a -> Fn a -> List a -> List a 
mapExceptFirst predicate mapFn list = 
  let
    skipFirst : a -> (Bool, List a) -> (Bool, List a)
    skipFirst el acc = 
      let 
        (hasSkipped, arr) = acc 
      in 
        if hasSkipped then 
          (hasSkipped, (append arr [(mapFn el)]))
        else 
          ((predicate el), (append arr [el]))           
    (_, out) = foldl skipFirst (False,[]) list
  in 
    out 
