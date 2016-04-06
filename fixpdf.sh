#!/bin/bash

convert -density 300 $1 -gravity center -shave 10% +gravity +repage -crop 100%x50% -trim +repage $2
