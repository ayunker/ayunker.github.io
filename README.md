# ayunker.github.io

Third time's the charm.


## Image Optimizations

Unfortunately, I don't think there's a 1 size fits all for image optimizations.
Here are some guidelines/heuristics:

* For PNG -> JPG, can use MozJPG to convert/compress, leveraging a script
copped from brandur, `ls assets/images/stationery-of-ludwig/*.png | xargs
./scripts/optimize_image`. This was used on stationery of ludwig and resulted
in 91% savings.
* For `ldn` images, they were already somewhat compressed `jpeg`s, just above
or below 1MB vs the 5 or 6MB images from stationery of ludwig. In this case,
the 75% quality actually resulted in ~10% **larger** file sizes! Using
quality 25 resulted in 54.9% savings (total 23MB images). Bigger than I would
like, but a solid improvement.
