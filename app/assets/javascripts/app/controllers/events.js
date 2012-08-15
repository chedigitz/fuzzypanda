//CONTROLLERS 
Panda.eventsController = Ember.ResourceController.create({
    content: [],
    resourceType: Panda.Event,
    selected: null,
    
    findSelectedItemIndex: function() {
    var content = this.get('content');

    for (index = 0; index < content.get('length'); index++) {
      if (this.get('selected') === content.objectAt(index)) {
        return index;
       }
    }

    return 0;
    }
});


Panda.eventListController = Ember.ResourceController.create({
    content: [],
    resourceType: Panda.Event,
    selected: null,
    timerid: null,

    findSelectedItemIndex: function() {
    var content = this.get('content');

    for (index = 0; index < content.get('length'); index++) {
      if (this.get('selected') === content.objectAt(index)) {
        return index;
       }
    }

    return 0;
    }
});

Panda.SelectedPhotoController = Ember.Object.create({
      contentBinding: 'Panda.eventsController.selected'
});