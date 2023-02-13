@RestResource(urlMapping='/ContactServices/*')
global class ContactServices {
    global class getContact{
        String FirstName{get;set;}
        String LastName{get;set;}
        String Email{get;set;}
    }

    @HttpPost
    global static String doPost(
        String FirstName,
        String LastName,
        String Email
    ){
        String contactId;
        List<Contact> cont = [SELECT Id FROM Contact WHERE Email = :Email];
        if(cont.size()>0){
            contactId = cont[0].Id;
        }
        else{
            Contact contact = new Contact(
                FirstName = FirstName,
                LastName = LastName,
                Email = Email
            );
            insert contact;
            contactId = contact.Id;
        }
        
        return contactId;
    }

    @HttpPatch
    global static String doPatch(){
        RestRequest request = RestContext.request;
        String contactId = request.requestURI.substring(
            request.requestURI.lastIndexOf('/')+1
        );
        Contact cont = [SELECT Id FROM Contact WHERE Id = :contactId];
        Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(request.requestbody.toString());
        for(String fieldName : params.keySet()){
            cont.put(fieldName,params.get(fieldName));
        }
        update cont;
        return cont.Id;
    }

    @HttpDelete
    global static String doDelete(){
        RestRequest request = RestContext.request;
        String contactId = request.requestURI.substring(
            request.requestURI.lastIndexOf('/')+1
        );
        Contact cont = [SELECT Id,isActive__c FROM Contact WHERE Id = :contactId];
        cont.isActive__c = false;
        update cont;
        return cont.Id;
    }
}