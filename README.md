# ayunker.github.io

Third time's the charm.


## Compress Image
Requires image magick

```
convert input_image.jpg -strip -quality 85 output_image.jpg
```

```
Dir.entries(".").select { File.file?(_1) }.map { system("magick #{_1} -strip -quality 50 #{_1}") }
```

the quality 85 flag is optional, but can further reduce size without (so far) noticeable reduction in quality
dropping to quality 50 also seems acceptable
