Notes:

- the code that loads index.html is hardcoded in `kss_handlebars_generator.js` around the line that says "// Compile the Handlebars template."


To render both the raw and the baked in the guide: browser JS will need to:

x=document.querySelectorAll('[data-language="html"]')[4]
y=document.createElement('div')
y.innerHTML=x.innerText

and then pull out the Raw div and the baked Div.
