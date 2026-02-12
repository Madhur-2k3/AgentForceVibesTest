public class ApiAuthFaulty {
    // Faulty Apex: missing or wrong header usage for various providers
    public static HttpResponse callOpenAi(String url, String key) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('POST');
        // ❌ WRONG: using x-api-key for OpenAI (should be Authorization: Bearer)
        req.setHeader('x-api-key', key);
        req.setHeader('Content-Type', 'application/json');
        req.setBody('{}');
        Http http = new Http();
        return http.send(req);
    }

    public static HttpResponse callAnthropic(String url, String key) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('POST');
        // ❌ WRONG: using Authorization: Bearer for Anthropic (Anthropic expects x-api-key)
        req.setHeader('Authorization', 'Bearer ' + key);
        req.setHeader('Content-Type', 'application/json');
        req.setBody('{}');
        Http http = new Http();
        return http.send(req);
    }

    public static HttpResponse callAzure(String url, String key) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('POST');
        // ❌ WRONG: using Authorization: Bearer with resource key (should be api-key)
        req.setHeader('Authorization', 'Bearer ' + key);
        req.setHeader('Content-Type', 'application/json');
        req.setBody('{}');
        Http http = new Http();
        return http.send(req);
    }
}
