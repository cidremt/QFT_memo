/* set a new counter for thms*/
#let s = state("thm", (heading: str(0), counter: 0, style: ()))

/* initialize a document */
/* ---------------------------------------------------------------------------------*/
#let init(doc) = {

set enum(numbering: "i)")
set text(
  font: "IPAMincho",
  lang: "ja",
)
set par(first-line-indent: 1em)

set page(
  paper: "a4",
  numbering: " 1 ",
  header: locate(loc => [
    #set text(size: 10pt)
    #let elems = query(selector(heading).before(loc),loc,)
    #let default = "QFT memo"
    #if elems == (){
      align(right, default)
    }else{
      let body = elems.last().body
      default + h(1fr) + body
    }
    #line(length: 100%, stroke: 0.5pt + black)
  ]),
)


set heading(numbering: "1.1")


show heading: it =>[
  #counter(math.equation).update(0)
  #locate(loc => {
    s.update(arg => {
      arg.at("counter") = 0
      arg.at("heading") = counter(heading).at(loc)
      arg.at("style") = ()
      return arg
    })
  })
  #set text(font: "IPAPGothic")
  #if (it.level == 1){
    set align(center)
    block[
      #counter(heading).display() #h(1em)*#it.body*
    ]
    v(1em)
  }else{
    block[
      #counter(heading).display() #h(0.5em) *#it.body*
    ]
    v(0.5em)
  }
  
  
]

set math.equation(
  numbering: {num => locate(loc => "(" + counter(heading).at(loc).map(str).join(".") + "." + str(num) + ")")},
  supplement: [式],
)

doc
}
/* ---------------------------------------------------------------------------------*/


/* some funcs*/
/* ---------------------------------------------------------------------------------*/
#let braket(arg1, arg2) = $ angle.l #arg1|#arg2 angle.r $

#let bra(arg) = $ angle.l #arg| #h(0pt) $

#let ket(arg) = $ #h(0pt) |#arg angle.r $

#let ketbra(arg1, arg2) = $#h(0pt) |#arg1 angle.r #h(-1.5pt) angle.l #arg2| #h(0pt)$

#let definition(title, body) = {
s.update(arg => {arg.at("style") = "定義"; arg.at("counter") += 1; return arg})
locate(loc => {
  let num = s.at(loc).at("heading").map(str).join(".") + "." + str(s.at(loc).at("counter") )
  block(width: 100%, fill: luma(230), radius: 4pt, inset: 8pt)[#text(weight: "bold")[* 定義 #num. *] (#title) \ #body]
})
}

#let theorem(title, body) = {
s.update(arg => {arg.at("style") = "定理"; arg.at("counter") += 1; return arg})
locate(loc => {
  let num = s.at(loc).at("heading").map(str).join(".") + "." + str(s.at(loc).at("counter") )
  block(width: 100%, fill: luma(230), radius: 4pt, inset: 8pt)[#text(weight: "bold")[* 定理 #num. *] (#title) \ #body]
})
}

#let hypothesis(title, body) = {
s.update(arg => {arg.at("style") = "仮定"; arg.at("counter") += 1; return arg})
locate(loc => {
  let num = s.at(loc).at("heading").map(str).join(".") + "." + str(s.at(loc).at("counter") )
  block(width: 100%, fill: luma(230), radius: 4pt, inset: 8pt)[#text(weight: "bold")[* 仮定 #num. *] (#title) \ #body]
})
}

#let consequence(title, body) = {
s.update(arg => {arg.at("style") = "結果"; arg.at("counter") += 1; return arg})
locate(loc => {
  let num = s.at(loc).at("heading").map(str).join(".") + "." + str(s.at(loc).at("counter") )
  block(width: 100%, fill: luma(230), radius: 4pt, inset: 8pt)[#text(weight: "bold")[* 結果 #num. *] (#title) \ #body]
})
}

#let corollary(title, body) = {
s.update(arg => {arg.at("style") = "系"; arg.at("counter") += 1; return arg})
locate(loc => {
  let num = s.at(loc).at("heading").map(str).join(".") + "." + str(s.at(loc).at("counter") )
  block(width: 100%, fill: luma(230), radius: 4pt, inset: 8pt)[#text(weight: "semibold")[* 系 #num. *] (#title) \ #body]
})
}

/* when you use thmref, you should put a label like #definition[hoge<here>][hoge]*/
#let thmref(label, supplement: none) = {
locate(loc => {
  let elems = query(label, loc)
  if elems != (){
    let dict = s.at(elems.first().location())
    if supplement == none{
      dict.at("style") + " " + dict.at("heading").map(str).join(".") + "." + str(dict.at("counter"))
    }else{
      supplement + " " + dict.at("heading").map(str).join(".") + "." + str(dict.at("counter"))
    }
  }else{
    text(fill: red)[*???*]
  }
})
}
/* ---------------------------------------------------------------------------------*/

