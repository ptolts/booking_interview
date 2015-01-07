Booking.prototype.fastJSON = function(){
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

function Booking(data) {
    data = data || {};
    var self = this;
    self.id = ko.observable(data.id ? data.id : null);  
    self.start_date = ko.observable(data.start_date);
    self.end_date = ko.observable(data.end_date);
    self.price = ko.observable(data.price);
}