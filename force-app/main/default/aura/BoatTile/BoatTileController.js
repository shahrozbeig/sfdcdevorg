({
    onBoatClick : function(component, event, helper) {
        var boat = component.get('v.boat');
        console.log('boat: ' + JSON.stringify(boat));
        console.log('oat Id: ' + boat.Id);
        var boatSelectEvent = component.getEvent('boatSelect');
        boatSelectEvent.setParams({
            'boatId' : boat.Id
        });
        boatSelectEvent.fire();

        var boatSelectedEvent = $A.get('e.c:BoatSelected');
        boatSelectedEvent.setParams({
            'boat' : boat
        });
        boatSelectedEvent.fire();

        var plotEvent = $A.get("e.c:PlotMapMarker");
          
        plotEvent.setParams({
            "lat": boat.Geolocation__Latitude__s,
            "sObjectId": boat.Id,
            "long": boat.Geolocation__Longitude__s,
            "label":boat.Name
        });
        plotEvent.fire(); 
    }
})