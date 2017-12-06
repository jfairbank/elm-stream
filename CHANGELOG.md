## v1.1.0

### New Functions

#### Use `singleton` to create streams with a single value.  

```elm
singleton 42
    |> toList == [42]
```

#### Use `cons` to add a value to the beginning of a stream.

```elm
cons (singleton 1) (singleton 2)
    |> toList == [1, 2]
```

#### Use `append` to combine two streams.

```elm
append (range 1 3) (range 4 6)
    |> toList == [1, 2, 3, 4, 5, 6]
```

#### Use `empty` to build from a stream with no values.

```elm
empty
  |> toList == []
```

#### Use `takeWhile` to take values as long as a predicate function returns true.

```elm
range 1 10
    |> takeWhile (\n -> n < 6)
    |> toList == [1, 2, 3, 4, 5]
```

#### Use `concatMap` to map values to streams and flatten the resulting streams.

```elm
-- Convert list of words to stream of letters
["hello", "there"]
    |> fromList
    |> concatMap (\word -> word |> String.split "" |> fromList)
    |> toList == ["h", "e", "l", "l", "o", "t", "h", "e", "r", "e"]

-- Flatten inner stream ranges
range 1 3
    |> concatMap (\n -> range n (n + 2))
    |> toList == [1, 2, 3, 2, 3, 4, 3, 4, 5]

-- Skip values with `empty`
range 1 10
    |> concatMap
        (\n ->
            if n < 6 then
                empty
            else
                singleton n
        )
    |> toList [6, 7, 8, 9, 10]
```

---

## v1.0.1

### Fixes

* Remove incorrect example in `range` docs.

---

## v1.0.0

Initial release!
