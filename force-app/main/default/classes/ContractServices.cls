@RestResource(urlMapping='/ContractServices/*')
global class ContractServices {
    //Post method for contracts, the date format should respect YYYY-MM-DD
    @HttpPost
    global static String doPost(
        String Status,
        String StartDate,
        Integer ContractTerm,
        String AccountId
    ){
        Date newDate = Date.valueOf(StartDate);
        Contract contract = new Contract(
            Status = Status,
            StartDate = newDate,
            ContractTerm = ContractTerm,
            AccountId = AccountId
        );
        insert contract;
        return contract.Id;
    }

    @HttpPatch
    global static String doPatch(){
        RestRequest request = RestContext.request;
        String contactId = request.requestURI.substring(
            request.requestURI.lastIndexOf('/')+1
        );
        Contract cont = [SELECT Id FROM Contract WHERE Id = :contactId];
        Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(request.requestbody.toString());
        for(String fieldName : params.keySet()){
            cont.put(fieldName,params.get(fieldName));
        }
        update cont;
        return cont.Id;
    }
}