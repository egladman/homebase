// Support port declaration inside href
document.addEventListener('click', function(event) {
    // Modified from:
    // https://stackoverflow.com/a/6016361

    var target = event.target;
    if (target.tagName.toLowerCase() == 'a') {
        var hrefValue = target.getAttribute('href');
        var port = hrefValue.match(/^:(\d+)(.*)/);
        if (port) {
            // Concat url subpath if it exists
            target.href = window.location.origin + hrefValue.replace(/^:(\d+)/, '');
            target.port = port[1];
        }
    }
}, false);

function getData(url, cb) {
  fetch(url)
    .then(response => response.json())
    .then(result => cb(result));
}

function renderTiles(obj) {
	obj.tiles.forEach(t => {
		var listItemElement = document.createElement("li");
    var descElement = document.createElement("p");
    var linkElement = document.createElement("a");
    var letterElement = document.createElement("span");

    descElement.textContent = t.description
    linkElement.href = t.href
    linkElement.textContent = t.name
    letterElement.textContent = t.name.charAt(0).toUpperCase()

    listItemElement.appendChild(linkElement);
    listItemElement.appendChild(descElement);
    listItemElement.appendChild(letterElement);

    var listElement = document.getElementsByClassName("auto-grid")[0];
    listElement.appendChild(listItemElement);
	});
}

function init() {
    getData("/homebase/settings/settings.json", (data) => renderTiles(data))

    // Replace title with url
    var host = window.location.host
    if (host.length == 0) {
        host = "homebase"
    }
    document.getElementById('homebase-title').innerHTML=window.location.host
};

window.addEventListener("load",init,false);
