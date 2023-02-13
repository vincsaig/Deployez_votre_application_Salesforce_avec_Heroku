@isTest
public class ContactServices_TEST {
    @isTest
    public static void testPostContact(){
        test.startTest();
        Id contactId = ContactServices.doPost('Vincent', 'Saignol', 'testpost@test.com');
        test.stopTest();
        Contact cont = [SELECT Id,FirstName,LastName,Email FROM Contact WHERE Id =:contactId];
        System.assertEquals('Vincent',cont.FirstName);
        System.assertEquals('Saignol', cont.LastName);
        System.assertEquals('testpost@test.com', cont.Email);
    }

    @isTest
    public static void testPatchContact(){
        Id recordId = createContact();
        RestRequest request = new RestRequest();
        request.requestURI = 'https://playful-koala-9dah03-dev-ed.lightning.force.com/services/apexrest/ContactServices/' + recordId;
        request.httpMethod = 'PATCH';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"FirstName": "Jack","LastName": "Lantern", "Email": "testpatch@test.com"}');
        RestContext.request = request;

        test.startTest();
        Id contactId = ContactServices.doPatch();
        test.stopTest();

        System.assert(contactId != null, 'No Id was returned no contact was updated');
        Contact cont = [SELECT FirstName, LastName, Email FROM Contact WHERE Id =:contactId];
        System.assert(cont != null, 'Not contact was found with given Id');
        System.assertEquals('Jack',cont.FirstName);
        System.assertEquals('Lantern',cont.LastName);
        System.assertEquals('testpatch@test.com',cont.Email);
    }

    @isTest
    public static void testDeleteContact(){
        Id recordId = createContact();
        RestRequest request = new RestRequest();
        request.requestURI = 'https://playful-koala-9dah03-dev-ed.lightning.force.com/services/apexrest/ContactServices/' + recordId;
        request.httpMethod = 'DELETE';
        RestContext.request = request;

        test.startTest();
        Id contactId = ContactServices.doDelete();
        test.stopTest();

        System.assert(contactId != null, 'No Id was returned no contact was updated');
        Contact cont = [SELECT isActive__c FROM Contact WHERE Id =:contactId];
        System.assert(cont != null, 'Not contact was found with given Id');
        System.assertEquals(false, cont.isActive__c,'The contact should not be active');
    }


    static Id createContact(){
        Contact cont = new Contact(
            FirstName = 'Vincent',
            LastName = 'Saignol',
            Email = 'test@test.com'
        );
        insert cont;
        return cont.Id;
    }
}