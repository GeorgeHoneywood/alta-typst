#let primary_colour = rgb("#3E0C87") // vivid purple
#let link_colour = rgb("#12348e") // blue

// polyfill, as of Typst 0.14.0 target() only works when compiling with --features html
// and you can't set --features html on typst.app
#let target() = {
  if "target" in dictionary(std) { std.target() } else { "paged" }
}

#let icon(name, shift: 1.5pt) = context {
  let body = box(
    baseline: shift,
    height: 10pt,
    image("icons/" + name + ".svg"),
  )
  if target() == "paged" {
    body
    h(3pt)
  } else {
    html.frame(body)
  }
}

#let name(name) = context {
  if target() == "paged" {
    emph(name)
    [\ ]
  } else {
    html.div(
      class: "name",
      emph(name),
    )
  }
}

#let findMe(services) = {
  set text(8pt)
  let icon = icon.with(shift: 2.5pt)

  services
    .map(service => {
      icon(service.name)

      if "display" in service.keys() {
        link(service.link)[#{ service.display }]
      } else {
        link(service.link)
      }
    })
    .join(h(10pt))
  [

  ]
}

#let term(period, location) = context {
  if target() == "paged" {
    text(9pt, {
      icon("calendar")
      period
      h(1fr)
      icon("location")
      location
    })
  } else {
    html.div(
      style: "display: flex; align-items: center; gap: 10px;",
      {
        icon("calendar")
        html.div(period)
        icon("location")
        html.div(location)
      },
    )
  }
}


#let max_rating = 5
#let skill(name, rating) = context {
  let done = false
  let i = 1
  let dots = {
    while (not done) {
      let colour = rgb("#c0c0c0") // grey

      if (i <= rating) {
        colour = link_colour
      }

      let boxed_circle = box(circle(
        radius: 4pt,
        fill: colour,
      ))
      if target() == "paged" {
        boxed_circle
      } else {
        html.frame(boxed_circle)
      }

      if (max_rating == i) {
        done = true
      }

      if target() == "paged" {
        if (max_rating == i) {
          done = true
        } else {
          // no spacing on last
          h(2pt)
        }
      }

      i += 1
    }
  }

  if target() == "paged" {
    name
    h(1fr)
    dots
    [\ ]
  } else {
    html.div(
      style: "display: flex; align-items: center; gap: 5px; max-width: 200px; justify-content: space-between;",
      {
        text(name)
        html.span(
          style: "display: flex; gap: 5px; align-items: center;",
          dots,
        )
      },
    )
  }
}

#let styled-link(dest, content) = emph(text(
  fill: link_colour,
  link(dest, content),
))

#let alta(
  name: "",
  links: (),
  tagline: [],
  content,
) = context {
  set text(9.7pt, font: "IBM Plex Sans")

  let body = {
    [= #name]

    if target() == "paged" {
      findMe(links)
    }

    tagline

    if target() == "paged" {
      columns(
        2,
        gutter: 15pt,
        content,
      )
    } else {
      content
    }
  }

  // apply styling only for non-HTML output
  if target() == "paged" {
    set document(
      title: name + "'s CV",
      author: name,
    )
    set page(
      margin: (x: 54pt, y: 52pt),
    )

    show heading.where(
      level: 2,
    ): it => text(
      fill: primary_colour,
      [
        #{ it.body }
        #v(-7pt)
        #line(length: 100%, stroke: 1pt + primary_colour)
      ],
    )

    show heading.where(
      level: 3,
    ): it => text(it.body)

    show heading.where(
      level: 4,
    ): it => text(
      fill: primary_colour,
      it.body,
    )

    body
  } else {
    html.div(body)
  }
}
