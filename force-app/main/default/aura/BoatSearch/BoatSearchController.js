({
    onFormSubmit : function(component, event, helper) {
        console.log("event received by BoatSearchController.js");
        var formData = event.getParam('formData');
        var boatTypeId = formData.boatTypeId;
        console.log('boatTypeId: ' + boatTypeId);
        var boatSearchResultsComponent = component.find("boatSearchResultComponent");
        var auraMethodResult = boatSearchResultsComponent.search(boatTypeId);
        console.log("auraMethodResult: " + auraMethodResult);
    }
})