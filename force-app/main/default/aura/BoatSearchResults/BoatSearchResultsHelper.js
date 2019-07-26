({
    onSearch : function(component) {
        console.log('on seaarch called');
        console.log('boatTypeId in BSR helper: ' + component.get('v.boatTypeId'));
        var action = component.get('c.getBoats');
        action.setParams({
            boatTypeId : component.get('v.boatTypeId')
        });        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS') {
                var boats = response.getReturnValue();
                console.log('###: ' + boats);
                console.log('###: ' + JSON.stringify(boats));
                if(boats !== undefined) {
                    component.set('v.boats', boats);
                }
            } else {
                console.log('Error in apex');
            }
        });
        $A.enqueueAction(action);
    }
})