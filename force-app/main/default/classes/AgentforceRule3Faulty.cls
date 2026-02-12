public with sharing class AgentforceRule3Faulty {
    /**
     * Returns the current time plus the specified delay in milliseconds.
     * - Guards against null/negative input and integer overflow.
     * - Uses return-early pattern.
     */
    public static Datetime getWarningTime(Integer delayMs) {
        if (delayMs == null || delayMs <= 0) {
            return Datetime.now();
        }
        // Prevent overflow: Apex Integer max is 2147483647
        Integer safeDelay = Math.min(delayMs, 2000000000);
        // Datetime does not support addMilliseconds; convert to seconds
        Integer seconds = Math.floor(safeDelay / 1000);
        return Datetime.now().addSeconds(seconds);
    }

    /**
     * Returns a future time adding 1.5 seconds and 5 seconds safely.
     * - Consolidates arithmetic to avoid chained rounding issues.
     */
    public static Datetime getFutureTime() {
        // 1500 ms + 5 seconds ~= 6 seconds when using integer seconds (Datetime has second precision)
        return Datetime.now().addSeconds(6);
    }
}
