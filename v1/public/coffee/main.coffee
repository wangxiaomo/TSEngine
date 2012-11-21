requirejs.config {
  baseUrl: "public/js"
}

requirejs(['common'], (common)->
  console.log("Hello World")
  console.log(common)
)
