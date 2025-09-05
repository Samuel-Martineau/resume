.DEFAULT_GOAL := resume.pdf
.PHONY := all

all: resume.svg resume.png resume.pdf

resume.%: main.typ template.typ ./fonts/CustomLigatures.otf
	typst compile main.typ resume.$*

fonts/CustomLigatures.otf: fonts/CustomLigatures.py
	fontforge -script fonts/CustomLigatures.py
