# ayunker.github.io

Third time's the charm.


## Image Optimizations

Unfortunately, I don't think there's a 1 size fits all for image optimizations.
Here are some guidelines/heuristics:

* For PNG -> JPG, can use MozJPG to convert/compress, leveraging a script
copped from brandur, `ls assets/images/stationery-of-ludwig/*.png | xargs
./scripts/optimize_image`. This was used on stationery of ludwig and resulted
in 91% savings.
