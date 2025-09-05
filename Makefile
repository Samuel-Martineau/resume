.DEFAULT_GOAL := resume.pdf
.PHONY := all

all: resume.svg resume.png resume.pdf

resume.%: main.typ template.typ ./fonts/CustomLigatures.otf
	typst compile main.typ resume.$*

fonts/CustomLigatures.otf: fonts/CustomLigatures.py
	ls -la assets
	ls -la assets/openmoji
	ls -la assets/openmoji/black
	ls -la assets/openmoji/black/svg
	fontforge -script fonts/CustomLigatures.py
