
// Modified table with header 
#let fb_htable(
  highlight-rows: (),
  highlight-cols: (),
  highlight-cells: (),
  highlight-color: yellow.lighten(70%),
  ..args
) = {
  let named = args.named()
  let positional = args.pos()

  table(
    ..named,
    fill: (x, y) => {
      if y == 0 {
        gray.lighten(60%)          // Header
      } else if highlight-rows.contains(y) or highlight-cols.contains(x) or highlight-cells.contains((x,y)) {
        highlight-color            // Hervorhebung
      } else {
        white
      }
    },
    ..positional
  )
}

// quote 
#let fb_quote(message,by) = {
  block(radius: 1em, width: 90%, inset: (x: 2em, y: 0.5em), [
    #set align(right)
    #set text(style: "italic")
    #message
    #v(0.1em)
    #text(size: 10pt, [
      #by
    ])
  ])
}

// Revision Mark addedText
#let fb_addedText(content) = block(
  stroke: (right: 2pt + black.lighten(5%)),
  inset: (right: 6pt),
  content
)  
