1.1 Compilation Errors
Rule 1: SOQL Query Field Coverage
Error: SObject row was retrieved via SOQL without querying field

This is the #1 mistake AI makes. It queries an object but forgets to include fields that are accessed later.

// ❌ WRONG - AI often generates this
Account acc = [SELECT Id FROM Account WHERE Id = :accountId];
String name = acc.Name;  // 💥 ERROR! Name not queried

// ✅ RIGHT - All accessed fields must be in SELECT
Account acc = [SELECT Id, Name, Industry FROM Account WHERE Id = :accountId];
String name = acc.Name;
Why AI fails: LLMs see acc.Name as valid property access (which it is syntactically), but don’t understand Salesforce’s runtime field verification.

Rule 2: Relationship Fields in SOQL
Error: System.SObjectException: SObject row was retrieved via SOQL without querying the requested field

// ❌ WRONG - Parent field not queried
Contact c = [SELECT Id, Name FROM Contact LIMIT 1];
String accountName = c.Account.Name;  // 💥 ERROR!

// ✅ RIGHT - Use dot notation in SELECT
Contact c = [SELECT Id, Name, Account.Name FROM Contact LIMIT 1];
String accountName = c.Account.Name;
AI Pattern to Watch: When AI generates code that traverses relationships like record.Parent.Field, always verify the SELECT clause includes Parent.Field.

Rule 3: Datetime Methods – No addMilliseconds()
Error: Method does not exist: addMilliseconds

AI often suggests Java/JavaScript patterns that don’t exist in Apex:

// ❌ WRONG - Method does not exist in Salesforce Apex
Datetime warning = Datetime.now().addMilliseconds(5000);  // 💥 COMPILE ERROR!

// ✅ RIGHT - Use existing methods
Datetime warning = Datetime.now().addSeconds(5);
Available Datetime methods:

addDays()
addHours()
addMinutes()
addSeconds()
addMonths()
addYears()
NOT available: addMilliseconds(), addWeeks()

Rule 5: Non-Existent Types
Error: Invalid type: StringBuffer

AI loves to use Java classes that don’t exist in Apex:

// ❌ WRONG - StringBuffer doesn't exist in Apex
StringBuffer buffer = new StringBuffer();  // 💥 COMPILE ERROR!

// ✅ RIGHT - Use String or List<String>
List<String> parts = new List<String>{'part1', 'part2'};
String result = String.join(parts, '');
Common Java types NOT in Apex:

StringBuffer / StringBuilder → Use String or List<String>
HashMap → Use Map<K,V>
ArrayList → Use List<T>
Optional → Use null checks

Rule 11: LWC – No Inline Expressions
Error: LWC1083: Invalid expression

<!-- ❌ WRONG - Inline expressions NOT allowed in LWC -->
<template>
    <p>{record.Name + ' - ' + record.Industry}</p>
    <p>{items.length > 0}</p>
</template>

<!-- ✅ RIGHT - Use JavaScript getters -->
<template>
    <p>{formattedName}</p>
    <p>{hasItems}</p>
</template>
// In your .js file
get formattedName() {
    return this.record ? `${this.record.Name} - ${this.record.Industry}` : '';
}

get hasItems() {
    return this.items && this.items.length > 0;
}
Why this matters: AI trained on React/Vue generates expressions like {count + 1} or {isActive ? 'Yes' : 'No'} which are perfectly valid there but cause LWC compilation failures.


Rule 12: LWC Templates – No Object Literals
Error: LWC1535/LWC1083 Compilation Error

<!-- ❌ WRONG - Object literals NOT allowed -->
<c-component headers={{"Authorization": "Bearer token"}}></c-component>

<!-- ✅ RIGHT - Define in JavaScript -->
<c-component headers={httpHeaders}></c-component>
get httpHeaders() {
    return { "Authorization": "Bearer " + this.token };
}

Rule 13: LWC Template – No Ternary Operators
Error: LWC1060: Template expression doesn't allow ConditionalExpression

<!-- ❌ WRONG - Ternary not allowed in LWC templates -->
<span>{count === 1 ? 'item' : 'items'}</span>

<!-- ✅ RIGHT - Use getter -->
<span>{itemLabel}</span>
get itemLabel() {
    return this.count === 1 ? 'item' : 'items';
}

