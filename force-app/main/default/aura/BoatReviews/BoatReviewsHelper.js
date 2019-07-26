({
    onInit : function(component, event, helper) {
        console.log('init brc');
        var boatReviews = component.get('v.boatReviews');
        var boat = component.get('v.boat');
        var boatId = boat.Id;
        var action = component.get('c.getAll');
        action.setParams({
            'boatId' : boatId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS') {
                component.set('v.boatReviews', response.getReturnValue());
            } else {
                console.log('Error in apex from BoatREviews Get all');            }
        });
        $A.enqueueAction(action);

    }
})