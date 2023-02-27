@isTest
public class ContractServices_TEST {
    @isTest
    public static void testPostContract(){
        Account acc = new Account(Name = 'Contract account');
        insert acc;

        test.startTest();
        Id contractId = ContractServices.doPost('Draft', '2023-12-01', 6,acc.Id);
        test.stopTest();
        Contract cont = [SELECT Status, StartDate, ContractTerm, AccountId FROM Contract WHERE Id =:contractId];
        Date newDate = Date.valueOf('2023-12-01');
        System.assertEquals('Draft',cont.Status);
        System.assertEquals(newDate, cont.StartDate);
        System.assertEquals(6, cont.ContractTerm);
        System.assertEquals(acc.Id, cont.AccountId);
    }

    @isTest
    public static void testPatchContract(){
        Account acc = new Account(Name = 'Contract account');
        insert acc;
        Contract cont = new Contract(
            Status = 'Draft',
            StartDate = Date.valueOf('2023-12-01'),
            ContractTerm = 6,
            AccountId = acc.Id
        );
        insert cont;
        RestRequest request = new RestRequest();
        request.requestURI = 'https://playful-koala-9dah03-dev-ed.lightning.force.com/services/apexrest/ContractServices/' + cont.Id;
        request.httpMethod = 'PATCH';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"Status": "Activated"}');
        RestContext.request = request;

        test.startTest();
        Id contractId = ContractServices.doPatch();
        test.stopTest();

        System.assert(contractId != null, 'No Id was returned no contact was updated');
        cont = [SELECT Status FROM Contract WHERE Id =:contractId];
        System.assert(cont != null, 'Not contact was found with given Id');
        System.assertEquals('Activated',cont.Status);
    }
}