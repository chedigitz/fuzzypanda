Panda = Ember.Application.create();

Panda.Event = Ember.Object.extend({
    id: null, 
    title: null,
    price: null,
    image: null,
    venue: null,
    showdate: null,
    description: null
});

Panda.eventsController = Ember.ArrayController.create({
    content: [],
    loadEvents: function(){
    	var self = this;
    	$.getJSON('/fb/events', function(data){
    		data.forEach(function(item){
    			self.pushObject(Panda.Event.create(item));
    		});
    	});
    }
});

Panda.Book = Ember.Object.extend({
	title: null,
	author: null,
	genre: null
});
Panda.booksController = Ember.ArrayController.create({
	content: [],
	loadBooks: function(){
		var self = this;
		$.getJSON('/data/books.json', function(data) {
			data.forEach(function(item){
				self.pushObject(Panda.Book.create(item));
			});
		});
	}
});