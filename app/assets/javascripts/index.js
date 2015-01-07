ko.bindingHandlers.datepicker = {
    update: function (element, valueAccessor, allBindingsAccessor) {
        var value = valueAccessor();
        $(element).datepicker({
            onSelect:function(dateText,inst){
              var format = "%m/%d/%Y";
              var d = jdate.strptime(dateText,format); 
              value(d);
            },
            defaultDate: value(),
        });

        console.log(value());

        $(element).val(jdate.strftime(value(),"%m/%d/%Y"));
        // value(jdate.strftime(value(),"%m/%d/%Y"));

        ko.utils.domNodeDisposal.addDisposeCallback(element, function() {
          $(element).datepicker( "destroy" );
        });
    },
}

var fetch_bookings;

function IndexModel() {
	var self = this;
	self.apartments = ko.observableArray();
	self.bookings = ko.observableArray();
	self.selected_apartment = ko.observable();

    self.monitor_selected_apartment = ko.computed(function(){
        self.selected_apartment();
        if(!ko.computedContext.isInitial()){
            self.selected_apartment().check_availability();    
        }        
    });	

	// Load apartments
	$.ajax({
	    type: "POST",
	    url: "/apartment/all",
	    success: function(data, textStatus, jqXHR){
			self.apartments(_.map(data,function(apartment){ return new Apartment(apartment); }));
	    },
	    dataType: "json"
	});

	fetch_bookings = function(){
		$.ajax({
		    type: "POST",
		    url: "/booking/all",
		    success: function(data, textStatus, jqXHR){
				self.bookings(_.map(data,function(booking){ return new Booking(booking); }));
		    },
		    dataType: "json"
		});
	}
	fetch_bookings();
}