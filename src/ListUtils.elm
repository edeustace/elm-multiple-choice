module ListUtils exposing(mapFirst, mapExceptFirst)

import List exposing (head, tail, append, foldr, foldl)

type alias Predicate a = a -> Bool 
type alias Fn a = a -> a 

mapFirst : Predicate a -> Fn a -> List a -> List a 
mapFirst predicate mapFn list = 
  let 
    mf : a -> (Bool, List a) -> (Bool, List a)
    mf el acc = 
      let 
        (hasMapped, arr) = acc 
      in 
        if hasMapped then 
          (hasMapped, (append arr [el]))
        else 
          if predicate el then 
            (True, (append arr [mapFn el]))
          else 
            (False, (append arr [el]))
    (_, out) = foldl mf (False, []) list
  in 
    out



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
