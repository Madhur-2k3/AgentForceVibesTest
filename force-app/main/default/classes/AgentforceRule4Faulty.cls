public class AgentforceRule4Faulty {
    public static void demonstrate() {
        Map<String, Object> cfg = new Map<String, Object>{ 'endpoint' => 'https://api.example.com' };
        Object connector = ConnectorFactory.createConnector('http', cfg);
    }
}
