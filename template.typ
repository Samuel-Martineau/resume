#let template(name: none, doc) = [
  #set page(paper: "us-letter")
  #set document(title: name + "'s Résumé", author: name, date: auto)

  #set par(justify: true)

  #show link: underline
  #show link: set text(fill: blue)

  #set list(marker: ([•], [--], [‣]))

  #set text(font: "Libertinus Sans", size: 10pt)
  #show heading: set text(font: "Libertinus Serif")
  #show heading.where(level: 1): set text(size: 14pt)
  #show heading.where(level: 1): it => [#place(dy: -5pt, dx: -5pt, line(length: 30%, stroke: blue)) #it]
  #show heading.where(level: 2): it => text(size: 10pt, it.body /* + [,]*/)

  #set list(indent: 5pt)

  #doc
]

#let icon(name) = text(font: "Custom Icon Ligatures", name)

#let header(name, ..pins) = align(center)[
  #block(below: 7pt, text(font: "Libertinus Serif", size: 22pt, weight: "black", name))

  #h(1fr)
  #for pin in pins.pos() [
    #h(1fr)
    #pin
    #h(1fr)
  ]
  #h(1fr)
]

#let description(left, right) = [#emph(left)#h(1fr)#right#linebreak()]

#let sep = [\u{22C6}]
