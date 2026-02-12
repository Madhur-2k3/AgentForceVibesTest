public class AgentforceRule20Faulty {
    
    // Rule 20: Map.containsKey() before get, and null-safety before usage
    public static String getApiKey(Map<String, Object> config) {
        if (config == null || !config.containsKey('apiKey')) {
            return '';
        }
        String apiKey = (String) config.get('apiKey');
        return String.isNotBlank(apiKey) ? apiKey.toUpperCase() : '';
    }

    public static String getNestedValue(Map<String, Object> config) {
        if (config == null || !config.containsKey('credentials')) {
            return '';
        }
        Object credsObj = config.get('credentials');
        if (!(credsObj instanceof Map<String, Object>)) {
            return '';
        }
        Map<String, Object> creds = (Map<String, Object>) credsObj;
        if (!creds.containsKey('secret')) {
            return '';
        }
        String secret = (String) creds.get('secret');
        return String.isNotBlank(secret) ? secret.trim() : '';
    }
}
