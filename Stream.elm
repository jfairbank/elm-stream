module Stream
    exposing
        ( Stream
        , continue
        , create
        , filter
        , foldl
        , fromList
        , last
        , map
        , range
        , stop
        , take
        , toList
        )


type Element a
    = Cons a (Stream a)
    | Done


type alias Stream a =
    () -> Element a


type Next a
    = Continue a
    | Stop


continue : a -> Next a
continue =
    Continue


stop : Next a
stop =
    Stop


create : (a -> Next a) -> a -> Stream a
create generator initialValue () =
    let
        create_ next =
            case next of
                Continue value ->
                    Cons value (\() -> create_ (generator value))

                Stop ->
                    Done
    in
        create_ (continue initialValue)


range : Int -> Int -> Stream Int
range start end =
    create
        (\n ->
            if n <= end then
                continue (n + 1)
            else
                stop
        )
        start


fromList : List a -> Stream a
fromList list () =
    case list of
        [] ->
            Done

        x :: xs ->
            Cons x (fromList xs)


foldl : (item -> memo -> memo) -> memo -> Stream item -> Stream memo
foldl f memo stream () =
    case stream () of
        Cons value nextStream ->
            let
                newMemo =
                    f value memo
            in
                Cons newMemo (foldl f newMemo nextStream)

        Done ->
            Done


map : (a -> b) -> Stream a -> Stream b
map f stream () =
    case stream () of
        Cons value nextStream ->
            Cons (f value) (map f nextStream)

        Done ->
            Done


filter : (a -> Bool) -> Stream a -> Stream a
filter f stream () =
    case stream () of
        Cons value nextStream ->
            if f value then
                Cons value nextStream
            else
                filter f nextStream ()

        Done ->
            Done


take : Int -> Stream a -> Stream a
take n stream () =
    if n <= 0 then
        Done
    else
        case stream () of
            Done ->
                Done

            Cons value nextStream ->
                Cons value (take (n - 1) nextStream)


last : Stream a -> Maybe a
last stream =
    let
        last_ stream accum =
            case stream () of
                Cons value nextStream ->
                    last_ nextStream (Just value)

                Done ->
                    accum
    in
        last_ stream Nothing


toList : Stream a -> List a
toList stream =
    let
        toList_ streamValue acc =
            case streamValue of
                Done ->
                    acc

                Cons value nextStream ->
                    toList_ (nextStream ()) (value :: acc)
    in
        []
            |> toList_ (stream ())
            |> List.reverse
