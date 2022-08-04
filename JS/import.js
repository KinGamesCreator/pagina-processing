function loadFile (_file,element) {
    fetch(_file)
    .then(function(response){
        return response.text();
    })
    .then(function(data){
        element.innerHTML = data;
    }).catch(function(error){});
}

var elements = document.getElementsByTagName("import");

for (var i = 0; i < elements.length; i++) {
    let load = elements[i].getAttribute("src");
    if (load == null || load == undefined) continue;
    loadFile(load,elements[i]);
}