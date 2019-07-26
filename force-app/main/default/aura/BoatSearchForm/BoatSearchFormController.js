({
    doInit : function(component, event, helper) {
        // helper.getBoatTypesHelper(component, event, helper);
        console.log('Init started');
        var action = component.get("c.getBoatTypes");
        action.setCallback(this, function(response) {
            console.log('apex called');
            var state = response.getState();
            console.log("state: " + state);
            if (state == "SUCCESS") {
                console.log('aya andar' + JSON.stringify(response.getReturnValue()));
                component.set('v.boatTypes', response.getReturnValue());
            } else {
                console.log('Apex mein error hai');
            }
        });
        $A.enqueueAction(action);

    },

    handleBoatTypeChange : function(component, event, helper) {
        if(component.find('boattype').get("v.value") === 'all') {
            component.set('v.selectedBoatTypeId', '');
        } else 
            component.set('v.selectedBoatTypeId', component.find('boattype').get("v.value"));
        console.log(component.find('boattype').get("v.value"));
    },

    onFormSubmit : function(component, event, helper) {
        var formSubmitEvent = component.getEvent("formsubmit");
        var boatTypeId = component.get("v.selectedBoatTypeId");
        console.log('id: ' + component.get('v.selectedBoatTypeId'));
        formSubmitEvent.setParams({"formData":
            {"boatTypeId" : boatTypeId}
        });
        formSubmitEvent.fire();
    }
})