Rule 14: LWC Template – No Binary Expressions
Error: LWC1060: Template expression doesn't allow BinaryExpression

<!-- ❌ WRONG - Arithmetic not allowed -->
<span>Row {index + 1}</span>

<!-- ✅ RIGHT - Compute in JavaScript -->
<span>Row {rowNumber}</span>
get rowNumber() {
    return this.index + 1;
}




Rule 16: LWC Decorators – Must Import from lwc
Error: LWC1102: Invalid decorator usage

AI sometimes forgets the import statement:

// ❌ WRONG - Decorators not imported
export default class MyComponent extends LightningElement {
    @api value;  // 💥 Error!
}

// ✅ RIGHT - Always import decorators
import { LightningElement, api, track, wire } from 'lwc';

export default class MyComponent extends LightningElement {
    @api value;
}

1.3 Runtime Errors
Rule 18: Null Checks Before Field Access
Error: System.NullPointerException: Attempt to de-reference a null object

This is the most common runtime error in AI-generated Apex:

// ❌ WRONG - No null check
String name = account.Name.toUpperCase();  // 💥 NullPointerException if Name is null

// ✅ RIGHT - Null-safe access
String name = String.isNotBlank(account.Name) ? account.Name.toUpperCase() : '';


Rule 20: Map.containsKey() Before Get
Error: Attempt to de-reference a null object

// ❌ WRONG - Key may not exist
String apiKey = (String) config.get('apiKey');  // May return null!

// ✅ RIGHT - Check before access
if (config.containsKey('apiKey')) {
    String apiKey = (String) config.get('apiKey');
}


Rule 21: Recursive Trigger Prevention
Error: Maximum stack depth reached

AI-generated triggers often lack recursion guards:

// ❌ WRONG - Can cause infinite loop
trigger AccountTrigger on Account (after update) {
    update accountsToUpdate;  // 💥 Triggers itself again!
}

// ✅ RIGHT - Use static flag
public class TriggerHandler {
    private static Boolean isExecuting = false;
    
    public static void handle(List<Account> accounts) {
        if (isExecuting) return;
        isExecuting = true;
        // Process...
        isExecuting = false;
    }
}

Rule 25: Permission Set – Apex Class Permissions
Error: Insufficient access

<!-- ADD THIS for every new Apex class -->
<classAccesses>
    <apexClass>NewClassName</apexClass>
    <enabled>true</enabled>
</classAccesses>


Rule 35: API Key Authentication Patterns
Different providers require different header formats. AI often uses the wrong one:

Provider	Header Format
OpenAI	Authorization: Bearer {key}
Anthropic	x-api-key: {key}
Azure OpenAI	api-key: {key}
Salesforce	Authorization: Bearer {access_token}

1.6 Agentforce/Flow Specific Failures
Rule 37: Unable to Find Apex Action Method
Error: Unable to find Apex action method

For LWC to call Apex methods, all these must be true:

// ✅ REQUIRED checklist:
// - Method exists in Apex class
// - Method has @AuraEnabled decorator
// - Method is public static
// - Class is deployed to org

@AuraEnabled
public static String myMethod() {
    return 'Hello';
}

Rule 38: InvocableVariable Type Restrictions
Error: InvocableVariable fields do not support type

AI generates custom wrapper classes for Flow, but Flow has type restrictions:


// ❌ WRONG - Custom class not supported
@InvocableVariable
public List<AccountList> accounts;  // 💥 Invalid!

// ✅ RIGHT - Use standard types only
@InvocableVariable
public List<Account> accounts;  // sObject types work


Rule 39: InvocableMethod Return Type for Agentforce
Error: Agentforce can’t parse return value

For Agentforce to work with your Apex actions:

// ✅ REQUIRED for Agentforce
@JsonAccess(serializable='always' deserializable='always')
public class AccountData {
    @AuraEnabled public String name;
    @AuraEnabled public String industry;
}

Rule 41: Agentforce ValueChange Event
Error: Agentforce doesn’t receive user input

Custom LWC editors in Agentforce must dispatch valuechange:

// ✅ REQUIRED - Dispatch valuechange event
handleSelectionChange(event) {
    this._value = event.detail.value;
    this.dispatchEvent(new CustomEvent('valuechange', {
        detail: { value: this._value }
    }));
}

