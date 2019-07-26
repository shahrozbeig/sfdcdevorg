({
    getBoatsOnInit : function(component, event, helper) {
        helper.onSearch(component);
    },

    search: function(component, event, helper){
        console.log('search called from Parent:');
        var params = event.getParam('arguments');
        var btId = params.boatTypeId;
        console.log("boatTypeId extracted: " + btId);
        component.set("v.boatTypeId", btId);
        var dosearch = component.get('c.doSearch');
        $A.enqueueAction(dosearch);
    },

    doSearch : function(component, event, helper){
        console.log('do search called');
        console.log('boatTypeId in BSR controller: ' + component.get('v.boatTypeId'));
        helper.onSearch(component);
        return "search complete.";
    },

    onBoatSelect : function(component, event, helper) {
        var selectedBoatId = event.getParam('boatId');
        console.log('selectedBoatId: ' + selectedBoatId);
        component.set('v.selectedBoatId' , selectedBoatId);
        
    }
})