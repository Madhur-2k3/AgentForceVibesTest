public with sharing class AgentforceRule20Variant {

    /**
     * Builds an HTTPS endpoint from a config map.
     * Safely handles null/missing keys and values.
     */
    public static String buildEndpoint(Map<String, String> config) {
        if (config == null) {
            return null;
        }
        String endpoint = config.get('endpoint');
        if (endpoint == null) {
            return null;
        }
        // Use regex to safely replace http:// with https://
        return endpoint.replaceAll('^http://', 'https://');
    }

    /**
     * Safely retrieves the Authorization header value from settings.
     * Handles null/missing keys and type casting safely.
     */
    public static String getHeaderValue(Map<String, Object> settings) {
        if (settings == null) {
            return null;
        }
        Object headersObj = settings.get('headers');
        if (headersObj == null) {
            return null;
        }
        // Safe cast to Map<String, String>
        if (!(headersObj instanceof Map<String, String>)) {
            return null;
        }
        Map<String, String> headers = (Map<String, String>) headersObj;
        return headers.get('Authorization');
    }
}
