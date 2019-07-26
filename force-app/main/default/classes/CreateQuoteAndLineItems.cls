public with sharing class CreateQuoteAndLineItems {
    @AuraEnabled
    public static String createQuoteAndLineItemsMethod(Quote newQuote, List<QuoteLineItem> newQuoteItems)
    {
        try
        {
            insert newQuote;

            QuoteLineItem qli = newQuoteItems[0];

            system.debug(qli);
            system.debug(qli.Product2Id);

            return 'Success';
        }
        catch(exception e)
        {
            system.debug(e.getMessage() + ' ' + e.getStackTraceString());
            return e.getMessage() + '\n' + e.getStackTraceString();
        }
    }
}
