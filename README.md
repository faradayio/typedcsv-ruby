# Typedcsv

Here's your standard untyped CSV:

```
name,income,created_at,tags,great
Seamus,12301.2,2012-02-21,red;blue,true
```

Now, you and I know that `12301.2` is a number and `2012-02-21` is a date and `red;blue` is a list... so let's just write that into the headers:

```
name,income:number,created_at:date,tags:list,great:boolean
Seamus,12301.2,2012-02-21,red;blue,true
```

Now let's parse it:

```
Typedcsv.foreach('file.csv', headers: true) do |row|
  row['income']     # will be a Float
  row['created_at'] # will be a Date
  row['tags']       # will be an Array
  row['great']      # will be TrueClass or FalseClass
end
```

This gem provides `Typedcsv.foreach()`, which takes exactly the same arguments as [ruby stdlib `CSV.foreach`](https://ruby-doc.org/stdlib-2.4.1/libdoc/csv/rdoc/CSV.html#method-c-foreach).

## Types

* text (default)
* number
* list (must be semicolon-separated)
* date (must be ISO8601)
* time (must be ISO8601)
* boolean (recognizes "true" or "false")

## Benchmarks

It's about 10x slower than ruby's stdlib `CSV.foreach`:

```
cd benchmark && ruby benchmark.rb
[...]
CSV.foreach - array mode
                          2.503  (± 0.0%) i/s -     13.000  in   5.197588s
Typedcsv.foreach - array mode
                          0.253  (± 0.0%) i/s -      2.000  in   7.892107s
CSV.foreach - hash mode
                          1.830  (± 0.0%) i/s -     10.000  in   5.466998s
Typedcsv.foreach - hash mode
                          0.226  (± 0.0%) i/s -      2.000  in   8.867616s
```

## Sponsor

<p><a href="https://www.faraday.io"><img src="https://s3.amazonaws.com/faraday-assets/files/img/logo.svg" alt="Faraday logo"/></a></p>

We use [`typedcsv`](https://github.com/faradayio/typedcsv) for [B2C customer intelligence at Faraday](https://www.faraday.io).

## Copyright

Copyright 2017 Faraday
