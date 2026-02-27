// Add a note to the top of the page about where the full real syllabus lives.
//
// This has to get injected as part of include-before-body and not in
// include-in-header because otherwise this gets placed on an empty A4 page at
// the beginning of the document because of how it interacts with `#set page()`
//
// I wish there was a way to get this note-content from YAML, but alas.

// #let note-content = [*Note*#h(1em)The full version of the course syllabus, schedule, and all course materials is available online at #link("https://governancef25.classes.andrewheiss.com/"). This is only a partially complete static version.]
#let note-content = [*NOTE*#h(1em){{< meta pdf-note >}}]

#place(
  top + left,
  dy: -1in,  // Move this thing into the top margin
  block(
    width: 100%,
    fill: rgb("#FCCE2540"),
    stroke: rgb("#FCCE25"),
    inset: 1em,
    {
      set text(size: 0.85em)
      set par(justify: false)
      note-content
    }
  )
)
