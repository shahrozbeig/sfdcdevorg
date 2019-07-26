({
    onFullDetails : function(component, event, helper) {
        var boatId = component.get('v.boat').Id;
        var sObectEvent = $A.get("e.force:navigateToSObject");
        sObectEvent .setParams({
            "recordId": boatId,
            "slideDevName": "detail"
          });
          sObectEvent.fire(); 
    }
})