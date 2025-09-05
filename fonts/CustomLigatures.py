import fontforge
import string
import os

openmoji = os.environ["OPENMOJI"]

font = fontforge.font()

font.familyname = "Custom Icon Ligatures"

font.addLookup("liga_lookup", "gsub_ligature", (), (("liga", (("latn", ("dflt")),)),))
font.addLookupSubtable("liga_lookup", "liga_subtable")

for c in string.ascii_lowercase:
    g = font.createChar(ord(c))
    g.width = 0


def add_ligature(unicode_val, sequence, width=1000):
    g = font.createChar(unicode_val)
    g.importOutlines(f"{openmoji}/black/svg/{unicode_val:X}.svg")
    g.width = width
    g.addPosSub("liga_subtable", tuple(sequence))


add_ligature(0x2709, "email")
add_ligature(0xE045, "github")
add_ligature(0x1F310, "website")
add_ligature(0x260E, "phone")

font.generate("fonts/CustomLigatures.otf")

font.close()
