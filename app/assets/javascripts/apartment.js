Apartment.prototype.fastJSON = function(){
    var fast = {};
    for (var property in this) {
        if (this.hasOwnProperty(property)) {
            var result = this[property];
            while(ko.isObservable(result)){
                result = result.peek();
            }
            if(typeof result == "function"){
                continue;
            }
            if(typeof result == "object"){
                if(result == null){
                    fast[property] = result;
                    continue;
                }                             
                if(Array.isArray(result)){
                    continue;
                }
                if(result.fastJSON){
                    continue;
                }
            }         
            fast[property] = result;
        }
    } 
    return JSON.stringify(fast);    
}

function Apartment(data) {
    data = data || {};
    var self = this;
    self.id = ko.observable(data.id ? data.id : null);  
    self.start_date = ko.observable(new Date());
    self.end_date = ko.observable(new Date());
    self.available = ko.observable();
    self.price = ko.observable();
    self.cleaning_fee = ko.observable(data.cleaning_fee);
    self.currency = ko.observable(data.currency);
    self.saved = ko.observable(false);

    self.book = function(){
        self.saved(false);
        $.ajax({
            type: "POST",
            url: "/booking/book",
            data: {
                data: self.fastJSON(),
            },
            success: function(data, textStatus, jqXHR){
                fetch_bookings();
            },
            error: function(XMLHttpRequest, textStatus, errorThrown) {
                
            },
            dataType: "json"
        });
    }

    self.check_availability = function(){
        self.saved(false);
        $.ajax({
            type: "POST",
            url: "/booking/check_availability",
            data: {
                data: self.fastJSON(),
            },
            success: function(data, textStatus, jqXHR){
                self.available(data.availability);
                self.price(data.price);
            },
            error: function(XMLHttpRequest, textStatus, errorThrown) {
                
            },
            dataType: "json"
        });
    }    

    self.trackChanges = ko.computed(function(){
        self.start_date();
        self.end_date();
        if(!ko.computedContext.isInitial()){
            self.check_availability();    
        }        
    }).extend({ notify: 'always', rateLimit: 0 });      
}