@RestResource(urlMapping='/AccountServices/*')
global class AccountServices {
    @HttpPost
    global static String doPost(
        String Name
    ){
        Account acc = new Account(
            Name = Name
        );
        insert acc;
        return acc.Id;
    }

    @HttpPatch
    global static String doPatch(){
        RestRequest request = RestContext.request;
        String accId = request.requestURI.substring(
            request.requestURI.lastIndexOf('/')+1
        );
        Account acc = [SELECT Id FROM Account WHERE Id = :accId];
        Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(request.requestbody.toString());
        for(String fieldName : params.keySet()){
            acc.put(fieldName,params.get(fieldName));
        }
        update acc;
        return acc.Id;
    }
}