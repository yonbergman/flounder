Backbone.Marionette.Renderer.render = function(template, data){
    template = "templates/" + template;
    return JST[template](data);
};
