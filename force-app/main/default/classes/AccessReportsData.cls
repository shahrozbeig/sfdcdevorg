public with sharing class AccessReportsData {
    public static void getReportData() {
        // Get the report ID
        List <Report> reportList = [SELECT Id,DeveloperName FROM Report where
                                    Id = '00O380000055vIREAY'];
        //String reportId = (String)reportList.get(0).get('Id');
            
        String reportId = '00O380000055vIREAY';
            
        // Run a report synchronously
        Reports.reportResults results = Reports.ReportManager.runReport(reportId, true);
            
        // Get the first down-grouping in the report
        Reports.Dimension dim = results.getGroupingsDown();
        /* Reports.GroupingValue groupingVal = dim.getGroupings()[0].getGroupings()[0].getGroupings()[0];
        System.debug('Key: ' + groupingVal.getKey());
        System.debug('Label: ' + groupingVal.getLabel());
        System.debug('Value: ' + groupingVal.getValue());
        */
            
        List<Id> listofOppIds = new List<Id>();
        for (Integer i = 0; i < dim.getGroupings().size(); i++) {
            for (Integer j = 0; j < dim.getGroupings()[i].getGroupings().size(); j++) {
                for (Integer k = 0; k < dim.getGroupings()[i].getGroupings()[j].getGroupings().size(); k++) {
                    Reports.GroupingValue groupingVal = dim.getGroupings()[i].getGroupings()[j].getGroupings()[k];
                    //System.debug('Key: ' + groupingVal.getKey());
                    //System.debug('Label: ' + groupingVal.getLabel());
                    //System.debug('Value: ' + groupingVal.getValue());

                    // Construct a fact map key, using the grouping key value      
                    String factMapKey = groupingVal.getKey() + '!T';
                                    
                    // Get the fact map from the report results
                    Reports.ReportFactWithDetails factDetails =
                        (Reports.ReportFactWithDetails)results.getFactMap().get(factMapKey);
                                    
                    // Get the first summary amount from the fact map
                    Reports.SummaryValue sumVal = factDetails.getAggregates()[0];
                    //System.debug('Summary Value: ' + sumVal.getLabel());
                                    
                    // Get the field value from the first data cell of the first row of the report
                    for (Integer l = 0; l < factDetails.getRows().size(); l++) {
                        Reports.ReportDetailRow detailRow = factDetails.getRows()[l];
                        /* System.debug('label: ' + detailRow.getDataCells()[1].getLabel());
                        System.debug('value: ' + detailRow.getDataCells()[1].getValue()); */
                        listofOppIds.add(detailRow.getDataCells()[1].getValue());
                    }
                }
            }
        }
        System.debug('value: ' + listofOppIds);       
    }
}
