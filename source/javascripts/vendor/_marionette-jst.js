function addUnderscore(filePath){
    parts = filePath.split("/");
    parts[parts.length-1] = "_" + parts[parts.length-1];
    return parts.join("/");
}
Backbone.Marionette.Renderer.render = function(template, data){
    template = "templates/" + addUnderscore(template);
    return JST[template](data);
};
