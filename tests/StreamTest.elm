module StreamTest exposing (..)

import Stream
import Expect exposing (Expectation)
import Test exposing (..)


suite : Test
suite =
    describe "Stream"
        [ describe ".fromList"
            [ test "creates a stream from a list" <|
                \_ ->
                    [ 1, 2, 3 ]
                        |> Stream.fromList
                        |> Stream.toList
                        |> Expect.equal [ 1, 2, 3 ]
            , test "creates empty stream from empty list" <|
                \_ ->
                    []
                        |> Stream.fromList
                        |> Stream.toList
                        |> Expect.equal []
            ]
        , describe ".empty"
            [ test "creates a stream with no values" <|
                \_ ->
                    Stream.empty
                        |> Stream.toList
                        |> Expect.equal []
            ]
        , describe ".range"
            [ test "creates an incrementing stream from a starting to ending number" <|
                \_ ->
                    Stream.range 1 5
                        |> Stream.toList
                        |> Expect.equal [ 1, 2, 3, 4, 5 ]
            , test "creates an empty stream if starting is greater than ending" <|
                \_ ->
                    Stream.range 5 1
                        |> Stream.toList
                        |> Expect.equal []
            , test "creates a single element stream when starting and ending are same" <|
                \_ ->
                    Stream.range 42 42
                        |> Stream.toList
                        |> Expect.equal [ 42 ]
            , test "creates a stream over negative and positive numbers" <|
                \_ ->
                    Stream.range -2 2
                        |> Stream.toList
                        |> Expect.equal [ -2, -1, 0, 1, 2 ]
            ]
        , describe ".create"
            [ test "creates a custom stream" <|
                \_ ->
                    let
                        stream =
                            Stream.create
                                (\n ->
                                    if n < 5 then
                                        Stream.continue (n + 1)
                                    else
                                        Stream.stop
                                )
                                1
                    in
                        stream
                            |> Stream.toList
                            |> Expect.equal [ 1, 2, 3, 4, 5 ]
            ]
        , describe ".cons"
            [ test "prepends a value to a stream" <|
                \_ ->
                    Stream.singleton 2
                        |> Stream.cons 1
                        |> Stream.toList
                        |> Expect.equal [ 1, 2 ]
            ]
        , describe ".append"
            [ test "appends two streams" <|
                \_ ->
                    Stream.append (Stream.range 1 3) (Stream.range 4 6)
                        |> Stream.toList
                        |> Expect.equal [ 1, 2, 3, 4, 5, 6 ]
            ]
        , describe ".map"
            [ test "transforms every value with a function" <|
                \_ ->
                    Stream.range 1 3
                        |> Stream.map ((*) 2)
                        |> Stream.toList
                        |> Expect.equal [ 2, 4, 6 ]
            ]
        , describe ".filter"
            [ test "only keeps values that return true" <|
                \_ ->
                    Stream.range 1 10
                        |> Stream.filter (\n -> n > 5)
                        |> Stream.toList
                        |> Expect.equal [ 6, 7, 8, 9, 10 ]
            ]
        , describe ".take"
            [ test "only takes the first n values" <|
                \_ ->
                    Stream.range 1 10
                        |> Stream.take 5
                        |> Stream.toList
                        |> Expect.equal [ 1, 2, 3, 4, 5 ]
            ]
        ]
