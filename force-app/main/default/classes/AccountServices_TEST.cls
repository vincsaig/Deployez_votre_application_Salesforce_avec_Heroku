@isTest
public class AccountServices_TEST {
    @isTest
    public static void testPostAccount(){
        test.startTest();
        Id accId = AccountServices.doPost('testAccount');
        test.stopTest();
        Account acc = [SELECT Name FROM Account WHERE Id =:accId];
        System.assertEquals('testAccount',acc.Name);
    }

    @isTest
    public static void testPatchAccount(){
        Account acc = new Account(
            Name = 'testAccount'
        );
        insert acc;

        RestRequest request = new RestRequest();
        request.requestURI = 'https://playful-koala-9dah03-dev-ed.lightning.force.com/services/apexrest/AccountServices/' + acc.Id;
        request.httpMethod = 'PATCH';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"Name": "testAccountUpdate"}');
        RestContext.request = request;

        test.startTest();
        Id accId = AccountServices.doPatch();
        test.stopTest();

        System.assert(accId != null, 'No Id was returned no contact was updated');
        acc = [SELECT Name FROM Account WHERE Id =:accId];
        System.assert(acc != null, 'Not contact was found with given Id');
        System.assertEquals('testAccountUpdate',acc.Name);
    }
}