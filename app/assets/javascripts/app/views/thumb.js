Panda.ThumbnailPhotoView = Ember.View.extend({
    click: function(evt){
        Panda.eventsController.get('selected', this.get('content'));
        alert("pureawesomeness") 
    },
    classNameBindings: "isSelected",
    
    isSelected: function() {
        return Panda.eventsController.get('selected') == this.get('content');
    }.property('Panda.eventsController.selected')
});