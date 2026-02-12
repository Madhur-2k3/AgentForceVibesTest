public class ApiAuthCorrect {
    // Correct Apex: set expected headers per provider
    public static HttpResponse callOpenAi(String url, String key) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('POST');
        // ✅ Correct for OpenAI
        req.setHeader('Authorization', 'Bearer ' + key);
        req.setHeader('Content-Type', 'application/json');
        req.setBody('{}');
        Http http = new Http();
        return http.send(req);
    }

    public static HttpResponse callAnthropic(String url, String key) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('POST');
        // ✅ Correct for Anthropic
        req.setHeader('x-api-key', key);
        req.setHeader('Content-Type', 'application/json');
        req.setBody('{}');
        Http http = new Http();
        return http.send(req);
    }

    public static HttpResponse callAzureWithResourceKey(String url, String key) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('POST');
        // ✅ Correct for Azure resource key
        req.setHeader('api-key', key);
        req.setHeader('Content-Type', 'application/json');
        req.setBody('{}');
        Http http = new Http();
        return http.send(req);
    }

    public static HttpResponse callSalesforceApi(String url, String accessToken) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('GET');
        // ✅ Correct for Salesforce API access
        req.setHeader('Authorization', 'Bearer ' + accessToken);
        req.setHeader('Content-Type', 'application/json');
        Http http = new Http();
        return http.send(req);
    }
}
