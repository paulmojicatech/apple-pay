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
* [Interfaces](#interfaces)

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


### Interfaces


#### ApplePayRequestOptions

| Prop                       | Type                              |
| -------------------------- | --------------------------------- |
| **`merchantId`**           | <code>string</code>               |
| **`countryCode`**          | <code>string</code>               |
| **`currencyCode`**         | <code>string</code>               |
| **`supportedNetworks`**    | <code>string[]</code>             |
| **`merchantCapabilities`** | <code>string[]</code>             |
| **`paymentSummaryItems`**  | <code>PaymentSummaryItem[]</code> |


#### PaymentSummaryItem

| Prop         | Type                |
| ------------ | ------------------- |
| **`label`**  | <code>string</code> |
| **`amount`** | <code>string</code> |

</docgen-api>
