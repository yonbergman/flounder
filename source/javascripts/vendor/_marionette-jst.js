Backbone.Marionette.Renderer.render = function(template, data){
    template = "templates/_" + template;
    return JST[template](data);
};
