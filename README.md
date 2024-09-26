# apple-pay

Capacitor plugin to integrate Apple Pay into application

## Install

```bash
npm install apple-pay
npx cap sync
```

## API

<docgen-index>

* [`echo(...)`](#echo)
* [`canMakePayments()`](#canmakepayments)

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

</docgen-api>
