
#importonce

* = $1a00 "CharsetColor map"
CharsetColorMap:
  .import binary "assets/assets - CharAttribs.bin"

* = $1c00 "Charset"
Charset:
  .import binary "assets/assets - Chars.bin"

* = $1800 "Map"
Map:
  .import binary "assets/assets - Map (22x23).bin"
