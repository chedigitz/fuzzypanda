Panda = Ember.Application.create();


//MODELS 
Panda.Event = Ember.Resource.extend({
    resourceUrl: '/fb/events',
    resourceName: 'event'
});


//CONTROLLERS 
Panda.eventsController = Ember.ResourceController.create({
    resourceType: Panda.Event,
    selected: null
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

Panda.selectedPhotoController = Ember.Object.create({
      contentBinding: 'Panda.eventsListController.selected'
});

//views
Panda.stateManager = Ember.StateManager.create({
    rootElement: 'mainArea',
    initialState: 'showEventView',

    showEventView: Ember.ViewState.create({
        enter: function(stateManager){
            this._super(stateManager);
            Panda.eventListController.findAll();
        },
        view: Ember.ContainerView.create({
           childViews: ['eventListView', 'controlButtonView', 'selectedEventView'],

           eventListView: Ember.View.extend({
                templateName: 'event-view-list',
                contentBinding: 'Panda.EventListController.content',
                classNames: ['thumbnailViewList']
           }),

           selectedEventView: Ember.View.extend({
             templateName: 'selected-event',
             contentBinding: 'Panda.SelectedEventController.content',
             classNames: ['selectedEvent']
           }),

            controlButtonView: Ember.View.extend({
                templateName: 'event-view-list',
                classNames: 'controlButtons'
            })
        })
            
    })
});


Panda.ThumbnailPhotoView = Ember.View.extend({
    click: function(evt){
        Panda.eventListController.get('selected', this.get('content'));

    },
    classNameBindings: "isSelected",

    isSelected: function() {
        return Panda.eventListController.get('selected') == this.get('content');
    }.property('Panda.eventListController.selected')
});

Panda.SelectedPhotoView = Ember.View.extend({

});
