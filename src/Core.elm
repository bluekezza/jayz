module Core exposing (..)

-- if and only if the value passes the predicate
-- then apply the function to the value
-- otherwise return the original value
iff : Bool -> (a -> a) -> a -> a
iff pred func value =
    if pred then
        func value
    else
        value
