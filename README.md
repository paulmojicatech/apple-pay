# apple-pay

Capacitor plugin to integrate Apple Pay into application

## Install

```bash
npm install @paulmojicatech/apple-pay
npx cap sync
```

## API

<docgen-index>

* [`echo(...)`](#echo)
* [`canMakePayments()`](#canmakepayments)
* [`showApplePaySheet(...)`](#showapplepaysheet)
* [`showInAppPurchaseSheet(...)`](#showinapppurchasesheet)
* [`addListener(string, ...)`](#addlistenerstring-)
* [`restoreInAppPurchase()`](#restoreinapppurchase)
* [Interfaces](#interfaces)
* [Type Aliases](#type-aliases)

</docgen-index>

<docgen-api>
<!--Update the source file JSDoc comments and rerun docgen to update the docs below-->

### echo(...)

```typescript
echo(options: { value: string; }) => Promise<{ value: string; }>
```

| Param         | Type                            |
| ------------- | ------------------------------- |
| **`options`** | <code>{ value: string; }</code> |

**Returns:** <code>Promise&lt;{ value: string; }&gt;</code>

--------------------


### canMakePayments()

```typescript
canMakePayments() => Promise<{ canMakePayments: boolean; }>
```

**Returns:** <code>Promise&lt;{ canMakePayments: boolean; }&gt;</code>

--------------------


### showApplePaySheet(...)

```typescript
showApplePaySheet(options: ApplePayRequestOptions) => Promise<{ success: boolean; }>
```

| Param         | Type                                                                      |
| ------------- | ------------------------------------------------------------------------- |
| **`options`** | <code><a href="#applepayrequestoptions">ApplePayRequestOptions</a></code> |

**Returns:** <code>Promise&lt;{ success: boolean; }&gt;</code>

--------------------


### showInAppPurchaseSheet(...)

```typescript
showInAppPurchaseSheet(options: { productIdentifiers: string[]; }) => Promise<{ success: boolean; }>
```

| Param         | Type                                           |
| ------------- | ---------------------------------------------- |
| **`options`** | <code>{ productIdentifiers: string[]; }</code> |

**Returns:** <code>Promise&lt;{ success: boolean; }&gt;</code>

--------------------


### addListener(string, ...)

```typescript
addListener(eventName: string, listenerFunc: ListenerCallback) => Promise<PluginListenerHandle>
```

| Param              | Type                                                          |
| ------------------ | ------------------------------------------------------------- |
| **`eventName`**    | <code>string</code>                                           |
| **`listenerFunc`** | <code><a href="#listenercallback">ListenerCallback</a></code> |

**Returns:** <code>Promise&lt;<a href="#pluginlistenerhandle">PluginListenerHandle</a>&gt;</code>

--------------------


### restoreInAppPurchase()

```typescript
restoreInAppPurchase() => Promise<{ success: boolean; }>
```

**Returns:** <code>Promise&lt;{ success: boolean; }&gt;</code>

--------------------


### Interfaces


#### ApplePayRequestOptions

| Prop                        | Type                                       |
| --------------------------- | ------------------------------------------ |
| **`merchantId`**            | <code>string</code>                        |
| **`countryCode`**           | <code>string</code>                        |
| **`currencyCode`**          | <code>string</code>                        |
| **`supportedNetworks`**     | <code>string[]</code>                      |
| **`merchantCapabilities`**  | <code>string[]</code>                      |
| **`paymentSummaryItems`**   | <code>PaymentSummaryItem[]</code>          |
| **`recurringSummaryItems`** | <code>RecurrentPaymentSummaryItem[]</code> |


#### PaymentSummaryItem

| Prop         | Type                |
| ------------ | ------------------- |
| **`label`**  | <code>string</code> |
| **`amount`** | <code>string</code> |


#### RecurrentPaymentSummaryItem

| Prop                | Type                                                                                  |
| ------------------- | ------------------------------------------------------------------------------------- |
| **`startDate`**     | <code>string</code>                                                                   |
| **`intervalUnit`**  | <code><a href="#recurringpaymentintervalunit">RecurringPaymentIntervalUnit</a></code> |
| **`managementURL`** | <code>string</code>                                                                   |
| **`intervalCount`** | <code>number</code>                                                                   |


#### PluginListenerHandle

| Prop         | Type                                      |
| ------------ | ----------------------------------------- |
| **`remove`** | <code>() =&gt; Promise&lt;void&gt;</code> |


### Type Aliases


#### RecurringPaymentIntervalUnit

<code>'day' | 'week' | 'month' | 'year'</code>


#### ListenerCallback

<code>(err: any, ...args: any[]): void</code>

</docgen-api>
