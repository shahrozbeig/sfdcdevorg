({
    onBoatSelected : function(component, event, helper) {
        var boat = event.getParam("boat");
        console.log('boat & Id: ' + JSON.stringify(boat) + ' - ' + boat.Contact__r.Name);
        component.set('v.boat', boat);
        component.set('v.id', boat.Id);
        var service = component.find("service");
        service.reloadRecord() ;

        var boatReviewsComponent = component.find("boatReviewsComponent");
        console.log(boatReviewsComponent);
        var auraMethodResult = boatReviewsComponent.refresh();
    },

    onRecordUpdated : function(component, event, helper) {

    },    
    
    onBoatReviewAdded : function(component, event, helper) {
        console.log("Event received");
        component.find("tabs").set("v.selectedTabId", 'boatReviewTab');
        debugger
		var boatReviewsComponent = component.find("boatReviewsComponent");
        console.log(boatReviewsComponent);
        var auraMethodResult = boatReviewsComponent.refresh();	
    },
})