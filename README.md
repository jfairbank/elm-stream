# elm-stream

Fast and simple stream library for Elm. Create streams of data or flatten multiple operations over lists.

Streams flatten operations like `map` and `filter` so you don't have to iterate through a stream multiple times like a list.

```elm
import Stream


Stream.range 1 1000
    |> Stream.map (\n -> n * 2)
    |> Stream.filter (\n -> n > 10)
    |> Stream.take 3
    |> Stream.toList == [12, 14, 16]
```

You can use streams with lists of data too.

```elm
[1, 2, 3, 4, 5]
    |> Stream.fromList
    |> Stream.map (\n -> 2 ^ n)
    |> Stream.filter (\n -> n > 8)
    |> Stream.toList == [16, 32]
```
