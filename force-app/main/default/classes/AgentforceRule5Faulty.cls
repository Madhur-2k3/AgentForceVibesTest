public with sharing class AgentforceRule5Faulty {

    /**
     * Builds a combined string using Apex String concatenation.
     * Apex doesn't support Java's StringBuffer class.
     */
    public static String buildCombinedString() {
        String result = '';
        result += 'part1';
        result += 'part2';
        return result;
    }

    /**
     * Demonstrates Apex collections (not Java util.*).
     * Uses Map<String, String> and List<String>.
     */
    public static void useApexCollections() {
        // Apex generics must not include spaces around commas or inside angle brackets
        Map<String,String> mapVal = new Map<String,String>();
        mapVal.put('k','v');

        List<String> listVal = new List<String>();
        listVal.add('one');
    }

    /**
     * Safely returns first element of a list or a fallback when list is null/empty.
     * Apex has no Optional; use null checks and ternary operator.
     */
    public static String maybeGet(List<String> items) {
        return (items != null && !items.isEmpty() && items[0] != null) ? items[0] : 'fallback';
    }
}
